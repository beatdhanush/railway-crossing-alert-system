import 'package:cloud_firestore/cloud_firestore.dart';

class TrainMovementService {
  TrainMovementService._();

  static final instance =
      TrainMovementService._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> updateTrainState({

    required String direction,

    required String currentPosition,

    required String journeyStatus,

    required String updatedBy,
    required String updatedByName,
    required String updatedRole,

  }) async {

    await _firestore
        .collection('train_state')
        .doc('current_journey')
        .set({

      'direction': direction,

      'currentPosition':
          currentPosition,

      'journeyStatus':
          journeyStatus,

      'updatedBy':
          updatedBy,

      'updatedByName':
          updatedByName,

      'updatedRole':
          updatedRole,

      'updatedAt':
          FieldValue.serverTimestamp(),

    }, SetOptions(
      merge: true,
    ));
  }
}