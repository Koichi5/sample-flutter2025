import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter2025/components/custom_button.dart';

import '../../support/alchemist/device.dart';

void main() {
  group('CustomButton Golden Tests', () {
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
        home: Scaffold(
          body: Center(
            child: CustomButton(
              text: 'Sample Button',
              onPressed: () {
                print("onPressed tapped");
              },
              icon: Icons.star,
              backgroundColor: Colors.blue,
              textColor: Colors.blue,
              size: ButtonSize.medium,
              isEnabled: true,
              isLoading: false,
            ),
          ),
        ),
      );
    }

    goldenTest(
      'renders correctly on various devices and themes',
      fileName: 'custom_button',
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
