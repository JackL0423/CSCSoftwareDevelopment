// Custom Action: checkScrollCompletion
// Purpose: Detect when user has scrolled to bottom of recipe (90% threshold)
// Location: FlutterFlow > Custom Code > Actions
// Call on: RecipeDetail page scroll listener

import 'package:flutter/material.dart';

Future<bool> checkScrollCompletion(
  ScrollController scrollController,
  double completionThreshold, // Default 0.9 (90%)
) async {
  try {
    // Get the maximum scroll extent
    final maxScroll = scrollController.position.maxScrollExtent;

    // Get the current scroll position
    final currentScroll = scrollController.position.pixels;

    // Get the viewport dimension (visible area height)
    final viewportDimension = scrollController.position.viewportDimension;

    // Calculate the total scrollable height
    final totalHeight = maxScroll + viewportDimension;

    // Calculate how much has been scrolled as a percentage
    final scrollPercentage = (currentScroll + viewportDimension) / totalHeight;

    print('Scroll percentage: ${(scrollPercentage * 100).toStringAsFixed(1)}%');

    // Check if user has scrolled past the threshold
    if (scrollPercentage >= completionThreshold) {
      print('User has scrolled ${(completionThreshold * 100).toInt()}% of recipe - marking as complete');
      return true;
    }

    return false;
  } catch (e) {
    print('Error checking scroll completion: $e');
    return false;
  }
}

// Alternative version that can be used with a scroll notification
Future<bool> checkScrollCompletionFromNotification(
  ScrollNotification notification,
  double completionThreshold, // Default 0.9 (90%)
) async {
  try {
    // Only process scroll update notifications
    if (notification is! ScrollUpdateNotification) {
      return false;
    }

    // Get scroll metrics
    final metrics = notification.metrics;

    // Calculate the total scrollable height
    final totalHeight = metrics.maxScrollExtent + metrics.viewportDimension;

    // Calculate current position including viewport
    final currentPosition = metrics.pixels + metrics.viewportDimension;

    // Calculate scroll percentage
    final scrollPercentage = currentPosition / totalHeight;

    // Check if user has scrolled past the threshold
    if (scrollPercentage >= completionThreshold) {
      print('User has scrolled ${(completionThreshold * 100).toInt()}% of recipe');

      // Check if we haven't already logged this completion
      final currentRecipeId = FFAppState().currentRecipeId;
      if (currentRecipeId != null &&
          !FFAppState().recipesCompletedThisSession.contains(currentRecipeId)) {
        return true;
      }
    }

    return false;
  } catch (e) {
    print('Error checking scroll completion from notification: $e');
    return false;
  }
}

// Helper function to calculate time spent on recipe
Duration calculateTimeOnRecipe() {
  final startTime = FFAppState().recipeStartTime;
  if (startTime != null) {
    return DateTime.now().difference(startTime);
  }
  return Duration.zero;
}

// Helper function to check if minimum time requirement is met
bool hasMetMinimumTimeRequirement({Duration minimumTime = const Duration(seconds: 30)}) {
  final timeSpent = calculateTimeOnRecipe();
  return timeSpent >= minimumTime;
}