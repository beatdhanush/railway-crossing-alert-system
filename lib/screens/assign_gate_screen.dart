import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignGateScreen extends StatefulWidget {
  final String operatorId;

  const AssignGateScreen({
    super.key,
    required this.operatorId,
  });

  @override
  State<AssignGateScreen> createState() =>
      _AssignGateScreenState();
}

class _AssignGateScreenState
    extends State<AssignGateScreen> {

  List<String> selectedGates = [];

  @override
  void initState() {
    super.initState();
    loadOperator();
  }

  Future<void> loadOperator() async {

    final doc =
        await FirebaseFirestore.instance
            .collection('operators')
            .doc(widget.operatorId)
            .get();

    final data =
        doc.data() ?? {};

    selectedGates =
        List<String>.from(
      data['assignedGates'] ?? [],
    );

    setState(() {});
  }

  Future<void> saveAssignments() async {

    await FirebaseFirestore.instance
        .collection('operators')
        .doc(widget.operatorId)
        .update({

      'assignedGates':
          selectedGates,
    });

    if (mounted) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            'Gate Assignment Saved',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.operatorId,
        ),

        backgroundColor:
            const Color(0xFF003B8E),

        foregroundColor:
            Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('gates')
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final gates =
              snapshot.data!.docs;

          return Column(
            children: [

              Expanded(
                child: ListView.builder(

                  itemCount:
                      gates.length,

                  itemBuilder:
                      (context, index) {

                    final gateId =
                        gates[index].id;

                    return CheckboxListTile(

                      title: Text(
                        gateId,
                      ),

                      value:
                          selectedGates
                              .contains(
                        gateId,
                      ),

                      onChanged:
                          (value) {

                        setState(() {

                          if (value ==
                              true) {

                            selectedGates
                                .add(
                              gateId,
                            );

                          } else {

                            selectedGates
                                .remove(
                              gateId,
                            );
                          }
                        });
                      },
                    );
                  },
                ),
              ),

              Padding(
  padding: const EdgeInsets.all(16),

  child: SizedBox(
    width: double.infinity,
    height: 55,

    child: ElevatedButton.icon(

      onPressed: saveAssignments,

      icon: const Icon(
        Icons.save,
      ),

      label: const Text(
        'SAVE ASSIGNMENTS',
      ),
    ),
  ),
),
            ],
          );
        },
      ),
    );
  }
}