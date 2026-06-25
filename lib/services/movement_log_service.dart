import 'package:cloud_firestore/cloud_firestore.dart';

class MovementLogService {
  MovementLogService._();

  static final instance =
      MovementLogService._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addLog({

    required String gateId,

    required String action,

    required String direction,

    required String position,

    required String journeyStatus,

    required String updatedBy,
    required String updatedByName,
    required String updatedRole,

    required String remarks,
  }) async {

    await _firestore
        .collection('movement_logs')
        .add({

      'gateId': gateId,

      'action': action,

      'direction': direction,

      'position': position,

      'journeyStatus':
          journeyStatus,

      'updatedBy':
          updatedBy,

      'updatedByName':
          updatedByName,

      'updatedRole':
          updatedRole,

      'remarks':
          remarks,

      'timestamp':
          FieldValue.serverTimestamp(),
    });
  }
}