import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/screens/home/widgets/bar_chart.dart';
import 'package:gas_driver/screens/home/widgets/on_delivery_tile.dart';
import 'package:gas_driver/screens/home/widgets/radial_chart.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          const OnDeliveryTile(),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: const [
              Expanded(
                  child: RadialChart(
                completed: 55,
                total: 100,
                title: 'Completed',
              )),
              SizedBox(
                width: 15,
              ),
              Expanded(
                  child: RadialChart(
                completed: 70,
                total: 78,
                color: kPrimaryColor,
                title: 'Last Week',
              )),
            ],
          ),
          const Expanded(child: BarChart()),
        ]),
      ),
    );
  }
}
