import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';

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
            child: DChartBar(
              data: const [
                {
                  'id': 'Bar',
                  'data': [
                    {'domain': '1', 'measure': 3},
                    {'domain': '2', 'measure': 4},
                    {'domain': '3', 'measure': 6},
                    {'domain': '4', 'measure': 3},
                    {'domain': '5', 'measure': 6},
                    {'domain': '6', 'measure': 5},
                    {'domain': '7', 'measure': 4},
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
            ),
          ),
        ],
      ),
    );
  }
}
