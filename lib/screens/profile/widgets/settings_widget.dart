import 'package:flutter/material.dart';
import 'package:gas_driver/helpers/lists.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final driver = Provider.of<AuthProvider>(context, listen: false).driver!;
    return Column(
      children: List.generate(
          settingOptions.length,
          (index) => GestureDetector(
                onTap: () {
                  settingOptions[index]['onTap']();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: settingOptions[index]['secondaryColor'],
                            borderRadius: BorderRadius.circular(3)),
                        child: Icon(
                          settingOptions[index]['icon'],
                          size: 20,
                          color: settingOptions[index]['color'],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        settingOptions[index]['title'],
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}
