import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GateOperationScreen extends StatefulWidget {
  final String gateId;
  final String operatorId;

  const GateOperationScreen({
    super.key,
    required this.gateId,
    required this.operatorId,
  });

  @override
  State<GateOperationScreen> createState() =>
      _GateOperationScreenState();
}

class _GateOperationScreenState
    extends State<GateOperationScreen> {

  String selectedStatus = '';
bool isLoading = true;

  final remarksController =
      TextEditingController();

      Future<void> loadGateData() async {
  try {
    final gateDoc = await FirebaseFirestore.instance
        .collection('gates')
        .doc(widget.gateId)
        .get();

    if (gateDoc.exists) {
      setState(() {
        selectedStatus =
            gateDoc.data()?['status'] ?? 'OPEN';

        isLoading = false;
      });
    } else {
      setState(() {
        selectedStatus = 'OPEN';
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      selectedStatus = 'OPEN';
      isLoading = false;
    });
  }
}
@override
void initState() {
  super.initState();
  loadGateData();
}

Future<void> sendNotification() async {
  try {

    final response =
        await http.post(

      Uri.parse(
         'https://railway-crossing-alert-system.onrender.com/sendGateAlert',
      ),

      headers: {
        'Content-Type':
            'application/json',
      },

      body: jsonEncode({

        'gateId':
            widget.gateId,

        'status':
            selectedStatus,

        'track':
            'TRACK1',
      }),
    );

    print(
      'NOTIFICATION RESPONSE => ${response.body}',
    );

  } catch (e) {

    print(
      'NOTIFICATION ERROR => $e',
    );
  }
}

     Future<void> saveUpdate() async {

  try {

    await FirebaseFirestore.instance
    .collection('gates')
    .doc(widget.gateId)
    .update({

      'status': selectedStatus,

      'remarks':
          remarksController.text,

      'updatedBy':
          widget.operatorId,

      'updatedRole':
          'operator',

      'updatedAt':
          FieldValue.serverTimestamp(),

  });

    await FirebaseFirestore.instance
        .collection('activity_logs')
        .add({

      'gateId':
          widget.gateId,

      'action':
          'Gate Status Updated',

      'status':
          selectedStatus,

      'remarks':
          remarksController.text,

      'updatedBy':
          widget.operatorId,

      'updatedRole':
          'operator',

      'timestamp':
          FieldValue.serverTimestamp(),
    });

await sendNotification();

    if (mounted) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            'Gate Updated Successfully',
          ),
        ),
      );
    }

  } catch (e) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(
          'Error: $e',
        ),
      ),
    );
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
        title: Text(widget.gateId),

        backgroundColor:
            const Color(0xFF003B8E),

        foregroundColor:
            Colors.white,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            Card(
              elevation: 6,

              child: Padding(
                padding:
                    const EdgeInsets.all(
                  20,
                ),

                child: Column(
                  children: [

                    const Icon(
                      Icons.traffic,
                      size: 60,
                      color: Colors.green,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      widget.gateId,

                      style:
                          const TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
        
const SizedBox(
  height: 20,
),

Card(
  elevation: 4,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        const Text(
          'Gate Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 15,
        ),

        Text(
          'Gate ID : ${widget.gateId}',
        ),

        const SizedBox(
          height: 8,
        ),

        Text(
          'Operator : ${widget.operatorId}',
        ),

        const SizedBox(
          height: 8,
        ),

        const Text(
          'Track : TRACK1',
        ),

        const SizedBox(
          height: 8,
        ),

        Text(
          'Current Status : $selectedStatus',
        ),
      ],
    ),
  ),
),

const SizedBox(
  height: 20,
),

Card(
            
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  16,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    const Text(
                      'Gate Status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                   Row(
  children: [

    Expanded(
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              selectedStatus ==
                      'OPEN'
                  ? Colors.green
                  : Colors.grey,
        ),

        onPressed: () {
          setState(() {
            selectedStatus =
                'OPEN';
          });
        },

        child: const Text(
          'OPEN',
        ),
      ),
    ),

    const SizedBox(
      width: 12,
    ),

    Expanded(
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              selectedStatus ==
                      'CLOSED'
                  ? Colors.red
                  : Colors.grey,
        ),

        onPressed: () {
          setState(() {
            selectedStatus =
                'CLOSED';
          });
        },

        child: const Text(
          'CLOSED',
        ),
      ),
    ),
  ],
), 
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
                  remarksController,

              maxLines: 4,

              decoration:
                  const InputDecoration(
                labelText:
                    'Remarks',

                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,

              height: 55,

              child:
                  ElevatedButton(
                onPressed: () async {

  print('BUTTON CLICKED');

  await saveUpdate();
},

                child: Text(
  'SAVE $selectedStatus',
),
              ),
            ),
          ],
        ),
      ),
    );
  }
}