import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/vertical_train_timeline.dart';

class GateDetailsScreen extends StatelessWidget {
  final String gateId;

  const GateDetailsScreen({
    super.key,
    required this.gateId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gateId),
        backgroundColor:
            const Color(0xFF003B8E),
        foregroundColor:
            Colors.white,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

          StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore
      .instance
      .collection('gates')
      .doc(gateId)
      .snapshots(),

  builder: (context, snapshot) {

    if (!snapshot.hasData ||
        !snapshot.data!.exists) {
      return const SizedBox();
    }

    final gateData =
        snapshot.data!.data()
            as Map<String, dynamic>;

    final status =
        gateData['status'] ?? 'OPEN';

    return Card(
      elevation: 8,

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                Container(
                  padding:
                      const EdgeInsets.all(
                    12,
                  ),

                  decoration:
                      BoxDecoration(
                    color: status ==
                            'OPEN'
                        ? Colors.green.shade100
                        : Colors.red.shade100,

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: Icon(
                    Icons.traffic,

                    color: status ==
                            'OPEN'
                        ? Colors.green
                        : Colors.red,

                    size: 30,
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: Text(
                    gateData['gateName']
                            ??
                        gateId,

                    style:
                        const TextStyle(
                      fontSize: 26,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),

              decoration:
                  BoxDecoration(
                color: status ==
                        'OPEN'
                    ? Colors.green
                    : Colors.red,

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Text(
                status,

                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            Text(
              'Updated By: ${gateData['updatedBy'] ?? ''}',
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Role: ${gateData['updatedRole'] ?? ''}',
            ),
          ],
        ),
      ),
    );
  },
),

const SizedBox(
  height: 15,
),  

StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore
      .instance
      .collection('train_state')
      .doc('current_journey')
      .snapshots(),

  builder: (context, snapshot) {

    if (!snapshot.hasData ||
        !snapshot.data!.exists) {
      return const SizedBox();
    }

    final trainData =
        snapshot.data!.data()
            as Map<String, dynamic>;

    return Card(
      elevation: 6,

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Row(
              children: [

                Icon(
                  Icons.train,
                  color: Colors.blue,
                ),

                SizedBox(width: 10),

                Text(
                  'LIVE TRAIN STATUS',

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),

          Row(
  children: [
    const Icon(Icons.swap_horiz,
        color: Colors.blue),
    const SizedBox(width: 10),
    Text(
      trainData['direction'] ==
              'A_TO_C'
          ? 'A → C'
          : 'C → A',
      style: const TextStyle(
        fontWeight:
            FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ],
),

const SizedBox(height: 10),

Row(
  children: [
    const Icon(
      Icons.location_on,
      color: Colors.red,
    ),
    const SizedBox(width: 10),
    Text(
      _displayNode(
        trainData[
            'currentPosition'],
      ),
      style: const TextStyle(
        fontSize: 16,
      ),
    ),
  ],
),

const SizedBox(height: 10),

Container(
  padding:
      const EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 8,
  ),

  decoration:
      BoxDecoration(
    color: Colors.green,
    borderRadius:
        BorderRadius.circular(20),
  ),

  child: Text(
    trainData['journeyStatus']
        .toString()
        .toUpperCase(),

    style: const TextStyle(
      color: Colors.white,
      fontWeight:
          FontWeight.bold,
    ),
  ),
),
          ],
        ),
      ),
    );
  },
),

const SizedBox(
  height: 15,
),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore
                  .instance
                  .collection(
                      'train_state')
                  .doc(
                      'current_journey')
                  .snapshots(),

              builder:
                  (context, snapshot) {

                if (!snapshot.hasData ||
                    !snapshot
                        .data!.exists) {
                  return const SizedBox();
                }

                final data =
                    snapshot.data!.data()
                        as Map<String,
                            dynamic>;

                return VerticalTrainTimeline(
                  direction:
                      data['direction'] ??
                          'A_TO_C',

                  currentPosition:
                      data['currentPosition'] ??
                          'A',

                  journeyStatus:
                      data['journeyStatus'] ??
                          'MOVING',
                );
              },
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'Activity Logs',
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore
                  .instance
                  .collection(
                      'activity_logs')
                  .orderBy(
                    'timestamp',
                    descending: true,
                  )
                  .limit(20)
                  .snapshots(),

              builder:
                  (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                final logs =
                    snapshot.data!.docs;

                if (logs.isEmpty) {
                  return const Text(
                    'No activity logs.',
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),

                  itemCount:
                      logs.length,

                  itemBuilder:
                      (context, index) {

                    final log =
                        logs[index];

                    final data =
                        log.data()
                            as Map<String,
                                dynamic>;

                    return Card(
  elevation: 8,

  shape:
      RoundedRectangleBorder(
    borderRadius:
        BorderRadius.circular(20),
  ),
                      child: ListTile(
                        leading: Container(
  padding:
      const EdgeInsets.all(8),

  decoration:
      BoxDecoration(
    color:
        Colors.blue.shade50,

    borderRadius:
        BorderRadius.circular(
      10,
    ),
  ),

  child: const Icon(
    Icons.railway_alert,
    color: Colors.blue,
  ),
),

                      title: Text(
  data['action'] ??
      'Gate Status Updated',

  style: const TextStyle(
    fontWeight:
        FontWeight.bold,
  ),
),  

                      subtitle: Column(
  crossAxisAlignment:
      CrossAxisAlignment.start,

  children: [

    const SizedBox(
      height: 6,
    ),

    Text(
      'Operator: ${data['updatedBy'] ?? 'SYSTEM'}',

      style: const TextStyle(
        fontWeight:
            FontWeight.w500,
      ),
    ),

    const SizedBox(
      height: 6,
    ),

    Text(
      data['timestamp'] == null
          ? ''
          : (data['timestamp']
                  as Timestamp)
              .toDate()
              .toString()
              .substring(0, 16),

      style: TextStyle(
        color:
            Colors.grey.shade700,
      ),
    ),
  ],
),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  String _displayNode(
  String node,
) {
  switch (node) {

    case 'A':
      return 'Point A';

    case 'GATE1':
      return 'Gate 1';

    case 'GATE2':
      return 'Gate 2';

    case 'GATE3':
      return 'Gate 3';

    case 'C':
      return 'Point C';

    default:
      return node;
  }
}
}