import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityFeedWidget extends StatelessWidget {
  const ActivityFeedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sevenDaysAgo =
        Timestamp.fromDate(
      DateTime.now().subtract(
        const Duration(days: 7),
      ),
    );

    return Card(
      elevation: 4,

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Row(
              children: [

                Icon(
                  Icons.history,
                  color: Colors.blue,
                ),

                SizedBox(width: 8),

                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore
                  .instance
                  .collection(
                    'movement_logs',
                  )
                  .where(
                    'timestamp',
                    isGreaterThanOrEqualTo:
                        sevenDaysAgo,
                  )
                  .orderBy(
                    'timestamp',
                    descending: true,
                  )
                  .limit(10)
                  .snapshots(),

              builder:
                  (context, snapshot) {

                if (snapshot.hasError) {
                  return const Text(
                    'Failed to load activity.',
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                final docs =
                    snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Text(
                    'No recent activities.',
                  );
                }

                return Column(
                  children:
                      docs.map((doc) {

                    final data =
                        doc.data()
                            as Map<String,
                                dynamic>;

                    final timestamp =
                        data['timestamp']
                            as Timestamp?;

                    final date =
                        timestamp
                                ?.toDate()
                                .toString()
                                .substring(
                                  0,
                                  16,
                                ) ??
                            '';

                    return ListTile(
                      contentPadding:
                          EdgeInsets.zero,

                      leading:
                          const Icon(
                        Icons.train,
                      ),

                      title: Text(
                        '${data['updatedBy']} '
                        '${data['action']} '
                        '${data['gateId']}',
                      ),

                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Text(
                            'Direction: '
                            '${data['direction']}',
                          ),

                          Text(
                            'Position: '
                            '${data['position']}',
                          ),

                          Text(
                            date,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}