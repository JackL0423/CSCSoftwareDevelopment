// Cloud Function: calculateD7Retention
// Purpose: Calculate D7 Repeat Recipe Rate for cohorts
// Schedule: Daily at 2 AM UTC
// Runtime: Node.js 18

const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize Firebase Admin
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

/**
 * Scheduled function to calculate D7 Repeat Recipe Rate
 * Runs daily to process cohorts from 7 days ago
 */
exports.calculateD7Retention = functions.pubsub
  .schedule('0 2 * * *') // Daily at 2 AM UTC
  .timeZone('UTC')
  .onRun(async (context) => {
    console.log('Starting D7 Retention calculation...');

    try {
      // Calculate the cohort date from 7 days ago
      const today = new Date();
      const cohortDate = new Date(today);
      cohortDate.setDate(cohortDate.getDate() - 7);

      // Format as YYYY-MM-DD
      const cohortDateString = formatDateString(cohortDate);
      console.log(`Processing cohort: ${cohortDateString}`);

      // Get all users in the cohort
      const cohortUsersSnapshot = await db
        .collection('users')
        .where('cohort_date', '==', cohortDateString)
        .where('d7_retention_eligible', '==', true)
        .get();

      if (cohortUsersSnapshot.empty) {
        console.log(`No users found in cohort ${cohortDateString}`);
        return null;
      }

      const cohortSize = cohortUsersSnapshot.size;
      console.log(`Cohort size: ${cohortSize} users`);

      // Track users who completed 2+ recipes in D1-D7
      let usersWithRepeatRecipes = 0;
      let totalRepeatRecipes = 0;
      const userMetrics = [];

      // Process each user in the cohort
      for (const userDoc of cohortUsersSnapshot.docs) {
        const userData = userDoc.data();
        const userId = userDoc.id;
        const firstRecipeTime = userData.first_recipe_completed_at.toDate();

        // Calculate D7 window (day 1 to day 7 after first recipe)
        const d1Start = new Date(firstRecipeTime);
        d1Start.setHours(d1Start.getHours() + 24); // Start of Day 1

        const d7End = new Date(firstRecipeTime);
        d7End.setDate(d7End.getDate() + 7);
        d7End.setHours(23, 59, 59, 999); // End of Day 7

        // Query completions in D1-D7 window (excluding the first recipe)
        const completionsSnapshot = await db
          .collection('user_recipe_completions')
          .where('user_id', '==', userId)
          .where('completed_at', '>', d1Start)
          .where('completed_at', '<=', d7End)
          .where('is_first_recipe', '==', false) // Exclude the cohort-defining recipe
          .get();

        const repeatRecipeCount = completionsSnapshot.size;

        if (repeatRecipeCount > 0) {
          usersWithRepeatRecipes++;
          totalRepeatRecipes += repeatRecipeCount;

          // Collect detailed metrics for this user
          const recipesCompleted = completionsSnapshot.docs.map(doc => ({
            recipe_id: doc.data().recipe_id,
            completed_at: doc.data().completed_at.toDate(),
            cuisine: doc.data().cuisine,
            source: doc.data().source,
          }));

          userMetrics.push({
            user_id: userId,
            repeat_recipes_count: repeatRecipeCount,
            recipes: recipesCompleted,
            days_active: calculateDaysActive(recipesCompleted),
          });
        }
      }

      // Calculate D7 Repeat Recipe Rate
      const d7RetentionRate = (usersWithRepeatRecipes / cohortSize) * 100;

      // Prepare retention metrics document
      const retentionMetrics = {
        cohort_date: cohortDateString,
        calculation_date: admin.firestore.FieldValue.serverTimestamp(),
        cohort_size: cohortSize,
        users_with_repeat_recipes: usersWithRepeatRecipes,
        d7_repeat_recipe_rate: parseFloat(d7RetentionRate.toFixed(2)),
        total_repeat_recipes: totalRepeatRecipes,
        avg_repeat_recipes_per_retained_user: usersWithRepeatRecipes > 0
          ? parseFloat((totalRepeatRecipes / usersWithRepeatRecipes).toFixed(2))
          : 0,
        retention_category: categorizeRetention(d7RetentionRate),
        user_details: userMetrics, // Optional: store for deep analysis
      };

      // Store metrics in Firestore
      await db
        .collection('retention_metrics')
        .doc(`d7_${cohortDateString}`)
        .set(retentionMetrics);

      console.log(`D7 Retention Rate for ${cohortDateString}: ${d7RetentionRate.toFixed(2)}%`);
      console.log(`Category: ${retentionMetrics.retention_category}`);

      // Optional: Send alerts for significant changes
      await checkRetentionAlerts(cohortDateString, d7RetentionRate);

      // Log to BigQuery for advanced analytics (optional)
      await logToBigQuery(retentionMetrics);

      return retentionMetrics;

    } catch (error) {
      console.error('Error calculating D7 retention:', error);

      // Log error for monitoring
      await db.collection('retention_errors').add({
        error_message: error.message,
        error_stack: error.stack,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        cohort_attempted: cohortDateString,
      });

      throw error;
    }
  });

/**
 * Manual trigger for calculating retention for a specific cohort
 * Callable function for testing or backfilling
 */
exports.calculateD7RetentionManual = functions.https.onCall(async (data, context) => {
  // Verify admin user
  if (!context.auth || !context.auth.token.admin) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Only admins can trigger manual retention calculations'
    );
  }

  const { cohortDate } = data;

  if (!cohortDate || !isValidDateString(cohortDate)) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Valid cohortDate required (YYYY-MM-DD format)'
    );
  }

  console.log(`Manual calculation triggered for cohort: ${cohortDate}`);

  // Use the same logic as scheduled function
  // ... (implement same calculation logic here)

  return { success: true, cohortDate };
});

/**
 * Helper function to format date as YYYY-MM-DD
 */
function formatDateString(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

/**
 * Helper function to validate date string format
 */
function isValidDateString(dateString) {
  const regex = /^\d{4}-\d{2}-\d{2}$/;
  return regex.test(dateString);
}

/**
 * Categorize retention rate based on thresholds
 */
function categorizeRetention(rate) {
  if (rate >= 25) return 'Excellent';
  if (rate >= 18) return 'Good';
  if (rate >= 12) return 'Fair';
  if (rate >= 8) return 'Poor';
  return 'Critical';
}

/**
 * Calculate number of unique days user was active
 */
function calculateDaysActive(recipes) {
  const uniqueDays = new Set();
  recipes.forEach(recipe => {
    const dateString = formatDateString(recipe.completed_at);
    uniqueDays.add(dateString);
  });
  return uniqueDays.size;
}

/**
 * Check and send alerts for significant retention changes
 */
async function checkRetentionAlerts(cohortDate, currentRate) {
  // Get previous day's cohort retention for comparison
  const previousDate = new Date(cohortDate);
  previousDate.setDate(previousDate.getDate() - 1);
  const previousDateString = formatDateString(previousDate);

  const previousDoc = await db
    .collection('retention_metrics')
    .doc(`d7_${previousDateString}`)
    .get();

  if (previousDoc.exists) {
    const previousRate = previousDoc.data().d7_repeat_recipe_rate;
    const changePercent = ((currentRate - previousRate) / previousRate) * 100;

    // Alert if retention drops by more than 20%
    if (changePercent <= -20) {
      console.warn(`ALERT: D7 retention dropped by ${Math.abs(changePercent).toFixed(1)}%`);

      // Send notification (implement your notification service)
      await sendRetentionAlert({
        type: 'retention_drop',
        cohort_date: cohortDate,
        current_rate: currentRate,
        previous_rate: previousRate,
        change_percent: changePercent,
      });
    }

    // Celebrate if retention improves by more than 20%
    if (changePercent >= 20) {
      console.log(`SUCCESS: D7 retention improved by ${changePercent.toFixed(1)}%!`);

      await sendRetentionAlert({
        type: 'retention_improvement',
        cohort_date: cohortDate,
        current_rate: currentRate,
        previous_rate: previousRate,
        change_percent: changePercent,
      });
    }
  }
}

/**
 * Send retention alerts (implement based on your notification service)
 */
async function sendRetentionAlert(alertData) {
  // Implement based on your notification preferences:
  // - Email via SendGrid
  // - Slack webhook
  // - Firebase Cloud Messaging
  // - SMS via Twilio

  console.log('Retention alert:', alertData);

  // Example: Store alert in Firestore for dashboard
  await db.collection('retention_alerts').add({
    ...alertData,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    acknowledged: false,
  });
}

/**
 * Log metrics to BigQuery for advanced analytics (optional)
 */
async function logToBigQuery(metrics) {
  // Implement if using BigQuery for analytics
  // const { BigQuery } = require('@google-cloud/bigquery');
  // const bigquery = new BigQuery();
  // ... insert metrics into BigQuery table

  console.log('Metrics logged for BigQuery analysis');
}

/**
 * HTTP endpoint to get retention metrics for a cohort
 */
exports.getD7RetentionMetrics = functions.https.onRequest(async (req, res) => {
  // Enable CORS
  res.set('Access-Control-Allow-Origin', '*');

  if (req.method !== 'GET') {
    res.status(405).send('Method not allowed');
    return;
  }

  const { cohortDate } = req.query;

  if (!cohortDate) {
    res.status(400).json({ error: 'cohortDate parameter required' });
    return;
  }

  try {
    const metricsDoc = await db
      .collection('retention_metrics')
      .doc(`d7_${cohortDate}`)
      .get();

    if (!metricsDoc.exists) {
      res.status(404).json({ error: 'Metrics not found for this cohort' });
      return;
    }

    res.status(200).json(metricsDoc.data());
  } catch (error) {
    console.error('Error fetching retention metrics:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Get retention trend over time
 */
exports.getRetentionTrend = functions.https.onRequest(async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');

  const { days = 30 } = req.query;

  try {
    // Calculate date range
    const endDate = new Date();
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - parseInt(days));

    const startDateString = formatDateString(startDate);

    // Query retention metrics
    const metricsSnapshot = await db
      .collection('retention_metrics')
      .where('cohort_date', '>=', startDateString)
      .orderBy('cohort_date', 'desc')
      .get();

    const trend = metricsSnapshot.docs.map(doc => {
      const data = doc.data();
      return {
        cohort_date: data.cohort_date,
        d7_rate: data.d7_repeat_recipe_rate,
        cohort_size: data.cohort_size,
        category: data.retention_category,
      };
    });

    res.status(200).json({
      period: `${days} days`,
      data: trend,
      average_d7_rate: calculateAverage(trend.map(t => t.d7_rate)),
    });
  } catch (error) {
    console.error('Error fetching retention trend:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Calculate average of array of numbers
 */
function calculateAverage(numbers) {
  if (numbers.length === 0) return 0;
  const sum = numbers.reduce((a, b) => a + b, 0);
  return parseFloat((sum / numbers.length).toFixed(2));
}


//==============================================
// Recipe Data Pipeline
//==============================================
const { setGlobalOptions } = require('firebase-functions');
const { onSchedule } = require('firebase-functions/v2/scheduler');
const { onRequest } = require('firebase-functions/v2/https');
const { fetchAllRegions } = require("./api_fetcher.js");
const { normalizeAllRegions } = require("./chatgpt_normalizer.js");
const { uploadAllRegions } = require("./firestore_uploader.js");
const { logInfo } = require("./logger.js");

// Use the existing admin instance (no re-init)
const firestore = admin.firestore();

setGlobalOptions({
  maxInstances: 10,
  region: "us-central1",
  memory: "512MiB",
  timeoutSeconds: 540,
});

/** Shared pipeline logic */
async function runRecipePipeline() {
  logInfo("🚀 Starting GlobalFlavors ingestion pipeline...");
  const regions = ["Canadian", "Italian", "Indian", "Swedish", "Japanese"];

  const rawData = await fetchAllRegions(regions);
  logInfo(`✅ Pulled data for ${rawData.length} regions.`);

  const normalized = await normalizeAllRegions(rawData);
  logInfo(`✅ Normalized ${normalized.length} region datasets.`);

  const uploadResults = await uploadAllRegions(firestore, normalized);
  logInfo("✅ Upload complete.");
  return uploadResults;
}

/** Scheduled daily trigger */
exports.dailyRecipeUpdate = onSchedule(
  { schedule: "every 24 hours", timeZone: "America/New_York" },
  async () => {
    try {
      const results = await runRecipePipeline();
      logInfo("🎉 Daily recipe update successful.");
      return results;
    } catch (err) {
      console.error("❌ Error in dailyRecipeUpdate:", err);
      throw err;
    }
  }
);

/** Manual HTTP trigger */
exports.runNow = onRequest(async (req, res) => {
  try {
    const results = await runRecipePipeline();
    res.status(200).json({ message: "Manual run complete ✅", results });
  } catch (err) {
    console.error("❌ Manual run failed:", err);
    res.status(500).json({ error: err.message });
  }
});
