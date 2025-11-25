// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions

// fix the errors in the code.
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future initializeUserSession() async {
  final appState = FFAppState();

  // Initialize SharedPreferences if not already done
  try {
    appState.prefs = await SharedPreferences.getInstance();
  } catch (e) {
    // Handle error if SharedPreferences fails to initialize
    print('Error initializing SharedPreferences: $e');
    return;
  }

  // Generate unique session ID if not already set
  if (appState.currentSessionId.isEmpty) {
    appState.currentSessionId = const Uuid().v4();
  }

  // Set session start time to current time
  appState.sessionStartTime = DateTime.now();

  // Initialize user timezone if not set
  if (appState.userTimezone.isEmpty) {
    appState.userTimezone = DateTime.now().timeZoneName;
  }

  // Set user cohort date if this is first time initialization
  if (appState.userCohortDate == null ||
      appState.userCohortDate ==
          DateTime.fromMillisecondsSinceEpoch(1735715700000)) {
    appState.userCohortDate = DateTime.now();
  }

  // Initialize other session-related state if needed

  if (appState.dietaryTags.isEmpty) {
    appState.dietaryTags = [];
  }

  // Notify listeners of state changes
  appState.notifyListeners();
}
