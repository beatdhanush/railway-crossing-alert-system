import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTrackScreen extends StatefulWidget {
  final String trackId;
  final String updatedBy;
  final String updatedRole;

  const EditTrackScreen({
    super.key,
    required this.trackId,
    required this.updatedBy,
    required this.updatedRole,
  });

  @override
  State<EditTrackScreen> createState() =>
      _EditTrackScreenState();
}

class _EditTrackScreenState
    extends State<EditTrackScreen> {

  final TextEditingController expectedTimeController =
      TextEditingController();

  final TextEditingController remarksController =
      TextEditingController();

  bool isLoading = true;
  bool isSaving = false;

  String selectedStatus = 'OPEN';

  String? selectedDuration;
  int? expectedDuration;

  final List<String> statuses = [
    'OPEN',
    'CLOSED',
    'EXPECTED_TO_CLOSE',
    'EXPECTED_TO_OPEN',
  ];

  @override
  void initState() {
    super.initState();
    loadTrackData();
  }

  Future<void> loadTrackData() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('tracks')
              .doc(widget.trackId)
              .get();

      if (doc.exists) {
        final data = doc.data()!;

        selectedStatus =
            data['status'] ?? 'OPEN';

        expectedTimeController.text =
            data['expectedTime'] ?? '';

        remarksController.text =
            data['remarks'] ?? '';

        expectedDuration =
            data['expectedDuration'];

        if (expectedDuration != null) {
          selectedDuration =
              '$expectedDuration min';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load track: $e',
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

  void setDuration(int minutes) {
    final now = DateTime.now();

    final future =
        now.add(Duration(minutes: minutes));

    expectedDuration = minutes;

    expectedTimeController.text =
        '${future.hour.toString().padLeft(2, '0')}:'
        '${future.minute.toString().padLeft(2, '0')}';

    setState(() {
      selectedDuration =
          '$minutes min';
    });
  }

  Future<void> pickExactTime() async {
    final picked =
        await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      expectedDuration = null;

      expectedTimeController.text =
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}';

      setState(() {
        selectedDuration =
            'Exact Time';
      });
    }
  }

  Widget durationChip(int minutes) {
    return ChoiceChip(
      label: Text('$minutes min'),

      selected:
          selectedDuration ==
              '$minutes min',

      onSelected: (_) {
        setDuration(minutes);
      },
    );
  }

  Future<void> saveTrack() async {
    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('tracks')
          .doc(widget.trackId)
          .update({

        'status': selectedStatus,

        'expectedTime':
            expectedTimeController.text
                .trim(),

        'expectedDuration':
            expectedDuration,

        'remarks':
            remarksController.text
                .trim(),

        'updatedBy':
            widget.updatedBy,

        'updatedRole':
            widget.updatedRole,

        'updatedAt':
            Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Track updated successfully.',
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update: $e',
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    expectedTimeController.dispose();
    remarksController.dispose();
    super.dispose();
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
        title: Text(
          'Edit ${widget.trackId.toUpperCase()}',
        ),
        backgroundColor:
            const Color(0xFF003B8E),
        foregroundColor:
            Colors.white,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Track Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedStatus,

              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),
              ),

              items: statuses
                  .map(
                    (status) =>
                        DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ),
                  )
                  .toList(),

              onChanged: (value) {
                setState(() {
                  selectedStatus =
                      value!;
                });
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Expected Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [

                durationChip(5),
                durationChip(10),
                durationChip(15),

                durationChip(30),
                durationChip(45),
                durationChip(60),

                ActionChip(
                  avatar: const Icon(
                    Icons.access_time,
                  ),

                  label:
                      const Text(
                    'Pick Time',
                  ),

                  onPressed:
                      pickExactTime,
                ),
              ],
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  expectedTimeController,

              readOnly: true,

              decoration:
                  const InputDecoration(
                labelText:
                    'Expected Time',

                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  remarksController,

              maxLines: 3,

              decoration:
                  const InputDecoration(
                labelText:
                    'Remarks',

                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed:
                    isSaving
                        ? null
                        : saveTrack,

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF003B8E,
                  ),

                  foregroundColor:
                      Colors.white,
                ),

                child: isSaving
                    ? const CircularProgressIndicator(
                        color:
                            Colors.white,
                      )
                    : const Text(
                        'SAVE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}