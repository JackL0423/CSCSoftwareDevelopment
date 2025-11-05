// Custom Action: checkAndLogRecipeCompletion
// Purpose: Track recipe completions for D7 Repeat Recipe Rate metric
// Location: FlutterFlow > Custom Code > Actions

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> checkAndLogRecipeCompletion(
  String recipeId,
  String recipeName,
  String cuisine,
  int prepTimeMinutes,
  String source, // "search", "featured", "recommended"
  String completionMethod, // "button" or "scroll"
) async {
  // Get current user
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('No authenticated user found');
    return;
  }

  // Get session ID from app state (assuming it's available)
  final sessionId = FFAppState().currentSessionId;

  // Check if recipe already completed in this session to prevent duplicates
  if (FFAppState().recipesCompletedThisSession.contains(recipeId)) {
    print('Recipe $recipeId already completed in this session');
    return;
  }

  // Check if minimum time spent on recipe (30 seconds)
  final recipeStartTime = FFAppState().recipeStartTime;
  if (recipeStartTime != null) {
    final timeSpent = DateTime.now().difference(recipeStartTime).inSeconds;
    if (timeSpent < 30) {
      print('Recipe viewed for less than 30 seconds, not counting as completion');
      return;
    }
  }

  // Calculate prep time bucket for analytics
  String prepTimeBucket = "0-30min";
  if (prepTimeMinutes > 30 && prepTimeMinutes <= 60) {
    prepTimeBucket = "30-60min";
  } else if (prepTimeMinutes > 60) {
    prepTimeBucket = "60+min";
  }

  // Check if this is user's first recipe ever
  bool isFirstRecipe = false;
  final completionsQuery = await FirebaseFirestore.instance
      .collection('user_recipe_completions')
      .where('user_id', isEqualTo: user.uid)
      .limit(1)
      .get();

  if (completionsQuery.docs.isEmpty) {
    isFirstRecipe = true;
    print('This is the user\'s first recipe completion!');

    // Set cohort date in YYYY-MM-DD format for easy querying
    final now = DateTime.now();
    final cohortDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // Get user's timezone (should be set during onboarding or first use)
    String userTimezone = FFAppState().userTimezone ?? 'UTC';

    // Try to detect timezone if not set
    if (userTimezone == 'UTC') {
      final timeZoneOffset = DateTime.now().timeZoneOffset;
      final hours = timeZoneOffset.inHours;
      final minutes = (timeZoneOffset.inMinutes % 60).abs();
      userTimezone = 'UTC${hours >= 0 ? '+' : ''}${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }

    // Update user document with retention tracking fields
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'first_recipe_completed_at': FieldValue.serverTimestamp(),
          'cohort_date': cohortDate,
          'd7_retention_eligible': true,
          'timezone': userTimezone,
          'total_recipes_completed': 1,
        }, SetOptions(merge: true));

    // Update app state
    FFAppState().update(() {
      FFAppState().isUserFirstRecipe = false;
      FFAppState().userCohortDate = cohortDate;
      FFAppState().userTimezone = userTimezone;
    });
  } else {
    // Increment total recipes for existing users
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
          'total_recipes_completed': FieldValue.increment(1),
          'last_recipe_completed_at': FieldValue.serverTimestamp(),
        });
  }

  // Create completion record in Firestore
  final completionData = {
    'user_id': user.uid,
    'recipe_id': recipeId,
    'recipe_name': recipeName,
    'completed_at': FieldValue.serverTimestamp(),
    'is_first_recipe': isFirstRecipe,
    'cuisine': cuisine,
    'prep_time_bucket': prepTimeBucket,
    'prep_time_minutes': prepTimeMinutes,
    'source': source,
    'session_id': sessionId,
    'user_timezone': FFAppState().userTimezone ?? 'UTC',
    'completion_method': completionMethod,
  };

  try {
    await FirebaseFirestore.instance
        .collection('user_recipe_completions')
        .add(completionData);
    print('Recipe completion recorded successfully');
  } catch (e) {
    print('Error recording recipe completion: $e');
  }

  // Log Firebase Analytics event for retention tracking
  try {
    await FirebaseAnalytics.instance.logEvent(
      name: 'recipe_complete',
      parameters: {
        'recipe_id': recipeId,
        'recipe_name': recipeName.substring(0, min(recipeName.length, 100)), // Limit to 100 chars
        'cuisine': cuisine,
        'prep_time_bucket': prepTimeBucket,
        'source': source,
        'is_first_recipe': isFirstRecipe ? 1 : 0, // Analytics prefers numbers for booleans
        'session_id': sessionId.substring(0, min(sessionId.length, 36)), // Limit to 36 chars
        'completion_method': completionMethod,
        'user_cohort': isFirstRecipe ? cohortDate : (FFAppState().userCohortDate ?? 'unknown'),
      },
    );
    print('Firebase Analytics event logged successfully');
  } catch (e) {
    print('Error logging Firebase Analytics event: $e');
  }

  // Add recipe to session completed list to prevent duplicates
  FFAppState().update(() {
    FFAppState().recipesCompletedThisSession.add(recipeId);
  });

  // Show success feedback to user (optional)
  // You can trigger a snackbar or toast here if needed
}

// Helper function for min (if not available)
int min(int a, int b) => a < b ? a : b;