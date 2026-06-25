import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'employee_home_screen.dart';

class TrackSelectionScreen extends StatefulWidget {
  final String employeeId;

  const TrackSelectionScreen({
    super.key,
    required this.employeeId,
  });

  @override
  State<TrackSelectionScreen> createState() =>
      _TrackSelectionScreenState();
}

class _TrackSelectionScreenState
    extends State<TrackSelectionScreen> {

  bool isLoading = false;

  final Map<String, bool> tracks = {
    'track1': false,
    'track2': false,
    'track3': false,
    'track4': false,
    'track5': false,
  };

  final Map<String, String> trackNames = {
    'track1': 'Main Line Crossing',
    'track2': 'Steel Plant Crossing',
    'track3': 'South Yard Crossing',
    'track4': 'North Gate Crossing',
    'track5': 'Coal Line Crossing',
  };

  Future<void> saveTracks() async {
    final selectedTracks = tracks.entries
        .where((track) => track.value)
        .map((track) => track.key)
        .toList();

    if (selectedTracks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select at least one track.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(widget.employeeId)
          .update({
        'selectedTracks': selectedTracks,
        'trackSelectionCompleted': true,
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EmployeeHomeScreen(
            employeeId: widget.employeeId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save tracks: $e',
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

  Widget buildTrackTile(String trackId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),

        borderRadius: BorderRadius.circular(15),
      ),

      child: CheckboxListTile(
        value: tracks[trackId],

        activeColor: const Color(0xFF003B8E),

        title: Text(
          trackId.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(trackNames[trackId]!),

        onChanged: (value) {
          setState(() {
            tracks[trackId] = value ?? false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF001F54),
              Color(0xFF003B8E),
            ],

            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),

              padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),

                borderRadius:
                    BorderRadius.circular(30),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),

              child: Column(
                children: [

                  const Icon(
                    Icons.alt_route,
                    size: 70,
                    color: Color(0xFF003B8E),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Choose Your Routes',

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Select the railway crossings you want to track.',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  buildTrackTile('track1'),
                  buildTrackTile('track2'),
                  buildTrackTile('track3'),
                  buildTrackTile('track4'),
                  buildTrackTile('track5'),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : saveTracks,

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF003B8E),

                        foregroundColor:
                            Colors.white,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  15),
                        ),
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Continue',

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
          ),
        ),
      ),
    );
  }
}