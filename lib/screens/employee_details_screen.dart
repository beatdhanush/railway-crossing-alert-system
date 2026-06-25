import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final String employeeId;

  const EmployeeDetailsScreen({
    super.key,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(employeeId),
        backgroundColor: const Color(0xFF003B8E),
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('employees')
            .doc(employeeId)
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
                  data['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Employee ID : ${data['employeeId']}',
                ),

                const SizedBox(height: 10),

                Text(
                  'Email : ${data['email']}',
                ),

                const SizedBox(height: 10),

                Text(
                  'Approval Status : ${data['approvalStatus']}',
                ),

                const SizedBox(height: 10),

                Text(
                  'Active : ${data['active']}',
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () async {

                      await FirebaseFirestore
                          .instance
                          .collection('employees')
                          .doc(employeeId)
                          .update({

                        'approvalStatus':
                            'approved',

                        'active': true,

                        'approvedBy':
                            'ADM001',

                        'approvedAt':
                            FieldValue
                                .serverTimestamp(),
                      });
                    },

                    child: const Text(
                      'APPROVE',
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
                          Colors.orange,
                    ),

                    onPressed: () async {

                      await FirebaseFirestore
                          .instance
                          .collection('employees')
                          .doc(employeeId)
                          .update({

                        'approvalStatus':
                            'rejected',

                        'active': false,
                      });
                    },

                    child: const Text(
                      'REJECT',
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

                      await FirebaseFirestore
                          .instance
                          .collection('employees')
                          .doc(employeeId)
                          .update({

                        'active': false,
                      });
                    },

                    child: const Text(
                      'DEACTIVATE',
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