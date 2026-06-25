import 'package:flutter/material.dart';

import 'gate_management_screen.dart';
import 'operator_management_screen.dart';
import 'employee_management_screen.dart';
import 'manage_tracks_screen.dart';
import 'notification_center_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  final String adminId;

  const AdminHomeScreen({
    super.key,
    required this.adminId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF003B8E),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,

          children: [

            _dashboardCard(
              context,
              'Tracks',
              Icons.alt_route,
              Colors.blue,
            ),

            _dashboardCard(
              context,
              'Gates',
              Icons.traffic,
              Colors.green,
            ),

            _dashboardCard(
              context,
              'Operators',
              Icons.engineering,
              Colors.orange,
            ),

            _dashboardCard(
              context,
              'Employees',
              Icons.people,
              Colors.purple,
            ),

            _dashboardCard(
              context,
              'Notifications',
              Icons.notifications,
              Colors.red,
            ),

            _dashboardCard(
              context,
              'Reports',
              Icons.bar_chart,
              Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 5,

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
              size: 50,
              color: color,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}