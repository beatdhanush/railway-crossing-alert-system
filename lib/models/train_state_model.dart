class TrainStateModel {
  final String direction;

  final String currentPosition;

  final String journeyStatus;

  final String updatedBy;
  final String updatedByName;
  final String updatedRole;

  final DateTime? updatedAt;

  TrainStateModel({
    required this.direction,
    required this.currentPosition,
    required this.journeyStatus,
    required this.updatedBy,
    required this.updatedByName,
    required this.updatedRole,
    required this.updatedAt,
  });

  factory TrainStateModel.fromMap(
    Map<String, dynamic> data,
  ) {
    return TrainStateModel(
      direction:
          data['direction'] ?? 'A_TO_C',

      currentPosition:
          data['currentPosition'] ?? 'AT_A',

      journeyStatus:
          data['journeyStatus']
              ?? 'COMPLETED',

      updatedBy:
          data['updatedBy'] ?? '',

      updatedByName:
          data['updatedByName'] ?? '',

      updatedRole:
          data['updatedRole'] ?? '',

      updatedAt:
          data['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
          updatedAt,
    };
  }
}