import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'gate_details_screen.dart';

class GateManagementScreen extends StatelessWidget {
  const GateManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gate Management'),
        backgroundColor: const Color(0xFF003B8E),
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('gates')
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final gates = snapshot.data!.docs;

          return ListView.builder(
            itemCount: gates.length,

            itemBuilder: (context, index) {

              final gate =
                  gates[index].data()
                      as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  onTap: () {

  Navigator.push(
    context,

    MaterialPageRoute(
      builder: (_) =>
          GateDetailsScreen(
        gateId: gates[index].id,
      ),
    ),
  );
},
                  leading: Icon(
                    gate['status'] == 'OPEN'
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        gate['status'] == 'OPEN'
                            ? Colors.green
                            : Colors.red,
                  ),

                  title: Text(
                    gate['gateName'] ?? '',
                  ),

                  subtitle: Text(
                    'Status : ${gate['status']}',
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
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