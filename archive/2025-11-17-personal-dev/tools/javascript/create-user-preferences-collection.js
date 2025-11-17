#!/usr/bin/env node

/**
 * Create user_preferences collection in Firestore
 * This collection stores user dietary preferences and tags
 */

const admin = require('firebase-admin');

// Initialize Firebase Admin with credentials from environment
const serviceAccount = require(process.env.GOOGLE_APPLICATION_CREDENTIALS);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function createUserPreferencesCollection() {
  console.log('🔧 Creating user_preferences collection...\n');

  // Create a sample user preferences document structure
  const samplePreference = {
    userId: 'sample_user_123',
    email: 'sample@example.com',
    prefTags: ['vegetarian', 'quick-meals', 'italian'],
    dietTags: ['gluten-free', 'dairy-free'],
    favoriteRecipes: [],
    completedRecipes: [],
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  };

  try {
    // Create the collection with a sample document
    const docRef = db.collection('user_preferences').doc('sample_user_123');
    await docRef.set(samplePreference);

    console.log('✅ Created user_preferences collection');
    console.log('✅ Added sample document: sample_user_123');
    console.log('\nCollection Structure:');
    console.log('- userId: string (user ID)');
    console.log('- email: string (user email)');
    console.log('- prefTags: array<string> (preference tags)');
    console.log('- dietTags: array<string> (dietary restriction tags)');
    console.log('- favoriteRecipes: array<string> (recipe IDs)');
    console.log('- completedRecipes: array<string> (recipe IDs)');
    console.log('- createdAt: timestamp');
    console.log('- updatedAt: timestamp');

    // Create an index document to help with querying
    const indexDoc = db.collection('user_preferences').doc('_index');
    await indexDoc.set({
      collectionInfo: 'User preferences and dietary restrictions',
      documentCount: 1,
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      schema: {
        userId: 'string',
        email: 'string',
        prefTags: 'array<string>',
        dietTags: 'array<string>',
        favoriteRecipes: 'array<string>',
        completedRecipes: 'array<string>',
        createdAt: 'timestamp',
        updatedAt: 'timestamp'
      }
    });

    console.log('\n✅ Created _index document for schema reference');
    console.log('\n🎉 Collection setup complete!');

  } catch (error) {
    console.error('❌ Error creating collection:', error);
    process.exit(1);
  }

  process.exit(0);
}

// Run the function
createUserPreferencesCollection();
