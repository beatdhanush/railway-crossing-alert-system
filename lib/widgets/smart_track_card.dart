import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SmartTrackCard extends StatelessWidget {
  final String trackId;
  final String role;
  final VoidCallback? onEdit;

  const SmartTrackCard({
    super.key,
    required this.trackId,
    required this.role,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tracks')
          .doc(trackId)
          .snapshots(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Card(
            child: ListTile(
              title: Text('Loading...'),
            ),
          );
        }

        if (!snapshot.data!.exists) {
          return Card(
            child: ListTile(
              title: Text(trackId.toUpperCase()),
              subtitle: const Text(
                'Track not found.',
              ),
            ),
          );
        }

        final data =
            snapshot.data!.data()
                as Map<String, dynamic>;

        final status =
            data['status'] ?? '';

        final expectedTime =
            data['expectedTime'] ?? '';

        final remarks =
            data['remarks'] ?? '';

        final updatedBy =
            data['updatedBy'] ?? '';

        final updatedAt =
            data['updatedAt'];

        IconData statusIcon;
        Color statusColor;

        switch (status) {
          case 'OPEN':
            statusIcon =
                Icons.check_circle;
            statusColor =
                Colors.green;
            break;

          case 'CLOSED':
            statusIcon =
                Icons.cancel;
            statusColor =
                Colors.red;
            break;

          case 'EXPECTED_TO_CLOSE':
            statusIcon =
                Icons.warning;
            statusColor =
                Colors.orange;
            break;

          case 'EXPECTED_TO_OPEN':
            statusIcon =
                Icons.access_time;
            statusColor =
                Colors.blue;
            break;

          default:
            statusIcon = Icons.help;
            statusColor = Colors.grey;
        }

        String updatedAtText = '';

        if (updatedAt != null) {
          final date =
              updatedAt.toDate();

          updatedAtText =
              '${date.day}/${date.month}/${date.year}'
              ' ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
        }

        final canEdit =
            role == 'operator' ||
            role == 'admin';

        return Card(
          margin:
              const EdgeInsets.only(
            bottom: 12,
          ),

          elevation: 4,

          child: InkWell(
            onTap: canEdit
                ? onEdit
                : null,

            child: Padding(
              padding:
                  const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      Icon(
                        statusIcon,
                        color:
                            statusColor,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: Text(
                          trackId
                              .toUpperCase(),

                          style:
                              const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      if (canEdit)
                        const Icon(
                          Icons
                              .arrow_forward_ios,
                          size: 18,
                        ),
                    ],
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    'Status: $status',

                    style: TextStyle(
                      color:
                          statusColor,

                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  if (expectedTime
                      .toString()
                      .isNotEmpty)

                    Padding(
                      padding:
                          const EdgeInsets
                              .only(
                        top: 6,
                      ),

                      child: Text(
                        'Expected Time: '
                        '$expectedTime',
                      ),
                    ),

                  if (remarks
                      .toString()
                      .isNotEmpty)

                    Padding(
                      padding:
                          const EdgeInsets
                              .only(
                        top: 6,
                      ),

                      child: Text(
                        'Remarks: $remarks',
                      ),
                    ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    'Updated By: '
                    '$updatedBy',
                  ),

                  if (updatedAtText
                      .isNotEmpty)

                    Text(
                      'Updated At: '
                      '$updatedAtText',
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}