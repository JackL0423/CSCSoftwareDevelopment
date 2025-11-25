import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UPrefRecord extends FirestoreRecord {
  UPrefRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "favoriteRecipes" field.
  List<DocumentReference>? _favoriteRecipes;
  List<DocumentReference> get favoriteRecipes => _favoriteRecipes ?? const [];
  bool hasFavoriteRecipes() => _favoriteRecipes != null;

  // "dietTag" field.
  List<String>? _dietTag;
  List<String> get dietTag => _dietTag ?? const [];
  bool hasDietTag() => _dietTag != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _favoriteRecipes = getDataList(snapshotData['favoriteRecipes']);
    _dietTag = getDataList(snapshotData['dietTag']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('uPref')
          : FirebaseFirestore.instance.collectionGroup('uPref');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('uPref').doc(id);

  static Stream<UPrefRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UPrefRecord.fromSnapshot(s));

  static Future<UPrefRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UPrefRecord.fromSnapshot(s));

  static UPrefRecord fromSnapshot(DocumentSnapshot snapshot) => UPrefRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UPrefRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UPrefRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UPrefRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UPrefRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUPrefRecordData() {
  final firestoreData = mapToFirestore(
    <String, dynamic>{}.withoutNulls,
  );

  return firestoreData;
}

class UPrefRecordDocumentEquality implements Equality<UPrefRecord> {
  const UPrefRecordDocumentEquality();

  @override
  bool equals(UPrefRecord? e1, UPrefRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.favoriteRecipes, e2?.favoriteRecipes) &&
        listEquality.equals(e1?.dietTag, e2?.dietTag);
  }

  @override
  int hash(UPrefRecord? e) =>
      const ListEquality().hash([e?.favoriteRecipes, e?.dietTag]);

  @override
  bool isValidKey(Object? o) => o is UPrefRecord;
}
