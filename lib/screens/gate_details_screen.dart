import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GateDetailsScreen extends StatelessWidget {
  final String gateId;

  const GateDetailsScreen({
    super.key,
    required this.gateId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gateId),
        backgroundColor: const Color(0xFF003B8E),
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('gates')
            .doc(gateId)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data!.data()
                  as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  data['gateName'] ?? '',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Status : ${data['status']}',
                ),

                const SizedBox(height: 10),

                Text(
                  'Updated By : ${data['updatedBy']}',
                ),

                const SizedBox(height: 10),

                Text(
                  'Remarks : ${data['remarks']}',
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () async {

  await FirebaseFirestore.instance
      .collection('gates')
      .doc(gateId)
      .update({

    'status': 'OPEN',
    'updatedBy': 'ADMIN',
    'updatedRole': 'admin',
    'updatedAt':
        FieldValue.serverTimestamp(),
  });

  await FirebaseFirestore.instance
      .collection('activity_logs')
      .add({

    'gateId': gateId,

    'action':
        'Gate Opened By Admin',

    'status': 'OPEN',

    'updatedBy': 'ADMIN',

    'updatedRole': 'admin',

    'timestamp':
        FieldValue.serverTimestamp(),
  });
},

                    child: const Text(
                      'OPEN GATE',
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red,
                    ),

                    onPressed: () async {

  await FirebaseFirestore.instance
      .collection('gates')
      .doc(gateId)
      .update({

    'status': 'CLOSED',
    'updatedBy': 'ADMIN',
    'updatedRole': 'admin',
    'updatedAt':
        FieldValue.serverTimestamp(),
  });

  await FirebaseFirestore.instance
      .collection('activity_logs')
      .add({

    'gateId': gateId,

    'action':
        'Gate Closed By Admin',

    'status': 'CLOSED',

    'updatedBy': 'ADMIN',

    'updatedRole': 'admin',

    'timestamp':
        FieldValue.serverTimestamp(),
  });
},

                    child: const Text(
                      'CLOSE GATE',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}