import 'dart:io';
import 'widget_analyzer.dart';

class EnhancedGoldenTestGenerator {
  static Future<void> main(List<String> args) async {
    if (args.length < 3) {
      print(
        'Usage: dart enhanced_golden_test.dart <command> <widget_name> <widget_path>',
      );
      print('Commands:');
      print('  create    - Create golden test file');
      print('  run       - Run golden test');
      print('  both      - Create and run golden test');
      print('');
      print('Example:');
      print(
        '  dart enhanced_golden_test.dart create CustomButton lib/components/custom_button.dart',
      );
      return;
    }

    final command = args[0];
    final widgetName = args[1];
    final widgetPath = args[2];

    try {
      switch (command) {
        case 'create':
          await _createGoldenTest(widgetName, widgetPath);
          break;
        case 'run':
          await _runGoldenTest(widgetName, widgetPath);
          break;
        case 'both':
          await _createGoldenTest(widgetName, widgetPath);
          await _runGoldenTest(widgetName, widgetPath);
          break;
        default:
          print('Unknown command: $command');
      }
    } catch (e) {
      print('Error: $e');
      exit(1);
    }
  }

  static Future<void> _createGoldenTest(
    String widgetName,
    String widgetPath,
  ) async {
    print('🔍 Analyzing widget: $widgetName');

    // Widget解析
    final parameters = await WidgetAnalyzer.analyzeWidget(widgetPath);
    final file = File(widgetPath);
    final content = await file.readAsString();
    final fieldTypes = await WidgetAnalyzer.getFieldTypes(content, parameters);

    print('📋 Found ${parameters.length} parameters:');
    for (final param in parameters) {
      final type = fieldTypes[param.name] ?? 'dynamic';
      print(
        '  - ${param.name}: $type ${param.isRequired ? '(required)' : '(optional)'}',
      );
    }

    // テストファイル生成
    final testContent = await _generateTestContent(
      widgetName,
      widgetPath,
      parameters,
      fieldTypes,
    );
    final testPath = _getTestPath(widgetPath);

    // ディレクトリ作成
    final testDir = Directory(testPath.substring(0, testPath.lastIndexOf('/')));
    if (!await testDir.exists()) {
      await testDir.create(recursive: true);
    }

    // ファイル書き込み
    final testFile = File(testPath);
    await testFile.writeAsString(testContent);

    print('✅ Created golden test: $testPath');
  }

  static Future<void> _runGoldenTest(
    String widgetName,
    String widgetPath,
  ) async {
    final testPath = _getTestPath(widgetPath);
    final testFile = File(testPath);

    if (!await testFile.exists()) {
      print('❌ Test file not found: $testPath');
      print('💡 Run with "create" command first to generate the test file');
      return;
    }

    print('🚀 Running golden test for $widgetName...');
    final result = await Process.run('flutter', ['test', testPath]);

    if (result.exitCode == 0) {
      print('✅ Golden test passed!');
    } else {
      print('❌ Golden test failed:');
      print(result.stdout);
      print(result.stderr);
    }
  }

  static String _getTestPath(String widgetPath) {
    // lib/components/custom_button.dart -> test/components/custom_button_golden_test.dart
    final relativePath = widgetPath.replaceFirst('lib/', '');
    final testName = relativePath.replaceAll('.dart', '_golden_test.dart');
    return 'test/$testName';
  }

  static int _calculateRelativePathDepth(String widgetPath) {
    // lib/components/custom_button.dart -> test/components/ (depth: 1)
    final relativePath = widgetPath.replaceFirst('lib/', '');
    final segments = relativePath.split('/');
    return segments.length - 1; // Exclude the file name
  }

  static Future<String> _generateTestContent(
    String widgetName,
    String widgetPath,
    List<WidgetParameterInfo> parameters,
    Map<String, String> fieldTypes,
  ) async {
    final depth = _calculateRelativePathDepth(widgetPath);
    final backPath = '../' * depth;
    final packagePath = widgetPath.replaceFirst('lib/', '');

    // モックデータとコンストラクタ生成
    final mockData = _generateMockData(parameters, fieldTypes);
    final constructorArgs = _generateConstructorArgs(parameters, fieldTypes);

    return '''
import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter2025/$packagePath';

import '${backPath}support/alchemist/device.dart';

void main() {
  group('$widgetName Golden Tests', () {
${mockData.isNotEmpty ? '\n$mockData\n' : ''}
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
            child: $widgetName(
$constructorArgs,
            ),
          ),
        ),
      );
    }

    goldenTest(
      'renders correctly on various devices and themes',
      fileName: '${widgetName.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), '_').toLowerCase()}',
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
  }

  static String _generateMockData(
    List<WidgetParameterInfo> parameters,
    Map<String, String> fieldTypes,
  ) {
    final mockLines = <String>[];

    for (final param in parameters) {
      final type = fieldTypes[param.name] ?? 'dynamic';
      final mockValue = _generateMockValueForType(type, param.name);

      if (mockValue != null && mockValue.startsWith('const ')) {
        mockLines.add('    $mockValue');
      }
    }

    return mockLines.join('\n');
  }

  static String _generateConstructorArgs(
    List<WidgetParameterInfo> parameters,
    Map<String, String> fieldTypes,
  ) {
    final constructorArgs = <String>[];

    for (final param in parameters) {
      final type = fieldTypes[param.name] ?? 'dynamic';
      final mockValue = _generateMockValueForType(type, param.name);

      if (mockValue != null) {
        if (mockValue.startsWith('const ') || mockValue.startsWith('final ')) {
          // Extract variable name from declaration
          final parts = mockValue.split(' ');
          final varName = parts.length > 1 ? parts[1].split(' ')[0] : mockValue;
          constructorArgs.add('              ${param.name}: $varName');
        } else {
          constructorArgs.add('              ${param.name}: $mockValue');
        }
      }
    }

    return constructorArgs.join(',\n');
  }

  static String? _generateMockValueForType(String type, String paramName) {
    // Remove nullable indicator for type checking
    final baseType = type.replaceAll('?', '');

    switch (baseType) {
      case 'String':
        if (paramName == 'text') {
          return "'Sample Text'";
        } else if (paramName == 'title') {
          return "'Sample Title'";
        } else {
          return "'Mock $paramName'";
        }
      case 'VoidCallback':
        return '() { print("$paramName tapped"); }';
      case 'IconData':
        return 'Icons.star';
      case 'Color':
        return 'Colors.blue';
      case 'bool':
        if (paramName == 'isLoading' || paramName == 'isSelectable') {
          return 'false';
        } else {
          return 'true';
        }
      case 'int':
        return '1';
      case 'double':
        return paramName == 'fontSize' ? '16.0' : '1.0';
      case 'ButtonSize':
        return 'ButtonSize.medium';
      case 'TextVariant':
        return 'TextVariant.body';
      case 'FontWeight':
        return 'FontWeight.normal';
      case 'TextAlign':
        return 'TextAlign.left';
      case 'TextOverflow':
        return 'TextOverflow.ellipsis';
      default:
        if (type.endsWith('?')) {
          return 'null';
        }
        // カスタム型の場合、AIエージェントに相談するコメントを追加
        return '/* TODO: Please provide mock data for type: $type */';
    }
  }
}

// エントリーポイント
void main(List<String> args) async {
  await EnhancedGoldenTestGenerator.main(args);
}
