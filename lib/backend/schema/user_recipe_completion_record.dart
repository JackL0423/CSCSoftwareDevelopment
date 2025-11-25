import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// - user_id (String)
///   - recipe_id (String)
///   - recipe_name (String)
///   - cuisine (String)
///   - completed_at (DateTime)
///   - session_id (String)
///   - is_first_recipe (Boolean)
///   - scroll_percentage (Double)
class UserRecipeCompletionRecord extends FirestoreRecord {
  UserRecipeCompletionRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "recipe_name" field.
  String? _recipeName;
  String get recipeName => _recipeName ?? '';
  bool hasRecipeName() => _recipeName != null;

  // "cuisine" field.
  String? _cuisine;
  String get cuisine => _cuisine ?? '';
  bool hasCuisine() => _cuisine != null;

  // "completed_at" field.
  DateTime? _completedAt;
  DateTime? get completedAt => _completedAt;
  bool hasCompletedAt() => _completedAt != null;

  // "session_id" field.
  String? _sessionId;
  String get sessionId => _sessionId ?? '';
  bool hasSessionId() => _sessionId != null;

  // "is_first_recipe" field.
  bool? _isFirstRecipe;
  bool get isFirstRecipe => _isFirstRecipe ?? false;
  bool hasIsFirstRecipe() => _isFirstRecipe != null;

  // "scroll_percentage" field.
  double? _scrollPercentage;
  double get scrollPercentage => _scrollPercentage ?? 0.0;
  bool hasScrollPercentage() => _scrollPercentage != null;

  // "User" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  void _initializeFields() {
    _recipeName = snapshotData['recipe_name'] as String?;
    _cuisine = snapshotData['cuisine'] as String?;
    _completedAt = snapshotData['completed_at'] as DateTime?;
    _sessionId = snapshotData['session_id'] as String?;
    _isFirstRecipe = snapshotData['is_first_recipe'] as bool?;
    _scrollPercentage = castToType<double>(snapshotData['scroll_percentage']);
    _user = snapshotData['User'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('user_recipe_completion');

  static Stream<UserRecipeCompletionRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => UserRecipeCompletionRecord.fromSnapshot(s));

  static Future<UserRecipeCompletionRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => UserRecipeCompletionRecord.fromSnapshot(s));

  static UserRecipeCompletionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserRecipeCompletionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserRecipeCompletionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserRecipeCompletionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserRecipeCompletionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserRecipeCompletionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserRecipeCompletionRecordData({
  String? recipeName,
  String? cuisine,
  DateTime? completedAt,
  String? sessionId,
  bool? isFirstRecipe,
  double? scrollPercentage,
  DocumentReference? user,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'recipe_name': recipeName,
      'cuisine': cuisine,
      'completed_at': completedAt,
      'session_id': sessionId,
      'is_first_recipe': isFirstRecipe,
      'scroll_percentage': scrollPercentage,
      'User': user,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserRecipeCompletionRecordDocumentEquality
    implements Equality<UserRecipeCompletionRecord> {
  const UserRecipeCompletionRecordDocumentEquality();

  @override
  bool equals(UserRecipeCompletionRecord? e1, UserRecipeCompletionRecord? e2) {
    return e1?.recipeName == e2?.recipeName &&
        e1?.cuisine == e2?.cuisine &&
        e1?.completedAt == e2?.completedAt &&
        e1?.sessionId == e2?.sessionId &&
        e1?.isFirstRecipe == e2?.isFirstRecipe &&
        e1?.scrollPercentage == e2?.scrollPercentage &&
        e1?.user == e2?.user;
  }

  @override
  int hash(UserRecipeCompletionRecord? e) => const ListEquality().hash([
        e?.recipeName,
        e?.cuisine,
        e?.completedAt,
        e?.sessionId,
        e?.isFirstRecipe,
        e?.scrollPercentage,
        e?.user
      ]);

  @override
  bool isValidKey(Object? o) => o is UserRecipeCompletionRecord;
}
