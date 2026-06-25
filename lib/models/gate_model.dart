class GateModel {
  final String gateId;
  final String name;
  final String status;

  final String operatorId;

  final String updatedBy;
  final String updatedByName;
  final String updatedRole;

  final DateTime? updatedAt;

  GateModel({
    required this.gateId,
    required this.name,
    required this.status,
    required this.operatorId,
    required this.updatedBy,
    required this.updatedByName,
    required this.updatedRole,
    required this.updatedAt,
  });

  factory GateModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return GateModel(
      gateId: id,

      name: data['name'] ?? '',

      status: data['status'] ?? 'OPEN',

      operatorId:
          data['operatorId'] ?? '',

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
      'name': name,

      'status': status,

      'operatorId': operatorId,

      'updatedBy': updatedBy,

      'updatedByName':
          updatedByName,

      'updatedRole':
          updatedRole,

      'updatedAt': updatedAt,
    };
  }
}