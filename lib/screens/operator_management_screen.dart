import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'assign_gate_screen.dart';
import 'add_operator_screen.dart';

class OperatorManagementScreen extends StatelessWidget {
  const OperatorManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Operator Management',
        ),
        backgroundColor: const Color(0xFF003B8E),
        foregroundColor: Colors.white,

        actions: [

  IconButton(
    icon: const Icon(
      Icons.add,
    ),

    onPressed: () {

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) =>
              const AddOperatorScreen(),
        ),
      );
    },
  ),
],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('operators')
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final operators =
              snapshot.data!.docs;

          return ListView.builder(
            itemCount: operators.length,

            itemBuilder: (context, index) {

              final data =
                  operators[index].data()
                      as Map<String, dynamic>;

              return Card(
                margin:
                    const EdgeInsets.all(10),

                child: ListTile(

                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.engineering,
                    ),
                  ),

                  title: Text(
                    data['name'] ?? '',
                  ),

                  subtitle: Text(
                    operators[index].id,
                  ),

                  trailing: const Icon(
  Icons.arrow_forward_ios,
),

onTap: () {

  Navigator.push(
    context,

    MaterialPageRoute(
      builder: (_) =>
          AssignGateScreen(

        operatorId:
            operators[index].id,
      ),
    ),
  );
},
                ),
              );
            },
          );
        },
      ),
    );
  }
}