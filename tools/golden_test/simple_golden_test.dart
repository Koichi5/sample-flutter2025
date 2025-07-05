import 'dart:io';

class SimpleGoldenTest {
  static const String _template = '''import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter2025/{{WIDGET_PATH}}';
{{ADDITIONAL_IMPORTS}}

import '../../support/alchemist/device.dart';

void main() {
  group('{{WIDGET_NAME}} Golden Tests', () {
{{MOCK_DATA}}

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
        home: {{WIDGET_CONSTRUCTOR}},
      );
    }

    goldenTest(
      'renders correctly on various devices and themes',
      fileName: '{{FILE_NAME}}',
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
''';

  static Future<void> createGoldenTest(
    String widgetName,
    String widgetPath,
  ) async {
    final testDir = Directory('test/${_getTestDirectory(widgetPath)}');
    await testDir.create(recursive: true);

    final testFileName = '${_toSnakeCase(widgetName)}_golden_test.dart';
    final testFile = File('${testDir.path}/$testFileName');

    // 既存のテストファイルが存在する場合は確認
    if (await testFile.exists()) {
      print('✓ Golden test already exists: ${testFile.path}');
      return;
    }

    // テンプレートを展開
    final testContent = _expandTemplate(widgetName, widgetPath);
    await testFile.writeAsString(testContent);

    print('✓ Created golden test: ${testFile.path}');
  }

  static String _expandTemplate(String widgetName, String widgetPath) {
    // widget_path.dart → widget/path.dart
    final cleanPath = widgetPath.replaceFirst('lib/', '');
    final fileName = _toSnakeCase(widgetName);

    // Widget別のモックデータとコンストラクタを設定
    String mockData = '';
    String additionalImports = '';
    String widgetConstructor = 'const $widgetName()';

    if (widgetName == 'WeatherView') {
      mockData = '''
    const mockWeather = Weather(
      currentWeather: CurrentWeather(
        temperature: 15.0,
        windSpeed: 10.0,
        weatherCode: 3, // Overcast
      ),
    );''';
      additionalImports =
          '\nimport \'package:sample_flutter2025/weather/models/weather.dart\';';
      widgetConstructor = 'const $widgetName(weather: mockWeather)';
    } else if (widgetName == 'WeatherIcon') {
      mockData = '''
    const mockWeatherCode = 3; // Overcast''';
      widgetConstructor = 'const $widgetName(weatherCode: mockWeatherCode)';
    } else if (widgetName.toLowerCase().contains('weather')) {
      // その他のweather関連Widget
      mockData = '''
    const mockWeather = Weather(
      currentWeather: CurrentWeather(
        temperature: 15.0,
        windSpeed: 10.0,
        weatherCode: 3, // Overcast
      ),
    );''';
      additionalImports =
          '\nimport \'package:sample_flutter2025/weather/models/weather.dart\';';
      widgetConstructor = 'const $widgetName(weather: mockWeather)';
    }

    return _template
        .replaceAll('{{WIDGET_NAME}}', widgetName)
        .replaceAll('{{WIDGET_PATH}}', cleanPath)
        .replaceAll('{{ADDITIONAL_IMPORTS}}', additionalImports)
        .replaceAll('{{MOCK_DATA}}', mockData)
        .replaceAll('{{WIDGET_CONSTRUCTOR}}', widgetConstructor)
        .replaceAll('{{FILE_NAME}}', fileName);
  }

  static Future<void> runGoldenTests([String? specificTest]) async {
    print('🧪 Running golden tests...');

    final args = ['test', '--update-goldens'];
    if (specificTest != null) {
      args.add(specificTest);
    }

    final result = await Process.run('flutter', args);

    if (result.exitCode == 0) {
      print('✅ Golden tests completed successfully!');
      print(result.stdout);
    } else {
      print('❌ Golden tests failed:');
      print(result.stderr);
    }
  }

  static String _getTestDirectory(String widgetPath) {
    final parts = widgetPath.split('/');
    if (parts.length > 1 && parts[0] == 'lib') {
      return parts.sublist(1, parts.length - 1).join('/');
    }
    return 'widgets';
  }

  static String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)}_${match.group(2)?.toLowerCase()}',
        )
        .toLowerCase();
  }
}

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart simple_golden_test.dart <command> [options]');
    print('Commands:');
    print('  create <WidgetName> <widget_path>  - Create golden test');
    print('  run [test_file]                    - Run golden tests');
    print('');
    print('Examples:');
    print(
      '  dart simple_golden_test.dart create WeatherView lib/weather/widgets/weather_view.dart',
    );
    print('  dart simple_golden_test.dart run');
    print(
      '  dart simple_golden_test.dart run test/weather/widgets/weather_view_golden_test.dart',
    );
    return;
  }

  final command = args[0];

  switch (command) {
    case 'create':
      if (args.length < 3) {
        print('Error: create command requires widget name and path');
        return;
      }
      await SimpleGoldenTest.createGoldenTest(args[1], args[2]);
      break;

    case 'run':
      final testFile = args.length > 1 ? args[1] : null;
      await SimpleGoldenTest.runGoldenTests(testFile);
      break;

    default:
      print('Unknown command: $command');
  }
}
