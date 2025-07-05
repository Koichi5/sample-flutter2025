import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_flutter2025/pages/home_page.dart';

import '../../support/alchemist/device.dart';

void main() {
  group('HomePage Golden Tests', () {
    Widget buildApp({required Brightness brightness, Color? seedColor}) {
      return ProviderScope(
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor ?? Colors.blue,
              brightness: brightness,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        ),
      );
    }

    goldenTest(
      'renders correctly with all demo cards',
      fileName: 'home_page_all_demos',
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

    goldenTest(
      'renders correctly with different theme colors',
      fileName: 'home_page_theme_variations',
      builder:
          () => GoldenTestGroup(
            columns: 3,
            children: [
              // Blue theme (default)
              GoldenTestScenario(
                name: 'Blue Theme Light',
                constraints: BoxConstraints.tight(Device.phonePortrait.size),
                child: buildApp(
                  brightness: Brightness.light,
                  seedColor: Colors.blue,
                ),
              ),
              // Green theme
              GoldenTestScenario(
                name: 'Green Theme Light',
                constraints: BoxConstraints.tight(Device.phonePortrait.size),
                child: buildApp(
                  brightness: Brightness.light,
                  seedColor: Colors.green,
                ),
              ),
              // Purple theme
              GoldenTestScenario(
                name: 'Purple Theme Light',
                constraints: BoxConstraints.tight(Device.phonePortrait.size),
                child: buildApp(
                  brightness: Brightness.light,
                  seedColor: Colors.purple,
                ),
              ),
              // Dark variations
              GoldenTestScenario(
                name: 'Blue Theme Dark',
                constraints: BoxConstraints.tight(Device.phonePortrait.size),
                child: buildApp(
                  brightness: Brightness.dark,
                  seedColor: Colors.blue,
                ),
              ),
              GoldenTestScenario(
                name: 'Green Theme Dark',
                constraints: BoxConstraints.tight(Device.phonePortrait.size),
                child: buildApp(
                  brightness: Brightness.dark,
                  seedColor: Colors.green,
                ),
              ),
              GoldenTestScenario(
                name: 'Purple Theme Dark',
                constraints: BoxConstraints.tight(Device.phonePortrait.size),
                child: buildApp(
                  brightness: Brightness.dark,
                  seedColor: Colors.purple,
                ),
              ),
            ],
          ),
    );

    goldenTest(
      'renders correctly on tablet and web layouts',
      fileName: 'home_page_large_screens',
      builder:
          () => GoldenTestGroup(
            columns: 2,
            children: [
              // Tablet layout
              GoldenTestScenario(
                name: 'Tablet Light',
                constraints: BoxConstraints.tight(Device.tabletPortrait.size),
                child: buildApp(brightness: Brightness.light),
              ),
              GoldenTestScenario(
                name: 'Tablet Dark',
                constraints: BoxConstraints.tight(Device.tabletPortrait.size),
                child: buildApp(brightness: Brightness.dark),
              ),
              // Web layout
              GoldenTestScenario(
                name: 'Web Light',
                constraints: BoxConstraints.tight(Device.web.size),
                child: buildApp(brightness: Brightness.light),
              ),
              GoldenTestScenario(
                name: 'Web Dark',
                constraints: BoxConstraints.tight(Device.web.size),
                child: buildApp(brightness: Brightness.dark),
              ),
            ],
          ),
    );
  });
}
