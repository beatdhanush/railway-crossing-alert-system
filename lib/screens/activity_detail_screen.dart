import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ActivityDetailScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final timestamp =
        data['timestamp'] as Timestamp?;

    final dateTime =
        timestamp?.toDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activity Details',
        ),
        backgroundColor:
            const Color(0xFF003B8E),
        foregroundColor:
            Colors.white,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Card(
          elevation: 4,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),

          child: Padding(
            padding:
                const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                _buildItem(
                  'Updated By',
                  data['updatedBy'] ?? '',
                ),

                _buildItem(
                  'Operator Name',
                  data['updatedByName'] ?? '',
                ),

                _buildItem(
                  'Role',
                  data['updatedRole'] ?? '',
                ),

                const Divider(),

                _buildItem(
                  'Gate',
                  data['gateId'] ?? '',
                ),

                _buildItem(
                  'Action',
                  data['action'] ?? '',
                ),

                const Divider(),

                _buildItem(
                  'Direction',
                  data['direction'] ?? '',
                ),

                _buildItem(
                  'Journey Status',
                  data['journeyStatus'] ?? '',
                ),

                _buildItem(
                  'Position',
                  data['position'] ?? '',
                ),

                const Divider(),

                _buildItem(
                  'Remarks',
                  data['remarks'] ?? '',
                ),

                const Divider(),

                _buildItem(
                  'Date',
                  dateTime == null
                      ? ''
                      : '${dateTime.day.toString().padLeft(2, '0')}-'
                        '${dateTime.month.toString().padLeft(2, '0')}-'
                        '${dateTime.year}',
                ),

                _buildItem(
                  'Time',
                  dateTime == null
                      ? ''
                      : '${dateTime.hour.toString().padLeft(2, '0')}:'
                        '${dateTime.minute.toString().padLeft(2, '0')}:'
                        '${dateTime.second.toString().padLeft(2, '0')}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value.isEmpty
                ? 'N/A'
                : value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}