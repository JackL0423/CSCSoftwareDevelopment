import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecipeCompletionRecord extends FirestoreRecord {
  RecipeCompletionRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "completionTime" field.
  String? _completionTime;
  String get completionTime => _completionTime ?? '';
  bool hasCompletionTime() => _completionTime != null;

  // "region" field.
  DocumentReference? _region;
  DocumentReference? get region => _region;
  bool hasRegion() => _region != null;

  // "recipe" field.
  DocumentReference? _recipe;
  DocumentReference? get recipe => _recipe;
  bool hasRecipe() => _recipe != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _completionTime = snapshotData['completionTime'] as String?;
    _region = snapshotData['region'] as DocumentReference?;
    _recipe = snapshotData['recipe'] as DocumentReference?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('recipeCompletion')
          : FirebaseFirestore.instance.collectionGroup('recipeCompletion');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('recipeCompletion').doc(id);

  static Stream<RecipeCompletionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RecipeCompletionRecord.fromSnapshot(s));

  static Future<RecipeCompletionRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => RecipeCompletionRecord.fromSnapshot(s));

  static RecipeCompletionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RecipeCompletionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RecipeCompletionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RecipeCompletionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RecipeCompletionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RecipeCompletionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRecipeCompletionRecordData({
  String? completionTime,
  DocumentReference? region,
  DocumentReference? recipe,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'completionTime': completionTime,
      'region': region,
      'recipe': recipe,
    }.withoutNulls,
  );

  return firestoreData;
}

class RecipeCompletionRecordDocumentEquality
    implements Equality<RecipeCompletionRecord> {
  const RecipeCompletionRecordDocumentEquality();

  @override
  bool equals(RecipeCompletionRecord? e1, RecipeCompletionRecord? e2) {
    return e1?.completionTime == e2?.completionTime &&
        e1?.region == e2?.region &&
        e1?.recipe == e2?.recipe;
  }

  @override
  int hash(RecipeCompletionRecord? e) =>
      const ListEquality().hash([e?.completionTime, e?.region, e?.recipe]);

  @override
  bool isValidKey(Object? o) => o is RecipeCompletionRecord;
}
