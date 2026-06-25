import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({
    super.key,
  });

  Color getPriorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
        return Colors.red;

      case 'MEDIUM':
        return Colors.orange;

      default:
        return Colors.blue;
    }
  }

  IconData getPriorityIcon(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
        return Icons.warning_amber_rounded;

      case 'MEDIUM':
        return Icons.notifications_active;

      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Center',
        ),
        backgroundColor:
            const Color(0xFF003B8E),
        foregroundColor:
            Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Notifications Available',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          final notifications =
              snapshot.data!.docs;

          return ListView.builder(
            padding:
                const EdgeInsets.all(12),

            itemCount:
                notifications.length,

            itemBuilder:
                (context, index) {

              final data =
                  notifications[index]
                          .data()
                      as Map<String,
                          dynamic>;

              final title =
                  data['title'] ??
                      'Notification';

              final message =
                  data['message'] ??
                      '';

              final priority =
                  data['priority'] ??
                      'LOW';

              final trackId =
                  data['trackId'] ??
                      'N/A';

              String createdAt =
                  '';

              if (data['createdAt'] !=
                  null) {

                final timestamp =
                    data['createdAt']
                        as Timestamp;

                createdAt =
                    timestamp
                        .toDate()
                        .toString();
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
                    15,
                  ),
                ),

                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    14,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Row(
                        children: [

                          Icon(
                            getPriorityIcon(
                              priority,
                            ),
                            color:
                                getPriorityColor(
                              priority,
                            ),
                            size: 32,
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child: Text(
                              title,
                              style:
                                  const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Text(
                        message,
                        style:
                            const TextStyle(
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Row(
                        children: [

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  10,
                              vertical: 5,
                            ),

                            decoration:
                                BoxDecoration(
                              color:
                                  getPriorityColor(
                                priority,
                              ),

                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),

                            child: Text(
                              priority,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Chip(
                            label: Text(
                              trackId,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        createdAt,
                        style:
                            TextStyle(
                          color: Colors
                              .grey.shade600,
                          fontSize: 12,
                        ),
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