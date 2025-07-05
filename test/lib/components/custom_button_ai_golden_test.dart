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
              // AI Generated Mock Data based on widget analysis
              text: 'Save Document', // Realistic button text
              onPressed: () {
                // Interactive callback
                print('Save Document button pressed');
              },
              icon: Icons.save, // Contextual icon
              backgroundColor:
                  Colors.green, // Appropriate color for save action
              textColor: Colors.white, // High contrast text
              size: ButtonSize.medium, // Standard size
              isEnabled: true, // Active state
              isLoading: false, // Avoid infinite animation
            ),
          ),
        ),
      );
    }

    goldenTest(
      'renders correctly on various devices and themes',
      fileName: 'custom_button_ai',
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

/*
AI Generated Mock Data Rationale:
- Widget Category: button
- Use Cases: interactive_element, text_display, icon_display, customizable_appearance, state_management

Mock Data Choices:
1. text: "Save Document" - More realistic than "Sample Text", shows actual button purpose
2. onPressed: Print callback - Safe, testable, shows interactivity
3. icon: Icons.save - Contextual to the button text, commonly used
4. backgroundColor: Colors.green - Semantic color for save actions
5. textColor: Colors.white - High contrast for accessibility
6. size: ButtonSize.medium - Standard size for most use cases
7. isEnabled: true - Show active state functionality
8. isLoading: false - Prevents infinite animation in tests

This mock data showcases the widget's full functionality while being suitable for Golden Tests.
*/
