// Automatic FlutterFlow imports (do not remove)
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

/// Custom Action: checkScrollCompletion
/// Purpose: Detect when user has scrolled to bottom of recipe (90% threshold)
/// Returns: true if user has scrolled past threshold, false otherwise
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

      // Check if we haven't already logged this completion
      final currentRecipeId = FFAppState().currentRecipeId;
      if (currentRecipeId != null &&
          currentRecipeId.isNotEmpty &&
          !FFAppState().recipesCompletedThisSession.contains(currentRecipeId)) {
        // Check minimum time requirement (30 seconds)
        final recipeStartTime = FFAppState().recipeStartTime;
        if (recipeStartTime != null) {
          final timeSpent = DateTime.now().difference(recipeStartTime);
          if (timeSpent.inSeconds >= 30) {
            return true;
          } else {
            print('Minimum time requirement not met (${timeSpent.inSeconds}s < 30s)');
            return false;
          }
        }
      }
    }

    return false;
  } catch (e) {
    print('Error checking scroll completion: $e');
    return false;
  }
}
