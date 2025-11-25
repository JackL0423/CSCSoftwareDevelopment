import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RegionsRecord extends FirestoreRecord {
  RegionsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "regionName" field.
  String? _regionName;
  String get regionName => _regionName ?? '';
  bool hasRegionName() => _regionName != null;

  // "lastUpdated" field.
  String? _lastUpdated;
  String get lastUpdated => _lastUpdated ?? '';
  bool hasLastUpdated() => _lastUpdated != null;

  // "recipeCount" field.
  int? _recipeCount;
  int get recipeCount => _recipeCount ?? 0;
  bool hasRecipeCount() => _recipeCount != null;

  // "recipes" field.
  List<DocumentReference>? _recipes;
  List<DocumentReference> get recipes => _recipes ?? const [];
  bool hasRecipes() => _recipes != null;

  void _initializeFields() {
    _regionName = snapshotData['regionName'] as String?;
    _lastUpdated = snapshotData['lastUpdated'] as String?;
    _recipeCount = castToType<int>(snapshotData['recipeCount']);
    _recipes = getDataList(snapshotData['recipes']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('regions');

  static Stream<RegionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RegionsRecord.fromSnapshot(s));

  static Future<RegionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RegionsRecord.fromSnapshot(s));

  static RegionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RegionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RegionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RegionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RegionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RegionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRegionsRecordData({
  String? regionName,
  String? lastUpdated,
  int? recipeCount,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'regionName': regionName,
      'lastUpdated': lastUpdated,
      'recipeCount': recipeCount,
    }.withoutNulls,
  );

  return firestoreData;
}

class RegionsRecordDocumentEquality implements Equality<RegionsRecord> {
  const RegionsRecordDocumentEquality();

  @override
  bool equals(RegionsRecord? e1, RegionsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.regionName == e2?.regionName &&
        e1?.lastUpdated == e2?.lastUpdated &&
        e1?.recipeCount == e2?.recipeCount &&
        listEquality.equals(e1?.recipes, e2?.recipes);
  }

  @override
  int hash(RegionsRecord? e) => const ListEquality()
      .hash([e?.regionName, e?.lastUpdated, e?.recipeCount, e?.recipes]);

  @override
  bool isValidKey(Object? o) => o is RegionsRecord;
}
