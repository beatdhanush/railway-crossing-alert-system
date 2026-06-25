import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'employee_details_screen.dart';

class EmployeeManagementScreen extends StatelessWidget {
  const EmployeeManagementScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Management',
        ),
        backgroundColor: const Color(0xFF003B8E),
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('employees')
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final employees =
              snapshot.data!.docs;

          return ListView.builder(
            itemCount: employees.length,

            itemBuilder: (context, index) {

              final employee =
                  employees[index];

              final data =
                  employee.data()
                      as Map<String, dynamic>;

              final status =
                  data['approvalStatus'] ??
                      'pending';

              return Card(
                margin:
                    const EdgeInsets.all(10),

                child: ListTile(

                  onTap: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            EmployeeDetailsScreen(
                          employeeId:
                              employee.id,
                        ),
                      ),
                    );
                  },

                  leading:
                      const CircleAvatar(
                    child: Icon(
                      Icons.person,
                    ),
                  ),

                  title: Text(
                    data['name'] ?? '',
                  ),

                  subtitle: Text(
                    status.toUpperCase(),
                  ),

                  trailing: Icon(
                    status == 'approved'
                        ? Icons.check_circle
                        : Icons.pending,

                    color:
                        status == 'approved'
                            ? Colors.green
                            : Colors.orange,
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