import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/providers/driver_provider.dart';
import 'package:provider/provider.dart';

class BarChart extends StatelessWidget {
  const BarChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Delivery Stats'),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: Provider.of<DriverProvider>(context, listen: false)
                    .getDailyCompletedTasks(),
                builder: (context, snapshot) {
                  return DChartBar(
                    data: [
                      {
                        'id': 'Bar',
                        'data': snapshot.connectionState == ConnectionState.done
                            ? snapshot.data!
                            : [
                                {'domain': 'Mon', 'measure': 3},
                                {'domain': 'Tue', 'measure': 4},
                                {'domain': 'Wed', 'measure': 6},
                                {'domain': 'Thur', 'measure': 3},
                                {'domain': 'Fri', 'measure': 6},
                                {'domain': 'Sat', 'measure': 5},
                                {'domain': 'Sun', 'measure': 4},
                              ],
                      },
                    ],
                    domainLabelPaddingToAxisLine: 15,
                    minimumPaddingBetweenLabel: 15,
                    axisLineTick: 2,
                    axisLinePointTick: 2,
                    axisLinePointWidth: 10,
                    axisLineColor: Colors.grey[300],
                    measureLabelPaddingToAxisLine: 16,
                    animationDuration: const Duration(seconds: 1),
                    barColor: (barData, index, id) => kIconColor,
                    showBarValue: true,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
