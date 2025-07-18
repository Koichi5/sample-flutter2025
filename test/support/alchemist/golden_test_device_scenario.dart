import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

import 'device.dart';
export 'device.dart';

class GoldenTestDeviceScenario extends StatelessWidget {
  const GoldenTestDeviceScenario({
    super.key,
    required this.name,
    required this.device,
    required this.builder,
  });

  final String name;
  final Device device;
  final ValueGetter<Widget> builder;

  @override
  Widget build(BuildContext context) {
    return GoldenTestScenario(
      name: '$name (${device.name})',
      child: ClipRect(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            size: device.size,
            padding: device.safeArea,
            platformBrightness: device.brightness,
            devicePixelRatio: device.devicePixelRatio,
            textScaler: TextScaler.linear(device.textScaleFactor),
          ),
          child: SizedBox(
            height: device.size.height,
            width: device.size.width,
            child: builder(),
          ),
        ),
      ),
    );
  }
}