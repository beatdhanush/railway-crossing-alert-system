import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/smart_track_card.dart';
import 'edit_track_screen.dart';

class OperatorDashboardScreen extends StatefulWidget {
  final String operatorId;

  const OperatorDashboardScreen({
    super.key,
    required this.operatorId,
  });

  @override
  State<OperatorDashboardScreen> createState() =>
      _OperatorDashboardScreenState();
}

class _OperatorDashboardScreenState
    extends State<OperatorDashboardScreen> {

  bool isLoading = true;

  String operatorName = '';

  List<String> trackIds = [];

  @override
  void initState() {
    super.initState();
    loadOperatorData();
  }

  Future<void> loadOperatorData() async {
    try {

      final operatorDoc =
          await FirebaseFirestore.instance
              .collection('operators')
              .doc(widget.operatorId)
              .get();

      if (operatorDoc.exists) {

        final data =
            operatorDoc.data()!;

        operatorName =
            data['name'] ?? '';

        /// Option B:
        /// Operators can edit ALL tracks

        final tracksSnapshot =
            await FirebaseFirestore.instance
                .collection('tracks')
                .get();

        trackIds = tracksSnapshot.docs
            .map((doc) => doc.id)
            .toList();
      }
    } catch (e) {

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load dashboard: $e',
            ),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Operator Dashboard',
        ),

        backgroundColor:
            const Color(0xFF003B8E),

        foregroundColor:
            Colors.white,
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Card(
              elevation: 4,

              child: ListTile(

                leading:
                    const CircleAvatar(
                  child: Icon(
                    Icons.person,
                  ),
                ),

                title: Text(
                  operatorName,
                ),

                subtitle: Text(
                  widget.operatorId,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Track Status',

              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(

                itemCount:
                    trackIds.length,

                itemBuilder:
                    (context, index) {

                  final trackId =
                      trackIds[index];

                  return SmartTrackCard(

                    trackId: trackId,

                    role: 'operator',

                    onEdit: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              EditTrackScreen(

                            trackId:
                                trackId,

                            updatedBy:
                                widget
                                    .operatorId,

                            updatedRole:
                                'operator',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}