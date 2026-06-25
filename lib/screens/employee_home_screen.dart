import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/theme_service.dart';
import 'manage_tracks_screen.dart';
import '../widgets/smart_gate_card.dart';
import 'gate_detail_screen.dart';

class EmployeeHomeScreen extends StatefulWidget {
  final String employeeId;

  const EmployeeHomeScreen({
    super.key,
    required this.employeeId,
  });

  @override
  State<EmployeeHomeScreen> createState() =>
      _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState
    extends State<EmployeeHomeScreen> {

  int selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
  HomeTab(
    employeeId: widget.employeeId,
  ),

  NotificationsTab(
    employeeId: widget.employeeId,
  ),

  EmployeeActivityTab(
    employeeId: widget.employeeId,
  ),

  SettingsTab(
    employeeId: widget.employeeId,
  ),
];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
  currentIndex: selectedIndex,

  backgroundColor: Colors.black,

  selectedItemColor: Colors.cyan,

  unselectedItemColor: Colors.white,

  selectedFontSize: 14,

  unselectedFontSize: 12,

  iconSize: 30,

  type: BottomNavigationBarType.fixed,

  onTap: (index) {
    setState(() {
      selectedIndex = index;
    });
  },

  items: const [

    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'Activity',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Notifications',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ],
),
    );
  }
}

class HomeTab extends StatelessWidget {
  final String employeeId;

  const HomeTab({
    super.key,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Railway Crossing Alerts',
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
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),

                title: Text(
                  employeeId,
                ),

                subtitle: const Text(
                  'Employee',
                ),
              ),
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 20),

const Text(
  'Gate Overview',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

const SizedBox(height: 25),

            Expanded(
              child: StreamBuilder<
                  DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection(
                            'employees')
                        .doc(employeeId)
                        .snapshots(),

                builder:
                    (context,
                        employeeSnapshot) {

                  if (!employeeSnapshot
                      .hasData) {

                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  final employeeData =
                      employeeSnapshot
                              .data!
                              .data()
                          as Map<String,
                              dynamic>;

                  final selectedTracks =
                      List<String>.from(
                    employeeData[
                            'selectedTracks'] ??
                        [],
                  );

                  if (selectedTracks
                      .isEmpty) {

                    return const Center(
                      child: Text(
                        'No subscribed tracks.',
                      ),
                    );
                  }

                  return StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('gates')
      .snapshots(),

  builder: (context, gateSnapshot) {

    if (!gateSnapshot.hasData) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    final gates =
        gateSnapshot.data!.docs;

    return ListView.builder(
      itemCount: gates.length,

      itemBuilder:
          (context, index) {

        final gate =
            gates[index];

        final data =
            gate.data()
                as Map<String, dynamic>;

        return SmartGateCard(
          gateName:
              data['gateName'] ?? '',

          status:
              data['status'] ?? 'OPEN',

          updatedBy:
              data['updatedBy'] ?? '',

          updatedByName:
              data['updatedByName'] ?? '',

          updatedAt:
              data['updatedAt'] == null
                  ? ''
                  : data['updatedAt']
                      .toDate()
                      .toString(),

          direction: 'A_TO_C',

          currentPosition: 'A',

          onTap: () {
  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) =>
    GateDetailsScreen(
      gateId: gate.id,
    ),
  ),
);
},
        );
      },
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
class TrackStatusCard extends StatelessWidget {
  final String trackId;

  const TrackStatusCard({
    super.key,
    required this.trackId,
  });

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tracks')
          .doc(trackId)
          .snapshots(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Card(
            child: ListTile(
              title: Text('Loading...'),
            ),
          );
        }

        if (!snapshot.data!.exists) {
          return Card(
            child: ListTile(
              title: Text(
                trackId.toUpperCase(),
              ),
              subtitle: const Text(
                'Track not found.',
              ),
            ),
          );
        }

        final data =
            snapshot.data!.data()
                as Map<String, dynamic>;

        final status =
            data['status'] ?? '';

        final expectedTime =
            data['expectedTime'] ?? '';

        final remarks =
            data['remarks'] ?? '';

        final updatedBy =
            data['updatedBy'] ?? '';

        final updatedAt =
            data['updatedAt'];

        IconData statusIcon;
        Color statusColor;

        switch (status) {

          case 'OPEN':
            statusIcon =
                Icons.check_circle;
            statusColor =
                Colors.green;
            break;

          case 'CLOSED':
            statusIcon =
                Icons.cancel;
            statusColor =
                Colors.red;
            break;

          case 'EXPECTED_TO_CLOSE':
            statusIcon =
                Icons.warning;
            statusColor =
                Colors.orange;
            break;

          case 'EXPECTED_TO_OPEN':
            statusIcon =
                Icons.access_time;
            statusColor =
                Colors.blue;
            break;

          default:
            statusIcon =
                Icons.help;
            statusColor =
                Colors.grey;
        }

        String updatedAtText = '';

        if (updatedAt != null) {

          final date =
              updatedAt.toDate();

          updatedAtText =
              '${date.day}/${date.month}/${date.year}'
              ' ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
        }

        return Card(
          margin:
              const EdgeInsets.only(
            bottom: 12,
          ),

          elevation: 4,

          child: Padding(
            padding:
                const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Icon(
                      statusIcon,
                      color:
                          statusColor,
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Text(
                      trackId
                          .toUpperCase(),

                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(
                  'Status: $status',

                  style: TextStyle(
                    color:
                        statusColor,

                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),

                if (expectedTime
                    .toString()
                    .isNotEmpty)

                  Padding(
                    padding:
                        const EdgeInsets
                            .only(
                      top: 6,
                    ),

                    child: Text(
                      status ==
                              'CLOSED'
                          ? 'Expected Opening: $expectedTime'
                          : status ==
                                  'EXPECTED_TO_CLOSE'
                              ? 'Expected Closing: $expectedTime'
                              : 'Expected Time: $expectedTime',
                    ),
                  ),

                if (remarks
                    .toString()
                    .isNotEmpty)

                  Padding(
                    padding:
                        const EdgeInsets
                            .only(
                      top: 6,
                    ),

                    child: Text(
                      'Remarks: $remarks',
                    ),
                  ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  'Updated By: '
                  '$updatedBy',
                ),

                if (updatedAtText
                    .isNotEmpty)

                  Text(
                    'Updated At: '
                    '$updatedAtText',
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
class NotificationsTab extends StatelessWidget {
  final String employeeId;

  const NotificationsTab({
    super.key,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Notifications',
        ),

        backgroundColor:
            const Color(0xFF003B8E),

        foregroundColor:
            Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where(
              'active',
              isEqualTo: true,
            )
            .snapshots(),

        builder:
            (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final notifications =
              snapshot.data!.docs;

          if (notifications.isEmpty) {

            return const Center(
              child: Text(
                'No Notifications Found',
              ),
            );
          }

          return ListView.builder(

            itemCount:
                notifications.length,

            itemBuilder:
                (context, index) {

              final data =
                  notifications[index]
                          .data()
                      as Map<String,
                          dynamic>;

              return Card(

                margin:
                    const EdgeInsets.all(
                  12,
                ),

                elevation: 4,

                child: ListTile(

                  leading: Icon(
                    Icons.warning,
                    color:
                        data['priority'] ==
                                'HIGH'
                            ? Colors.red
                            : Colors.orange,
                  ),

                  title: Text(
                    data['title'] ?? '',
                  ),

                  subtitle: Text(
                    data['message'] ?? '',
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

class SettingsTab extends StatelessWidget {
  final String employeeId;

  const SettingsTab({
    super.key,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF003B8E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.alt_route),
                title: const Text(
  'Gate Overview',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ManageTracksScreen(
                        employeeId: employeeId,
                      ),
                    ),
                  );
                },
              ),

              const Divider(),

              SwitchListTile(
                title: const Text('Dark Mode'),
                value:
                    ThemeService.instance.isDarkMode,
                onChanged: (value) {
  ThemeService.instance
      .toggleTheme(value);
}
              ),

              const Spacer(),

              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                onPressed: () async {
                  await FirebaseAuth.instance
                      .signOut();

                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeActivityTab extends StatelessWidget {
  final String employeeId;

  const EmployeeActivityTab({
    super.key,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        backgroundColor:
            const Color(0xFF003B8E),
        foregroundColor:
            Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('activity_logs')
            .orderBy(
              'timestamp',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final logs =
              snapshot.data!.docs;

          if (logs.isEmpty) {
            return const Center(
              child: Text(
                'No Activity Found',
              ),
            );
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder:
                (context, index) {

              final data =
                  logs[index].data()
                      as Map<String,
                          dynamic>;

              return Card(
                margin:
                    const EdgeInsets.all(
                  10,
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: Colors.blue,
                  ),
                  title: Text(
                    data['action'] ?? '',
                  ),
                  subtitle: Text(
                    '${data['gateId']} • ${data['status']}',
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