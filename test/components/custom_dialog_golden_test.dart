import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter2025/components/custom_dialog.dart';

import '../support/alchemist/device.dart';

void main() {
  group('CustomDialog Golden Tests', () {
    Widget buildApp({required Brightness brightness, required Widget child}) {
      return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: brightness,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: child)),
      );
    }

    goldenTest(
      'renders correctly with different dialog types',
      fileName: 'custom_dialog_types',
      builder:
          () => GoldenTestGroup(
            columns: 2,
            children:
                Device.all
                    .map(
                      (device) => GoldenTestScenario(
                        name: '${device.name} - Success',
                        constraints: BoxConstraints.tight(device.size),
                        child: Builder(
                          builder: (context) {
                            return buildApp(
                              brightness: device.brightness,
                              child: const CustomDialog(
                                title: 'Success!',
                                content:
                                    'Your operation has been completed successfully.',
                                type: DialogType.success,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    .toList(),
          ),
    );

    goldenTest(
      'renders correctly with custom configurations',
      fileName: 'custom_dialog_custom',
      builder:
          () => GoldenTestGroup(
            columns: 2,
            children:
                Device.all
                    .map(
                      (device) => GoldenTestScenario(
                        name: '${device.name} - Custom',
                        constraints: BoxConstraints.tight(device.size),
                        child: Builder(
                          builder: (context) {
                            return buildApp(
                              brightness: device.brightness,
                              child: CustomDialog(
                                title: 'Settings',
                                content:
                                    'Would you like to enable notifications?',
                                type: DialogType.custom,
                                icon: Icons.settings,
                                backgroundColor: Colors.grey[50],
                                actions: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Enable'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    .toList(),
          ),
    );
  });
}
