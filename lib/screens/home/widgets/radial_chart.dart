import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';
import 'package:gas_driver/constants.dart';

class RadialChart extends StatelessWidget {
  const RadialChart(
      {Key? key,
      this.color,
      required this.completed,
      required this.total,
      required this.title})
      : super(key: key);
  final int completed;
  final int total;
  final Color? color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Progress',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(
            height: 130,
            child: Stack(
              children: [
                SizedBox(
                  height: 130,
                  child: DChartGauge(
                    data: [
                      {'domain': 'Completed', 'measure': completed},
                      {'domain': 'Remaining', 'measure': total - completed},
                    ],
                    fillColor: (pieData, index) {
                      switch (pieData['domain']) {
                        case 'Completed':
                          return color ?? kIconColor;

                        default:
                          return color != null
                              ? color!.withOpacity(0.2)
                              : kIconColor.withOpacity(0.2);
                      }
                    },
                    showLabelLine: false,
                    labelPosition: PieLabelPosition.inside,
                    labelPadding: 0,
                    animate: true,
                    donutWidth: 8,
                    strokeWidth: 0,
                    labelLineColor: Colors.transparent,
                    labelColor: Colors.transparent,
                  ),
                ),
                Center(
                  child: Text(
                    '$completed/$total',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
