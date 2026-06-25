import 'package:flutter/material.dart';

class VerticalTrainTimeline extends StatelessWidget {
  final String direction;
  final String currentPosition;
  final String journeyStatus;

  const VerticalTrainTimeline({
    super.key,
    required this.direction,
    required this.currentPosition,
    required this.journeyStatus,
  });

  @override
  Widget build(BuildContext context) {
    final nodes =
        direction == 'A_TO_C'
            ? [
                'A',
                'GATE1',
                'GATE2',
                'GATE3',
                'C',
              ]
            : [
                'C',
                'GATE3',
                'GATE2',
                'GATE1',
                'A',
              ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
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
                const Icon(
                  Icons.train,
                  color: Colors.blue,
                ),

                const SizedBox(width: 8),

                Text(
                  direction == 'A_TO_C'
                      ? 'Direction: A → C'
                      : 'Direction: C → A',
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            ...nodes.map(
  (node) => _buildNode(node),
),

const SizedBox(
  height: 15,
),

_buildNextGateCard(),

const SizedBox(
  height: 15,
),

_buildProgressBar(),

            const SizedBox(height: 15),

            Row(
              children: [
                Icon(
                  _statusIcon(),
                  color: _statusColor(),
                ),

                const SizedBox(width: 10),

                Text(
                  journeyStatus,
                  style:
                      TextStyle(
                    color:
                        _statusColor(),
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

Widget _buildNode(
  String node,
) {
  final nodeIndex =
      nodesOrder().indexOf(node);

  final currentIndex =
      nodesOrder().indexOf(
    currentPosition,
  );

  final isCurrent =
      node == currentPosition;

  final isPassed =
      nodeIndex < currentIndex;

  return Container(
    margin:
        const EdgeInsets.only(
      bottom: 12,
    ),

    padding:
        const EdgeInsets.all(10),

    decoration:
        isCurrent
            ? BoxDecoration(
                color: Colors.blue
                    .shade50,

                borderRadius:
                    BorderRadius
                        .circular(
                  12,
                ),
              )
            : null,

    child: Row(
      children: [

        Icon(
          isCurrent
              ? Icons.train
              : isPassed
                  ? Icons.check_circle
                  : Icons.circle,

          color: isCurrent
              ? Colors.blue
              : isPassed
                  ? Colors.green
                  : Colors.grey,

          size:
              isCurrent ? 30 : 18,
        ),

        const SizedBox(
          width: 12,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [

              Text(
                _displayName(
                  node,
                ),

                style:
                    TextStyle(
                  fontSize:
                      isCurrent
                          ? 20
                          : 16,

                  fontWeight:
                      isCurrent ||
                              isPassed
                          ? FontWeight
                              .bold
                          : FontWeight
                              .normal,

                  color:
                      isCurrent
                          ? Colors.blue
                          : isPassed
                              ? Colors.green
                              : Colors
                                  .black,
                ),
              ),

              if (isCurrent)
                const Text(
                  'Current Position',

                  style:
                      TextStyle(
                    color:
                        Colors.blue,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildNextGateCard() {

  final currentIndex =
      nodesOrder().indexOf(
    currentPosition,
  );

  String nextGate =
      'Destination Reached';

  if (currentIndex <
      nodesOrder().length - 1) {

    nextGate =
        _displayName(
      nodesOrder()[
          currentIndex + 1],
    );
  }

  return Container(
    padding:
        const EdgeInsets.all(
      14,
    ),

    decoration:
        BoxDecoration(
      color:
          Colors.orange.shade50,

      borderRadius:
          BorderRadius.circular(
        12,
      ),
    ),

    child: Row(
      children: [

        const Icon(
          Icons.warning,
          color: Colors.orange,
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: Text(
            'Next Impact: $nextGate',

            style:
                const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildProgressBar() {

  final currentIndex =
      nodesOrder().indexOf(
    currentPosition,
  );

  final progress =
      (currentIndex + 1) /
          nodesOrder().length;

  return Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [

      LinearProgressIndicator(
        value: progress,
        minHeight: 10,
      ),

      const SizedBox(
        height: 8,
      ),

      Text(
        '${(progress * 100).toInt()}% Journey Completed',
      ),
    ],
  );
}

List<String> nodesOrder() {
  return direction == 'A_TO_C'
      ? [
          'A',
          'GATE1',
          'GATE2',
          'GATE3',
          'C',
        ]
      : [
          'C',
          'GATE3',
          'GATE2',
          'GATE1',
          'A',
        ];
}

  String _displayName(
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

  IconData _statusIcon() {
    switch (journeyStatus) {

      case 'MOVING':
        return Icons.play_arrow;

      case 'HALTED':
        return Icons.pause;

      case 'COMPLETED':
        return Icons.check_circle;

      default:
        return Icons.info;
    }
  }

  Color _statusColor() {
    switch (journeyStatus) {

      case 'MOVING':
        return Colors.green;

      case 'HALTED':
        return Colors.orange;

      case 'COMPLETED':
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }
}
class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'TEST WIDGET',
    );
  }
}
class DummyTimeline extends StatelessWidget {
  const DummyTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'DUMMY TIMELINE',
    );
  }
}