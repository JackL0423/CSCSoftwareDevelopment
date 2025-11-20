# FlutterFlow Custom Actions Update Guide
## Replacing Hardcoded API Keys with Cloud Function Proxy

**Created**: 2025-11-19
**Purpose**: Step-by-step guide to update FlutterFlow Custom Actions to use Gemini proxy Cloud Functions
**Estimated Time**: 30 minutes

---

## Overview

This guide covers updating 3 FlutterFlow Custom Actions to call Cloud Functions instead of using hardcoded API keys:

1. `geminiGenerateText`
2. `geminiCountTokens`
3. `geminiTextFromImage`

**⚠️ IMPORTANT**: These changes must be done in the FlutterFlow UI. The FlutterFlow API does not support updating Custom Actions.

---

## Prerequisites

- [x] Cloud Functions deployed (check with: `firebase functions:list`)
- [x] FlutterFlow project open in browser
- [x] Growth Plan active (for Custom Actions access)

---

## Step 1: Backup Existing Custom Actions

Before making changes, save backups of current custom actions:

```bash
# Create backup directory
mkdir -p scripts/flutterflow-backups/custom-actions-$(date +%Y%m%d)

# Note: You'll need to manually copy-paste the code from FlutterFlow UI
# Save each custom action's code to:
# scripts/flutterflow-backups/custom-actions-20251119/geminiGenerateText-original.dart
# scripts/flutterflow-backups/custom-actions-20251119/geminiCountTokens-original.dart
# scripts/flutterflow-backups/custom-actions-20251119/geminiTextFromImage-original.dart
```

---

## Step 2: Update geminiGenerateText Custom Action

### 2.1 Open FlutterFlow Custom Code

1. Navigate to **Custom Code** → **Custom Actions**
2. Find `geminiGenerateText`
3. Click **Edit**

### 2.2 Replace Code

**OLD CODE** (remove this):
```dart
import 'package:google_generative_ai/google_generative_ai.dart';

const _kGeminiApiKey = '[REDACTED-OLD-GEMINI-KEY]';  // ❌ REMOVE

Future<String> geminiGenerateText(String prompt) async {
  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _kGeminiApiKey,  // ❌ Hardcoded key
  );

  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  return response.text ?? '';
}
```

**NEW CODE** (paste this):
```dart
import 'package:cloud_functions/cloud_functions.dart';

/// Generates text using Gemini AI via secure Cloud Function proxy
///
/// This function calls a Firebase Cloud Function that:
/// - Loads the API key from GCP Secret Manager (not hardcoded)
/// - Enforces rate limiting (100 requests/hour/user)
/// - Requires authentication
///
/// Parameters:
///   - prompt: The text prompt for Gemini
///   - model: (Optional) Gemini model to use (default: 'gemini-2.5-flash')
///
/// Returns: Generated text string
///
/// Throws: FirebaseFunctionsException if call fails
Future<String> geminiGenerateText(
  String prompt, {
  String model = 'gemini-2.5-flash',
}) async {
  try {
    // Call Cloud Function
    final callable = FirebaseFunctions.instance.httpsCallable('geminiGenerateText');
    final result = await callable.call({
      'prompt': prompt,
      'model': model,
    });

    // Extract text from response
    final responseData = result.data as Map<String, dynamic>;
    return responseData['text'] as String? ?? '';

  } on FirebaseFunctionsException catch (e) {
    // Handle specific error cases
    if (e.code == 'unauthenticated') {
      throw Exception('User must be logged in to use Gemini');
    } else if (e.code == 'resource-exhausted') {
      throw Exception('Rate limit exceeded: ${e.message}');
    } else if (e.code == 'invalid-argument') {
      throw Exception('Invalid input: ${e.message}');
    } else {
      throw Exception('Gemini API error: ${e.message}');
    }
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
}
```

### 2.3 Update Dependencies

If prompted to add dependencies, add:
- `cloud_functions: ^4.0.0`

(Remove `google_generative_ai` if no longer used elsewhere)

### 2.4 Test the Action

1. Click **Test** in FlutterFlow UI
2. Enter a test prompt: "Say hello in 3 words"
3. Verify response is returned
4. Check for errors

---

## Step 3: Update geminiCountTokens Custom Action

### 3.1 Navigate to Custom Action

1. Go to **Custom Code** → **Custom Actions**
2. Find `geminiCountTokens`
3. Click **Edit**

### 3.2 Replace Code

**OLD CODE** (remove):
```dart
import 'package:google_generative_ai/google_generative_ai.dart';

const _kGeminiApiKey = '[REDACTED-OLD-GEMINI-KEY]';  // ❌ REMOVE

Future<int> geminiCountTokens(String text) async {
  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _kGeminiApiKey,
  );

  final result = await model.countTokens([Content.text(text)]);
  return result.totalTokens;
}
```

**NEW CODE** (paste):
```dart
import 'package:cloud_functions/cloud_functions.dart';

/// Counts tokens in text using Gemini AI via secure Cloud Function
///
/// Parameters:
///   - text: The text to count tokens for
///   - model: (Optional) Gemini model to use (default: 'gemini-2.5-flash')
///
/// Returns: Total token count (int)
Future<int> geminiCountTokens(
  String text, {
  String model = 'gemini-2.5-flash',
}) async {
  try {
    final callable = FirebaseFunctions.instance.httpsCallable('geminiCountTokens');
    final result = await callable.call({
      'text': text,
      'model': model,
    });

    final responseData = result.data as Map<String, dynamic>;
    return responseData['totalTokens'] as int? ?? 0;

  } on FirebaseFunctionsException catch (e) {
    if (e.code == 'unauthenticated') {
      throw Exception('User must be logged in');
    }
    throw Exception('Token count error: ${e.message}');
  }
}
```

### 3.3 Test

1. Click **Test**
2. Enter test text: "Hello world"
3. Verify token count is returned (should be ~2-3 tokens)

---

## Step 4: Update geminiTextFromImage Custom Action

### 4.1 Navigate to Custom Action

1. Go to **Custom Code** → **Custom Actions**
2. Find `geminiTextFromImage`
3. Click **Edit**

### 4.2 Replace Code

**OLD CODE** (remove):
```dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

const _kGeminiApiKey = '[REDACTED-OLD-GEMINI-KEY]';  // ❌ REMOVE

Future<String> geminiTextFromImage(String prompt, String imageBase64) async {
  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _kGeminiApiKey,
  );

  final imagePart = DataPart('image/jpeg', base64Decode(imageBase64));
  final textPart = TextPart(prompt);

  final response = await model.generateContent([
    Content.multi([textPart, imagePart])
  ]);

  return response.text ?? '';
}
```

**NEW CODE** (paste):
```dart
import 'package:cloud_functions/cloud_functions.dart';

/// Extracts text from image using Gemini vision API via Cloud Function
///
/// Parameters:
///   - prompt: The prompt/question about the image
///   - imageBase64: Base64-encoded image data
///   - mimeType: (Optional) Image MIME type (default: 'image/jpeg')
///   - model: (Optional) Gemini model to use (default: 'gemini-2.5-flash')
///
/// Returns: Generated text describing/analyzing the image
Future<String> geminiTextFromImage(
  String prompt,
  String imageBase64, {
  String mimeType = 'image/jpeg',
  String model = 'gemini-2.5-flash',
}) async {
  try {
    final callable = FirebaseFunctions.instance.httpsCallable('geminiTextFromImage');
    final result = await callable.call({
      'prompt': prompt,
      'imageData': imageBase64,
      'mimeType': mimeType,
      'model': model,
    });

    final responseData = result.data as Map<String, dynamic>;
    return responseData['text'] as String? ?? '';

  } on FirebaseFunctionsException catch (e) {
    if (e.code == 'unauthenticated') {
      throw Exception('User must be logged in');
    } else if (e.code == 'resource-exhausted') {
      throw Exception('Rate limit exceeded: ${e.message}');
    }
    throw Exception('Vision API error: ${e.message}');
  }
}
```

### 4.3 Test

1. Click **Test**
2. Provide test image (base64 encoded)
3. Enter prompt: "Describe this image"
4. Verify response

---

## Step 5: Verify All Changes

### 5.1 Search for Hardcoded Keys

1. In FlutterFlow, use **Search** (Ctrl+F)
2. Search for: `AIzaSy`
3. Verify **NO results** in Custom Actions
4. If found, remove all hardcoded keys

### 5.2 Test All Actions End-to-End

1. Run FlutterFlow app in **Test Mode**
2. Navigate to pages that use Gemini custom actions
3. Trigger each action:
   - Generate text
   - Count tokens
   - Extract text from image
4. Verify all work correctly

### 5.3 Check Cloud Function Logs

```bash
# Monitor Cloud Function logs during testing
firebase functions:log --only geminiGenerateText --limit 10

# Check for errors
firebase functions:log --only geminiGenerateText,geminiCountTokens,geminiTextFromImage | grep ERROR
```

---

## Step 6: Remove Old Dependencies (Optional)

If `google_generative_ai` package is no longer used:

1. Go to **Settings** → **Dependencies**
2. Find `google_generative_ai`
3. Click **Remove**
4. **Save** and **Test** again

---

## Troubleshooting

### Error: "unauthenticated"

**Cause**: User not logged in
**Solution**: Ensure Firebase Auth is set up and user is authenticated before calling custom actions

### Error: "resource-exhausted"

**Cause**: Rate limit (100 req/hr) exceeded
**Solution**: Wait 1 hour or contact admin to increase limit

### Error: "Cloud Functions not found"

**Cause**: Functions not deployed or wrong project
**Solution**:
```bash
# Verify deployment
firebase functions:list --project csc-305-dev-project

# Redeploy if needed
firebase deploy --only functions
```

### Error: "Failed to load API credentials"

**Cause**: Secret Manager access issue
**Solution**: Verify service account has `roles/secretmanager.secretAccessor` role:
```bash
gcloud secrets get-iam-policy VERTEX_API_KEY --project=csc305project-475802
```

---

## Rollback Procedure

If issues arise, revert to original code:

1. Open backed-up original code from `scripts/flutterflow-backups/`
2. Paste original code back into Custom Actions
3. Re-add `google_generative_ai` dependency if removed
4. Test original functionality

---

## Post-Update Checklist

- [ ] All 3 custom actions updated
- [ ] Dependencies updated (`cloud_functions` added)
- [ ] Search confirms no hardcoded `AIzaSy` keys remain
- [ ] End-to-end testing passed in FlutterFlow Test Mode
- [ ] Cloud Function logs show successful calls
- [ ] Original code backed up
- [ ] Team notified of changes

---

## Next Steps After Completion

1. **Push to GitHub**: Test FlutterFlow "Push to Repository" feature
2. **Monitor Usage**: Check Firestore `rate_limits` collection for user activity
3. **Rotate API Key**: Delete the exposed hardcoded key from GCP Console
4. **Update Documentation**: Mark this task as complete in project docs

---

**Status**: ⚠️ MANUAL STEPS REQUIRED (FlutterFlow UI)
**Estimated Time**: 30 minutes
**Difficulty**: Medium (copy-paste with testing)

**Questions?** See Cloud Function logs or test script output for debugging.
