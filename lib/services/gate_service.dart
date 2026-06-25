import 'package:cloud_firestore/cloud_firestore.dart';

class GateService {
  GateService._();

  static final instance =
      GateService._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> updateGateStatus({
    required String gateId,
    required String status,

    required String updatedBy,
    required String updatedByName,
    required String updatedRole,
  }) async {

    await _firestore
        .collection('gates')
        .doc(gateId)
        .update({

      'status': status,

      'updatedBy': updatedBy,

      'updatedByName':
          updatedByName,

      'updatedRole':
          updatedRole,

      'updatedAt':
          FieldValue.serverTimestamp(),
    });
    await _firestore
    .collection('activity_logs')
    .add({

  'action':
      status == 'OPEN'
          ? 'Gate Opened'
          : 'Gate Closed',

  'gateId': gateId,

  'updatedBy':
      updatedBy,

  'updatedByName':
      updatedByName,

  'updatedRole':
      updatedRole,

  'timestamp':
      FieldValue.serverTimestamp(),
});
  }
}