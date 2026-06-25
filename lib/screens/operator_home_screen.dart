import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'gate_operation_screen.dart';
import 'operator_activity_screen.dart';
import 'settings_screen.dart';
import 'operator_notification_screen.dart';
import 'package:flutter/material.dart';

class OperatorHomeScreen extends StatefulWidget {
  final String operatorId;

  const OperatorHomeScreen({
    super.key,
    required this.operatorId,
  });

  @override
  State<OperatorHomeScreen> createState() =>
      _OperatorHomeScreenState();
}

class _OperatorHomeScreenState
    extends State<OperatorHomeScreen> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    final pages = [

  _buildHomePage(),

  OperatorActivityScreen(
    operatorId: widget.operatorId,
  ),

  OperatorNotificationScreen(),

  const SettingsScreen(),
];

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Operator Home',
        ),
      ),

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

  Widget _buildHomePage() {

    return Padding(
      padding:
          const EdgeInsets.all(16),

      child: Column(
        children: [

          Card(
            elevation: 6,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),

            child: Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),

              child: Row(
                children: [

                  CircleAvatar(
                    radius: 32,

                    backgroundColor:
                        Colors.blue.shade100,

                    child: const Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(
                    width: 15,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        const Text(
                          'AJAY',

                          style:
                              TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          widget.operatorId,
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                Colors.green,

                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: const Text(
                            'TRACK 1',

                            style:
                                TextStyle(
                              color:
                                  Colors.white,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          const Text(
            'Assigned Gates',

            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Expanded(
  child: StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('operators')
        .doc(widget.operatorId)
        .snapshots(),
    builder: (context, operatorSnapshot) {

      if (!operatorSnapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final operatorData =
          operatorSnapshot.data!.data()
              as Map<String, dynamic>;

      final assignedGates =
          List<String>.from(
        operatorData['assignedGates'] ?? [],
      );

      return ListView.builder(
        itemCount: assignedGates.length,

        itemBuilder: (context, index) {

          final gateId =
              assignedGates[index];

          return StreamBuilder<
              DocumentSnapshot>(
            stream: FirebaseFirestore
                .instance
                .collection('gates')
                .doc(gateId)
                .snapshots(),

            builder: (context, gateSnapshot) {

              if (!gateSnapshot.hasData) {
                return const SizedBox();
              }

              final gateData =
                  gateSnapshot.data!.data()
                      as Map<String, dynamic>?;

              final status =
                  gateData?['status'] ??
                      'OPEN';

              return Card(
                child: ListTile(

                  leading: Icon(
                    Icons.traffic,
                    color:
                        status == 'OPEN'
                            ? Colors.green
                            : Colors.red,
                  ),

                  title: Text(
                    gateData?['gateName'] ??
                        gateId,
                  ),

                  subtitle: Text(
                    'Status: $status',
                  ),

                  trailing:
                      ElevatedButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GateOperationScreen(
                            gateId:
                                gateId,
                            operatorId:
                                widget
                                    .operatorId,
                          ),
                        ),
                      );
                    },

                    child: const Text(
                      'Operate',
                    ),
                  ),
                ),
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
    );
  }
}