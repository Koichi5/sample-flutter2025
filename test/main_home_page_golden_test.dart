import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_flutter2025/main.dart';

import 'support/alchemist/device.dart';

void main() {
  group('HomePage Golden Tests', () {
    Widget buildApp({required Brightness brightness}) {
      return ProviderScope(
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: brightness,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        ),
      );
    }

    goldenTest(
      'renders correctly with custom dialog demo card',
      fileName: 'home_page_with_dialog_demo',
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
