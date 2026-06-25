import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OperatorNotificationScreen
    extends StatelessWidget {

  const OperatorNotificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
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
            child:
                CircularProgressIndicator(),
          );
        }

        final docs =
            snapshot.data!.docs;

        if (docs.isEmpty) {

          return const Center(
            child: Text(
              'No Alerts',
            ),
          );
        }

        return ListView.builder(

          itemCount: docs.length,

          itemBuilder:
              (context, index) {

            final data =
                docs[index].data()
                    as Map<String,
                        dynamic>;

            return Card(

              margin:
                  const EdgeInsets.all(
                12,
              ),

              elevation: 6,

              child: ListTile(

                leading: const Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 32,
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
    );
  }
}