import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter2025/components/custom_text.dart';

import '../support/alchemist/device.dart';

void main() {
  group('CustomText Golden Tests', () {
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
            child: CustomText(
              // AI Generated Mock Data based on widget analysis
              text:
                  'Breaking News: Flutter 4.0 Released', // Realistic article title
              variant: TextVariant.title, // Appropriate for news headline
              color: Colors.deepOrange, // Eye-catching color for headlines
              fontSize: 20.0, // Readable title size
              fontWeight: FontWeight.bold, // Strong visual hierarchy
              textAlign: TextAlign.center, // Centered for visual balance
              maxLines: 2, // Allow for line breaks
              overflow: TextOverflow.ellipsis, // Graceful text truncation
              isSelectable: false, // Keep focus on visual testing
              onTap: () {
                // Interactive feedback
                print('News headline tapped');
              },
            ),
          ),
        ),
      );
    }

    goldenTest(
      'renders correctly on various devices and themes',
      fileName: 'custom_text_ai',
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
- Widget Category: text
- Use Cases: interactive_element, text_display, customizable_appearance

Mock Data Choices:
1. text: "Breaking News: Flutter 4.0 Released" - Realistic news headline, showcases multi-word text
2. variant: TextVariant.title - Appropriate for headline styling
3. color: Colors.deepOrange - Eye-catching color suitable for news/important information
4. fontSize: 20.0 - Readable size for headlines, larger than body text
5. fontWeight: FontWeight.bold - Strong visual hierarchy for headlines
6. textAlign: TextAlign.center - Centered alignment for visual balance
7. maxLines: 2 - Allows for line breaks while maintaining readability
8. overflow: TextOverflow.ellipsis - Graceful handling of long text
9. isSelectable: false - Focus on visual testing, not text selection
10. onTap: Print callback - Shows interactive capability

This mock data demonstrates the widget's text styling capabilities while being visually
appealing and realistic for Golden Test image generation.
*/
