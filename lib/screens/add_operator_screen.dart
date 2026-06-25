import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOperatorScreen extends StatefulWidget {
  const AddOperatorScreen({super.key});

  @override
  State<AddOperatorScreen> createState() =>
      _AddOperatorScreenState();
}

class _AddOperatorScreenState
    extends State<AddOperatorScreen> {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final trackController =
      TextEditingController();

  bool isLoading = false;

  Future<void> createOperator() async {

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        trackController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields',
          ),
        ),
      );
      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      final snapshot =
          await FirebaseFirestore.instance
              .collection('operators')
              .get();

      final nextNumber =
          snapshot.docs.length + 1;

      final operatorId =
          'OP${nextNumber.toString().padLeft(3, '0')}';

      await FirebaseFirestore.instance
          .collection('operators')
          .doc(operatorId)
          .set({

        'operatorId': operatorId,

        'name':
            nameController.text.trim(),

        'email':
            emailController.text.trim(),

        'assignedTrack':
            trackController.text.trim(),

        'assignedGates': [],

        'role': 'operator',

        'active': true,

        'createdAt':
            FieldValue.serverTimestamp(),
      });

      if (mounted) {

        showDialog(
          context: context,
          builder: (_) => AlertDialog(

            title: const Text(
              'Operator Created',
            ),

            content: Text(
              'Operator ID: $operatorId',
            ),

            actions: [

              TextButton(
                onPressed: () {

                  Navigator.pop(context);
                  Navigator.pop(context);
                },

                child: const Text(
                  'OK',
                ),
              ),
            ],
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
          ),
        ),
      );

    } finally {

      if (mounted) {

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {

    nameController.dispose();
    emailController.dispose();
    trackController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Add Operator',
        ),

        backgroundColor:
            const Color(0xFF003B8E),

        foregroundColor:
            Colors.white,
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller:
                  nameController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Operator Name',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            TextField(
              controller:
                  emailController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Email',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            TextField(
              controller:
                  trackController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Assigned Track',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,

              height: 55,

              child:
                  ElevatedButton(

                onPressed:
                    isLoading
                        ? null
                        : createOperator,

                child:
                    isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'CREATE OPERATOR',
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}