import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "d7_retention_eligible" field.
  bool? _d7RetentionEligible;
  bool get d7RetentionEligible => _d7RetentionEligible ?? false;
  bool hasD7RetentionEligible() => _d7RetentionEligible != null;

  // "photo_urlStr" field.
  String? _photoUrlStr;
  String get photoUrlStr => _photoUrlStr ?? '';
  bool hasPhotoUrlStr() => _photoUrlStr != null;

  // "temp_urlStr" field.
  String? _tempUrlStr;
  String get tempUrlStr => _tempUrlStr ?? '';
  bool hasTempUrlStr() => _tempUrlStr != null;

  // "completedRecipes" field.
  List<DocumentReference>? _completedRecipes;
  List<DocumentReference> get completedRecipes => _completedRecipes ?? const [];
  bool hasCompletedRecipes() => _completedRecipes != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  bool hasRole() => _role != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "uPref" field.
  DocumentReference? _uPref;
  DocumentReference? get uPref => _uPref;
  bool hasUPref() => _uPref != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "dietTags" field.
  List<String>? _dietTags;
  List<String> get dietTags => _dietTags ?? const [];
  bool hasDietTags() => _dietTags != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _uid = snapshotData['uid'] as String?;
    _d7RetentionEligible = snapshotData['d7_retention_eligible'] as bool?;
    _photoUrlStr = snapshotData['photo_urlStr'] as String?;
    _tempUrlStr = snapshotData['temp_urlStr'] as String?;
    _completedRecipes = getDataList(snapshotData['completedRecipes']);
    _role = snapshotData['role'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _uPref = snapshotData['uPref'] as DocumentReference?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _dietTags = getDataList(snapshotData['dietTags']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? uid,
  bool? d7RetentionEligible,
  String? photoUrlStr,
  String? tempUrlStr,
  String? role,
  String? photoUrl,
  String? phoneNumber,
  DocumentReference? uPref,
  DateTime? createdTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'uid': uid,
      'd7_retention_eligible': d7RetentionEligible,
      'photo_urlStr': photoUrlStr,
      'temp_urlStr': tempUrlStr,
      'role': role,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'uPref': uPref,
      'created_time': createdTime,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.uid == e2?.uid &&
        e1?.d7RetentionEligible == e2?.d7RetentionEligible &&
        e1?.photoUrlStr == e2?.photoUrlStr &&
        e1?.tempUrlStr == e2?.tempUrlStr &&
        listEquality.equals(e1?.completedRecipes, e2?.completedRecipes) &&
        e1?.role == e2?.role &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.uPref == e2?.uPref &&
        e1?.createdTime == e2?.createdTime &&
        listEquality.equals(e1?.dietTags, e2?.dietTags);
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.uid,
        e?.d7RetentionEligible,
        e?.photoUrlStr,
        e?.tempUrlStr,
        e?.completedRecipes,
        e?.role,
        e?.photoUrl,
        e?.phoneNumber,
        e?.uPref,
        e?.createdTime,
        e?.dietTags
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
