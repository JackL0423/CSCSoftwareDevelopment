import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecipesRecord extends FirestoreRecord {
  RecipesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "desc" field.
  String? _desc;
  String get desc => _desc ?? '';
  bool hasDesc() => _desc != null;

  // "descLong" field.
  String? _descLong;
  String get descLong => _descLong ?? '';
  bool hasDescLong() => _descLong != null;

  // "prep" field.
  String? _prep;
  String get prep => _prep ?? '';
  bool hasPrep() => _prep != null;

  // "difficulty" field.
  String? _difficulty;
  String get difficulty => _difficulty ?? '';
  bool hasDifficulty() => _difficulty != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "idMeal" field.
  String? _idMeal;
  String get idMeal => _idMeal ?? '';
  bool hasIdMeal() => _idMeal != null;

  // "img" field.
  String? _img;
  String get img => _img ?? '';
  bool hasImg() => _img != null;

  // "ingredientNames" field.
  List<String>? _ingredientNames;
  List<String> get ingredientNames => _ingredientNames ?? const [];
  bool hasIngredientNames() => _ingredientNames != null;

  // "ingredientQuantities" field.
  List<String>? _ingredientQuantities;
  List<String> get ingredientQuantities => _ingredientQuantities ?? const [];
  bool hasIngredientQuantities() => _ingredientQuantities != null;

  // "prepSteps" field.
  List<String>? _prepSteps;
  List<String> get prepSteps => _prepSteps ?? const [];
  bool hasPrepSteps() => _prepSteps != null;

  // "region" field.
  String? _region;
  String get region => _region ?? '';
  bool hasRegion() => _region != null;

  // "sourceURL" field.
  String? _sourceURL;
  String get sourceURL => _sourceURL ?? '';
  bool hasSourceURL() => _sourceURL != null;

  // "timestamp" field.
  String? _timestamp;
  String get timestamp => _timestamp ?? '';
  bool hasTimestamp() => _timestamp != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _desc = snapshotData['desc'] as String?;
    _descLong = snapshotData['descLong'] as String?;
    _prep = snapshotData['prep'] as String?;
    _difficulty = snapshotData['difficulty'] as String?;
    _category = snapshotData['category'] as String?;
    _idMeal = snapshotData['idMeal'] as String?;
    _img = snapshotData['img'] as String?;
    _ingredientNames = getDataList(snapshotData['ingredientNames']);
    _ingredientQuantities = getDataList(snapshotData['ingredientQuantities']);
    _prepSteps = getDataList(snapshotData['prepSteps']);
    _region = snapshotData['region'] as String?;
    _sourceURL = snapshotData['sourceURL'] as String?;
    _timestamp = snapshotData['timestamp'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('recipes')
          : FirebaseFirestore.instance.collectionGroup('recipes');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('recipes').doc(id);

  static Stream<RecipesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RecipesRecord.fromSnapshot(s));

  static Future<RecipesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RecipesRecord.fromSnapshot(s));

  static RecipesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RecipesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RecipesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RecipesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RecipesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RecipesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRecipesRecordData({
  String? title,
  String? desc,
  String? descLong,
  String? prep,
  String? difficulty,
  String? category,
  String? idMeal,
  String? img,
  String? region,
  String? sourceURL,
  String? timestamp,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'desc': desc,
      'descLong': descLong,
      'prep': prep,
      'difficulty': difficulty,
      'category': category,
      'idMeal': idMeal,
      'img': img,
      'region': region,
      'sourceURL': sourceURL,
      'timestamp': timestamp,
    }.withoutNulls,
  );

  return firestoreData;
}

class RecipesRecordDocumentEquality implements Equality<RecipesRecord> {
  const RecipesRecordDocumentEquality();

  @override
  bool equals(RecipesRecord? e1, RecipesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.title == e2?.title &&
        e1?.desc == e2?.desc &&
        e1?.descLong == e2?.descLong &&
        e1?.prep == e2?.prep &&
        e1?.difficulty == e2?.difficulty &&
        e1?.category == e2?.category &&
        e1?.idMeal == e2?.idMeal &&
        e1?.img == e2?.img &&
        listEquality.equals(e1?.ingredientNames, e2?.ingredientNames) &&
        listEquality.equals(
            e1?.ingredientQuantities, e2?.ingredientQuantities) &&
        listEquality.equals(e1?.prepSteps, e2?.prepSteps) &&
        e1?.region == e2?.region &&
        e1?.sourceURL == e2?.sourceURL &&
        e1?.timestamp == e2?.timestamp;
  }

  @override
  int hash(RecipesRecord? e) => const ListEquality().hash([
        e?.title,
        e?.desc,
        e?.descLong,
        e?.prep,
        e?.difficulty,
        e?.category,
        e?.idMeal,
        e?.img,
        e?.ingredientNames,
        e?.ingredientQuantities,
        e?.prepSteps,
        e?.region,
        e?.sourceURL,
        e?.timestamp
      ]);

  @override
  bool isValidKey(Object? o) => o is RecipesRecord;
}
