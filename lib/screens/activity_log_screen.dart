import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'activity_detail_screen.dart';

class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  State<ActivityLogScreen> createState() =>
      _ActivityLogScreenState();
}

class _ActivityLogScreenState
    extends State<ActivityLogScreen> {

  final searchController =
      TextEditingController();

  String selectedGate = 'ALL';

  String selectedDirection = 'ALL';

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Activity History',
        ),

        backgroundColor:
            const Color(0xFF003B8E),

        foregroundColor:
            Colors.white,
      ),

      body: Column(
        children: [

          Padding(
            padding:
                const EdgeInsets.all(16),

            child: Column(
              children: [

                TextField(
                  controller:
                      searchController,

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Search',
                    hintText:
                        'Operator / Action / Gate',
                    prefixIcon:
                        Icon(Icons.search),

                    border:
                        OutlineInputBorder(),
                  ),

                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                const SizedBox(
                  height: 12,
                ),

                Row(
                  children: [

                    Expanded(
                      child:
                          DropdownButtonFormField<String>(
                        value:
                            selectedGate,

                        decoration:
                            const InputDecoration(
                          labelText:
                              'Gate',

                          border:
                              OutlineInputBorder(),
                        ),

                        items: const [

                          DropdownMenuItem(
                            value: 'ALL',
                            child:
                                Text('All'),
                          ),

                          DropdownMenuItem(
                            value: 'gate1',
                            child:
                                Text('Gate 1'),
                          ),

                          DropdownMenuItem(
                            value: 'gate2',
                            child:
                                Text('Gate 2'),
                          ),

                          DropdownMenuItem(
                            value: 'gate3',
                            child:
                                Text('Gate 3'),
                          ),
                        ],

                        onChanged:
                            (value) {

                          setState(() {

                            selectedGate =
                                value!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                          DropdownButtonFormField<String>(
                        value:
                            selectedDirection,

                        decoration:
                            const InputDecoration(
                          labelText:
                              'Direction',

                          border:
                              OutlineInputBorder(),
                        ),

                        items: const [

                          DropdownMenuItem(
                            value: 'ALL',
                            child:
                                Text('All'),
                          ),

                          DropdownMenuItem(
                            value: 'A_TO_C',
                            child:
                                Text('A → C'),
                          ),

                          DropdownMenuItem(
                            value: 'C_TO_A',
                            child:
                                Text('C → A'),
                          ),
                        ],

                        onChanged:
                            (value) {

                          setState(() {

                            selectedDirection =
                                value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child:
                StreamBuilder<QuerySnapshot>(

              stream:
                  FirebaseFirestore.instance
                      .collection(
                        'movement_logs',
                      )
                      .orderBy(
                        'timestamp',
                        descending:
                            true,
                      )
                      .snapshots(),

              builder:
                  (context, snapshot) {

                if (snapshot.hasError) {

                  return const Center(
                    child: Text(
                      'Failed to load logs.',
                    ),
                  );
                }

                if (!snapshot.hasData) {

                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                final docs =
                    snapshot.data!.docs;

                final filtered =
                    docs.where((doc) {

                  final data =
                      doc.data()
                          as Map<String,
                              dynamic>;

                  final search =
                      searchController
                          .text
                          .toLowerCase();

                  final matchesSearch =
                      search.isEmpty ||

                          data['updatedBy']
                              .toString()
                              .toLowerCase()
                              .contains(
                                  search) ||

                          data['action']
                              .toString()
                              .toLowerCase()
                              .contains(
                                  search) ||

                          data['gateId']
                              .toString()
                              .toLowerCase()
                              .contains(
                                  search);

                  final matchesGate =
                      selectedGate ==
                              'ALL' ||

                          data['gateId'] ==
                              selectedGate;

                  final matchesDirection =
                      selectedDirection ==
                              'ALL' ||

                          data['direction'] ==
                              selectedDirection;

                  return matchesSearch &&
                      matchesGate &&
                      matchesDirection;
                }).toList();

                if (filtered.isEmpty) {

                  return const Center(
                    child: Text(
                      'No matching logs.',
                    ),
                  );
                }

                return ListView.builder(

                  itemCount:
                      filtered.length,

                  itemBuilder:
                      (context, index) {

                    final doc =
                        filtered[index];

                    final data =
                        doc.data()
                            as Map<String,
                                dynamic>;

                    return ListTile(

                      leading:
                          const Icon(
                        Icons.history,
                      ),

                      title: Text(
                        '${data['updatedBy']} '
                        '${data['action']} '
                        '${data['gateId']}',
                      ),

                      subtitle: Text(
                        '${data['direction']}'
                        ' • '
                        '${data['position']}',
                      ),

                      trailing:
                          const Icon(
                        Icons.chevron_right,
                      ),

                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                ActivityDetailScreen(
                              data: data,
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