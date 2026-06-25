import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/pending_employee_card.dart';

class AdminApprovalsScreen extends StatelessWidget {
  const AdminApprovalsScreen({
    super.key,
  });

  Future<void> approveEmployee(
    BuildContext context,
    String employeeId,
  ) async {

    await FirebaseFirestore.instance
        .collection('employees')
        .doc(employeeId)
        .update({

      'approvalStatus': 'approved',

      'approvedBy': 'ADM001',

      'approvedAt':
          FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '$employeeId approved.',
        ),
      ),
    );
  }

  Future<void> rejectEmployee(
    BuildContext context,
    String employeeId,
  ) async {

    await FirebaseFirestore.instance
        .collection('employees')
        .doc(employeeId)
        .update({

      'approvalStatus': 'rejected',

      'rejectedBy': 'ADM001',

      'rejectedAt':
          FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '$employeeId rejected.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Employee Approvals',
        ),

        backgroundColor:
            const Color(0xFF003B8E),

        foregroundColor:
            Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream:
            FirebaseFirestore.instance
                .collection('employees')
                .where(
                  'approvalStatus',
                  isEqualTo: 'pending',
                )
                .snapshots(),

        builder:
            (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load requests.',
              ),
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
            return const Center(
              child: Text(
                'No pending approvals.',
              ),
            );
          }

          return ListView.builder(

            padding:
                const EdgeInsets.all(16),

            itemCount:
                docs.length,

            itemBuilder:
                (context, index) {

              final data =
                  docs[index].data()
                      as Map<String,
                          dynamic>;

              final employeeId =
                  docs[index].id;

              Timestamp? createdAt =
                  data['createdAt'];

              return PendingEmployeeCard(

                employeeId:
                    employeeId,

                name:
                    data['name'] ?? '',

                email:
                    data['email'] ?? '',

                createdAt:
                    createdAt,

                onApprove: () {
                  approveEmployee(
                    context,
                    employeeId,
                  );
                },

                onReject: () {
                  rejectEmployee(
                    context,
                    employeeId,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}