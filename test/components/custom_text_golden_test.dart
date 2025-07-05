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
              text: 'Sample Text',
              variant: TextVariant.body,
              color: Colors.blue,
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              isSelectable: false,
              onTap: () { print("onTap tapped"); },
            ),
          ),
        ),
      );
    }

    goldenTest(
      'renders correctly on various devices and themes',
      fileName: 'custom_text',
      builder: () => GoldenTestGroup(
        columns: 2,
        children: Device.all
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
