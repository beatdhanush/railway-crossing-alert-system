class MovementLogModel {
  final String gateId;

  final String action;

  final String direction;

  final String position;

  final String journeyStatus;

  final String updatedBy;
  final String updatedByName;
  final String updatedRole;

  final String remarks;

  final DateTime? timestamp;

  MovementLogModel({
    required this.gateId,
    required this.action,
    required this.direction,
    required this.position,
    required this.journeyStatus,
    required this.updatedBy,
    required this.updatedByName,
    required this.updatedRole,
    required this.remarks,
    required this.timestamp,
  });

  factory MovementLogModel.fromMap(
    Map<String, dynamic> data,
  ) {
    return MovementLogModel(
      gateId:
          data['gateId'] ?? '',

      action:
          data['action'] ?? '',

      direction:
          data['direction'] ?? '',

      position:
          data['position'] ?? '',

      journeyStatus:
          data['journeyStatus'] ?? '',

      updatedBy:
          data['updatedBy'] ?? '',

      updatedByName:
          data['updatedByName'] ?? '',

      updatedRole:
          data['updatedRole'] ?? '',

      remarks:
          data['remarks'] ?? '',

      timestamp:
          data['timestamp']
              ?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
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

      'remarks': remarks,

      'timestamp':
          timestamp,
    };
  }
}