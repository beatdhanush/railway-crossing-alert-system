import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/smart_track_card.dart';
import 'admin_approvals_screen.dart';
import 'gate_management_screen.dart';
import 'edit_track_screen.dart';
import 'operator_management_screen.dart';
import 'employee_management_screen.dart';
import 'manage_tracks_screen.dart';
import 'notification_center_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final String adminId;

  const AdminDashboardScreen({
    super.key,
    required this.adminId,
  });

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {

  bool isLoading = true;

  String adminName = '';

  List<String> trackIds = [];

  @override
  void initState() {
    super.initState();
    loadAdminData();
  }

  Future<void> loadAdminData() async {
    try {

      final adminDoc =
          await FirebaseFirestore.instance
              .collection('admins')
              .doc(widget.adminId)
              .get();

      if (adminDoc.exists) {

        final data = adminDoc.data()!;

        adminName =
            data['name'] ?? '';

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
              'Failed to load admin dashboard: $e',
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
          'Admin Dashboard',
        ),

        backgroundColor:
            const Color(0xFF003B8E),

        foregroundColor:
            Colors.white,

        actions: [

          IconButton(
  icon: const Icon(
  Icons.verified_user,
  color: Colors.white,
  size: 28,
),

            tooltip:
                'Employee Approvals',

            onPressed: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const AdminApprovalsScreen(),
                ),
              );
            },
          ),
        ],
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
                    Icons.admin_panel_settings,
                  ),
                ),

                title: Text(
                  adminName,
                ),

                subtitle: Text(
                  widget.adminId,
                ),
              ),
            ),
            const Text(
  'Management',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

GridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: 2,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  childAspectRatio: 1.4,

  children: [

    _adminCard(
        context,

      'Tracks',
      Icons.alt_route,
      Colors.blue,
    ),

    _adminCard(
        context,

      'Gates',
      Icons.traffic,
      Colors.green,
    ),

    _adminCard(
        context,

      'Operators',
      Icons.engineering,
      Colors.orange,
    ),

    _adminCard(
        context,

      'Employees',
      Icons.people,
      Colors.purple,
    ),

    _adminCard(
        context,

      'Notifications',
      Icons.notifications,
      Colors.red,
    ),

    _adminCard(
        context,

      'Reports',
      Icons.bar_chart,
      Colors.teal,
    ),
  ],
),

const SizedBox(height: 20),

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

                    role: 'admin',

                    onEdit: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              EditTrackScreen(

                            trackId:
                                trackId,

                            updatedBy:
                                widget.adminId,

                            updatedRole:
                                'admin',
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

Widget _adminCard(
  BuildContext context,
  String title,
  IconData icon,
  Color color,
) {
  return Card(
    elevation: 4,

    child: InkWell(
      onTap: () {

  // TRACKS
  if (title == 'Tracks') {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Track Management Module Coming Soon',
        ),
      ),
    );

    return;
  }

  // GATES
  if (title == 'Gates') {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const GateManagementScreen(),
      ),
    );

    return;
  }

  // OPERATORS
  if (title == 'Operators') {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const OperatorManagementScreen(),
      ),
    );

    return;
  }

  // EMPLOYEES
  if (title == 'Employees') {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const EmployeeManagementScreen(),
      ),
    );

    return;
  }

  // NOTIFICATIONS
  if (title == 'Notifications') {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const NotificationCenterScreen(),
      ),
    );

    return;
  }

  // REPORTS
  if (title == 'Reports') {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Reports Module Coming Soon',
        ),
      ),
    );

    return;
  }
},

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 35,
            color: color,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            title,
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}