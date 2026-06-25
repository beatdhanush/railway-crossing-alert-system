import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeNotificationScreen extends StatelessWidget {
  const EmployeeNotificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF003B8E),
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where(
              'active',
              isEqualTo: true,
            )
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final notifications =
              snapshot.data!.docs;

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'No Notifications',
              ),
            );
          }

          return ListView.builder(
            itemCount:
                notifications.length,

            itemBuilder:
                (context, index) {

              final data =
                  notifications[index]
                          .data()
                      as Map<String,
                          dynamic>;

              return Card(
                margin:
                    const EdgeInsets.all(
                  10,
                ),

                child: ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.orange,
                  ),

                  title: Text(
                    data['title'] ?? '',
                  ),

                  subtitle: Text(
                    data['message'] ?? '',
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