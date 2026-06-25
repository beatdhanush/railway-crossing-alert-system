import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageTracksScreen extends StatefulWidget {
  final String employeeId;

  const ManageTracksScreen({
    super.key,
    required this.employeeId,
  });

  @override
  State<ManageTracksScreen> createState() =>
      _ManageTracksScreenState();
}

class _ManageTracksScreenState
    extends State<ManageTracksScreen> {

  bool isLoading = true;

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

  @override
  void initState() {
    super.initState();
    loadTracks();
  }

  Future<void> loadTracks() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('employees')
          .doc(widget.employeeId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        final selectedTracks =
            List<String>.from(
          data['selectedTracks'] ?? [],
        );

        for (final track in selectedTracks) {
          if (tracks.containsKey(track)) {
            tracks[track] = true;
          }
        }
      }

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

    } catch (e) {

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Failed to load tracks: $e',
          ),
        ),
      );
    }
  }

  Widget buildTrackTile(String trackId) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),

        borderRadius:
            BorderRadius.circular(15),
      ),

      child: CheckboxListTile(
        value: tracks[trackId],

        activeColor:
            const Color(0xFF003B8E),

        title: Text(
          trackId.toUpperCase(),

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        subtitle: Text(
          trackNames[trackId]!,
        ),

        onChanged: (value) {
          setState(() {
            tracks[trackId] =
                value ?? false;
          });
        },
      ),
    );
  }
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
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Track preferences updated successfully.',
          ),
        ),
      );

      Navigator.pop(context);

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

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Subscribed Tracks',
        ),
        backgroundColor: const Color(0xFF003B8E),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            const Text(
              'Choose the railway crossings you want to receive alerts for.',

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  buildTrackTile('track1'),
                  buildTrackTile('track2'),
                  buildTrackTile('track3'),
                  buildTrackTile('track4'),
                  buildTrackTile('track5'),
                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed:
                    isLoading ? null : saveTracks,

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF003B8E),

                  foregroundColor: Colors.white,
                ),

                child: const Text(
                  'Save Changes',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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