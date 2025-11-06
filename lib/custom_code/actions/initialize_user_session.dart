// Automatic FlutterFlow imports (do not remove)
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

// Custom imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:uuid/uuid.dart';

/// Custom Action: initializeUserSession
/// Purpose: Initialize session tracking for D7 retention metrics
/// Call on: App initialization, login success, GoldenPath page load
Future<void> initializeUserSession() async {
  // Generate new session ID using UUID
  final uuid = Uuid();
  final sessionId = uuid.v4();

  // Set session start time
  final sessionStartTime = DateTime.now();

  // Clear previous session data
  FFAppState().update(() {
    FFAppState().currentSessionId = sessionId;
    FFAppState().sessionStartTime = sessionStartTime;
    FFAppState().recipesCompletedThisSession = [];
  });

  // Get current user
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('No authenticated user, session initialized for anonymous browsing');
    return;
  }

  // Check if user has completed any recipes before (for first recipe tracking)
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data();

      // Check if user has completed their first recipe
      if (userData?['first_recipe_completed_at'] != null) {
        FFAppState().update(() {
          FFAppState().isUserFirstRecipe = false;
          FFAppState().userCohortDate = (userData?['cohort_date'] as Timestamp?)?.toDate();
          FFAppState().userTimezone = userData?['timezone'] ?? 'UTC';
        });
      } else {
        // User hasn't completed any recipe yet
        FFAppState().update(() {
          FFAppState().isUserFirstRecipe = true;
        });
      }

      // Log session_start event for retention analysis
      await FirebaseAnalytics.instance.logEvent(
        name: 'session_start',
        parameters: {
          'session_id': sessionId,
          'user_id': user.uid,
          'is_returning_user': userData?['first_recipe_completed_at'] != null ? 1 : 0,
          'total_recipes_completed': userData?['total_recipes_completed'] ?? 0,
          'cohort_date': userData?['cohort_date'] != null
              ? (userData!['cohort_date'] as Timestamp).toDate().toString().split(' ')[0]
              : 'not_set',
        },
      );

      print('Session initialized for user: ${user.uid}');
    } else {
      // New user, hasn't completed any recipes
      FFAppState().update(() {
        FFAppState().isUserFirstRecipe = true;
      });

      print('Session initialized for new user: ${user.uid}');
    }
  } catch (e) {
    print('Error initializing user session: $e');
  }

  // Detect and set timezone if not already set
  if (FFAppState().userTimezone == null || FFAppState().userTimezone == '') {
    final timeZoneOffset = DateTime.now().timeZoneOffset;
    final hours = timeZoneOffset.inHours;
    final minutes = (timeZoneOffset.inMinutes % 60).abs();
    final timezone = 'UTC${hours >= 0 ? '+' : ''}${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    FFAppState().update(() {
      FFAppState().userTimezone = timezone;
    });

    print('Timezone detected and set: $timezone');
  }
}
