import 'package:flutter/material.dart';

class Device {
  const Device({
    required this.size,
    required this.name,
    this.devicePixelRatio = 1.0,
    this.textScaleFactor = 1.0,
    this.brightness = Brightness.light,
    this.safeArea = EdgeInsets.zero,
  });

  static const Device phoneLandscape =
      Device(name: 'phone_landscape', size: Size(667, 375));

  static const Device phonePortrait =
      Device(name: 'phone_portrait', size: Size(375, 667));

  static const Device tabletLandscape =
      Device(name: 'tablet_landscape', size: Size(1366, 1024));

  static const Device tabletPortrait =
      Device(name: 'tablet_portrait', size: Size(1024, 1366));

  static const Device web = Device(name: 'web', size: Size(1920, 1080));

  static List<Device> all = [
    phonePortrait,
    phonePortrait.dark(),
    phoneLandscape,
    phoneLandscape.dark(),
    tabletPortrait,
    tabletPortrait.dark(),
    tabletLandscape,
    tabletLandscape.dark(),
    web,
    web.dark(),
  ];

  final String name;

  final Size size;

  final double devicePixelRatio;

  final double textScaleFactor;

  final Brightness brightness;

  final EdgeInsets safeArea;

  Device copyWith({
    Size? size,
    double? devicePixelRatio,
    String? name,
    double? textScale,
    Brightness? brightness,
    EdgeInsets? safeArea,
  }) {
    return Device(
      size: size ?? this.size,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      name: name ?? this.name,
      textScaleFactor: textScale ?? textScaleFactor,
      brightness: brightness ?? this.brightness,
      safeArea: safeArea ?? this.safeArea,
    );
  }

  Device dark() {
    return Device(
      size: size,
      devicePixelRatio: devicePixelRatio,
      textScaleFactor: textScaleFactor,
      brightness: Brightness.dark,
      safeArea: safeArea,
      name: '${name}_dark',
    );
  }

  @override
  String toString() {
    return 'Device: $name, '
        '${size.width}x${size.height} @ $devicePixelRatio, '
        'text: $textScaleFactor, $brightness, safe: $safeArea';
  }
}
