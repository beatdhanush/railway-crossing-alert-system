import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PendingEmployeeCard extends StatelessWidget {

  final String employeeId;
  final String name;
  final String email;
  final Timestamp? createdAt;

  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PendingEmployeeCard({
    super.key,
    required this.employeeId,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {

    String registrationDate =
        'Unknown';

    if (createdAt != null) {

      final date =
          createdAt!.toDate();

      registrationDate =
          '${date.day}/${date.month}/${date.year}';
    }

    return Card(

      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      elevation: 4,

      child: Padding(

        padding:
            const EdgeInsets.all(12),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              name,

              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Employee ID: $employeeId',
            ),

            Text(
              'Email: $email',
            ),

            Text(
              'Requested On: $registrationDate',
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton(

                    onPressed:
                        onApprove,

                    style:
                        ElevatedButton
                            .styleFrom(

                      backgroundColor:
                          Colors.green,

                      foregroundColor:
                          Colors.white,
                    ),

                    child: const Text(
                      'APPROVE',
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(

                    onPressed:
                        onReject,

                    style:
                        ElevatedButton
                            .styleFrom(

                      backgroundColor:
                          Colors.red,

                      foregroundColor:
                          Colors.white,
                    ),

                    child: const Text(
                      'REJECT',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}