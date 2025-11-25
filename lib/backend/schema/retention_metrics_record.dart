import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// - cohort_date (String)
///   - calculation_date (DateTime)
///   - total_users (Number)
///   - retained_users (Number)
///   - retention_rate (Double)
///   - metric_type (String)
class RetentionMetricsRecord extends FirestoreRecord {
  RetentionMetricsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "cohort_date" field.
  String? _cohortDate;
  String get cohortDate => _cohortDate ?? '';
  bool hasCohortDate() => _cohortDate != null;

  // "calculation_date" field.
  DateTime? _calculationDate;
  DateTime? get calculationDate => _calculationDate;
  bool hasCalculationDate() => _calculationDate != null;

  // "total_users" field.
  int? _totalUsers;
  int get totalUsers => _totalUsers ?? 0;
  bool hasTotalUsers() => _totalUsers != null;

  // "retained_users" field.
  int? _retainedUsers;
  int get retainedUsers => _retainedUsers ?? 0;
  bool hasRetainedUsers() => _retainedUsers != null;

  // "retention_rate" field.
  double? _retentionRate;
  double get retentionRate => _retentionRate ?? 0.0;
  bool hasRetentionRate() => _retentionRate != null;

  // "metric_type" field.
  String? _metricType;
  String get metricType => _metricType ?? '';
  bool hasMetricType() => _metricType != null;

  void _initializeFields() {
    _cohortDate = snapshotData['cohort_date'] as String?;
    _calculationDate = snapshotData['calculation_date'] as DateTime?;
    _totalUsers = castToType<int>(snapshotData['total_users']);
    _retainedUsers = castToType<int>(snapshotData['retained_users']);
    _retentionRate = castToType<double>(snapshotData['retention_rate']);
    _metricType = snapshotData['metric_type'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('retention_metrics');

  static Stream<RetentionMetricsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RetentionMetricsRecord.fromSnapshot(s));

  static Future<RetentionMetricsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => RetentionMetricsRecord.fromSnapshot(s));

  static RetentionMetricsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RetentionMetricsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RetentionMetricsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RetentionMetricsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RetentionMetricsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RetentionMetricsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRetentionMetricsRecordData({
  String? cohortDate,
  DateTime? calculationDate,
  int? totalUsers,
  int? retainedUsers,
  double? retentionRate,
  String? metricType,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'cohort_date': cohortDate,
      'calculation_date': calculationDate,
      'total_users': totalUsers,
      'retained_users': retainedUsers,
      'retention_rate': retentionRate,
      'metric_type': metricType,
    }.withoutNulls,
  );

  return firestoreData;
}

class RetentionMetricsRecordDocumentEquality
    implements Equality<RetentionMetricsRecord> {
  const RetentionMetricsRecordDocumentEquality();

  @override
  bool equals(RetentionMetricsRecord? e1, RetentionMetricsRecord? e2) {
    return e1?.cohortDate == e2?.cohortDate &&
        e1?.calculationDate == e2?.calculationDate &&
        e1?.totalUsers == e2?.totalUsers &&
        e1?.retainedUsers == e2?.retainedUsers &&
        e1?.retentionRate == e2?.retentionRate &&
        e1?.metricType == e2?.metricType;
  }

  @override
  int hash(RetentionMetricsRecord? e) => const ListEquality().hash([
        e?.cohortDate,
        e?.calculationDate,
        e?.totalUsers,
        e?.retainedUsers,
        e?.retentionRate,
        e?.metricType
      ]);

  @override
  bool isValidKey(Object? o) => o is RetentionMetricsRecord;
}
