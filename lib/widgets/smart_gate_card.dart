import 'package:flutter/material.dart';

class SmartGateCard extends StatelessWidget {
  final String gateName;

  final String status;

  final String updatedBy;

  final String updatedByName;

  final String updatedAt;

  final String direction;

  final String currentPosition;

  final VoidCallback? onTap;

  const SmartGateCard({
    super.key,
    required this.gateName,
    required this.status,
    required this.updatedBy,
    required this.updatedByName,
    required this.updatedAt,
    required this.direction,
    required this.currentPosition,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen =
        status == 'OPEN';

    return Card(
      elevation: 4,

      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: InkWell(
        borderRadius:
            BorderRadius.circular(16),

        onTap: onTap,

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
                    isOpen
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: isOpen
                        ? Colors.green
                        : Colors.red,
                    size: 28,
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Text(
                      gateName,
                      style:
                          const TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  if (onTap != null)
                    const Icon(
                      Icons.chevron_right,
                    ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              Text(
                'Status: $status',
                style: TextStyle(
                  color: isOpen
                      ? Colors.green
                      : Colors.red,
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                'Updated By: $updatedBy',
              ),

              Text(
                'Operator: $updatedByName',
              ),

              Text(
                'Updated At: $updatedAt',
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                'Direction: '
                '${direction == "A_TO_C" ? "A → C" : "C → A"}',
              ),

              Text(
                'Train Position: '
                '$currentPosition',
              ),
            ],
          ),
        ),
      ),
    );
  }
}