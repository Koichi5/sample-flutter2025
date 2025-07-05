import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter2025/components/custom_dialog.dart';

import '../../support/alchemist/device.dart';

void main() {
  group('CustomDialogDemo Golden Tests', () {
    Widget buildApp({required Brightness brightness}) {
      return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: brightness,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const CustomDialogDemo(),
      );
    }

    goldenTest(
      'renders correctly on various devices and themes',
      fileName: 'custom_dialog_demo',
      builder:
          () => GoldenTestGroup(
            columns: 2,
            children:
                Device.all
                    .map(
                      (device) => GoldenTestScenario(
                        name: device.name,
                        constraints: BoxConstraints.tight(device.size),
                        child: Builder(
                          builder: (context) {
                            return buildApp(brightness: device.brightness);
                          },
                        ),
                      ),
                    )
                    .toList(),
          ),
    );
  });
}
