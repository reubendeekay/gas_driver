import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:gas_driver/providers/driver_provider.dart';
import 'package:gas_driver/screens/home/widgets/bar_chart.dart';
import 'package:gas_driver/screens/home/widgets/on_delivery_tile.dart';
import 'package:gas_driver/screens/home/widgets/radial_chart.dart';
import 'package:provider/provider.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          if (user.transitId != null) const OnDeliveryTile(),
          const SizedBox(
            height: 15,
          ),
          FutureBuilder<Map>(
              future: Provider.of<DriverProvider>(context, listen: false)
                  .getComlpetedTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
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
                  );
                }
                final data = snapshot.data!;
                return Row(
                  children: [
                    Expanded(
                        child: RadialChart(
                      completed: data['completed'],
                      total: data['allOrders'],
                      title: 'Completed',
                    )),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: RadialChart(
                      completed: data['myLastWeekOrders'],
                      total: data['lastWeekOrders'],
                      color: kPrimaryColor,
                      title: 'Last Week',
                    )),
                  ],
                );
              }),
          const Expanded(child: BarChart()),
        ]),
      ),
    );
  }
}
