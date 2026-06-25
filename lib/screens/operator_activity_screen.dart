import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OperatorActivityScreen extends StatelessWidget {
  final String operatorId;

  const OperatorActivityScreen({
    super.key,
    required this.operatorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('activity_logs')
            .where(
              'updatedBy',
              isEqualTo: operatorId,
            )
            .orderBy(
              'timestamp',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final logs = snapshot.data!.docs;

          if (logs.isEmpty) {
            return const Center(
              child: Text(
                'No Activities Found',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final data =
                  logs[index].data()
                      as Map<String, dynamic>;

              final status =
                  data['status'] ?? '';

              final remarks =
                  data['remarks'] ?? '-';

              final gateId =
                  data['gateId'] ?? '';

              final updatedBy =
                  data['updatedBy'] ?? '';

              final timestamp =
                  data['timestamp'];

              String timeText =
    'No Timestamp';

if (timestamp != null) {

  final date =
      timestamp.toDate();

  timeText =
      '${date.day}/${date.month}/${date.year} '
      '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}

              return Card(
                elevation: 4,
                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                status ==
                                        'OPEN'
                                    ? Colors.green
                                    : Colors.red,
                            child: Icon(
                              status ==
                                      'OPEN'
                                  ? Icons.check
                                  : Icons.close,
                              color:
                                  Colors.white,
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          const Expanded(
                            child: Text(
                              'Gate Status Updated',
                              style:
                                  TextStyle(
                                fontSize:
                                    18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      Text(
                        'Gate : $gateId',
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        'Status : $status',
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        'Operator : $updatedBy',
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        'Remarks : $remarks',
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      const Divider(),

                      const SizedBox(
                        height: 8,
                      ),

                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color:
                                Colors.grey,
                          ),

                          const SizedBox(
                            width: 6,
                          ),

                          Expanded(
                            child: Text(
                              timeText,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}