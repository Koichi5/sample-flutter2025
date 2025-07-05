import 'dart:io';
import 'dart:convert';
import 'widget_analyzer.dart';

class AiAssistedGoldenTestGenerator {
  static Future<void> main(List<String> args) async {
    if (args.length < 3) {
      print(
        'Usage: dart ai_assisted_golden_test.dart <command> <widget_name> <widget_path>',
      );
      print('Commands:');
      print('  create    - Create golden test file');
      print('  run       - Run golden test');
      print('  both      - Create and run golden test');
      print('');
      print('Example:');
      print(
        '  dart ai_assisted_golden_test.dart create CustomButton lib/components/custom_button.dart',
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

    // AIエージェント向けの分析結果を生成
    final analysisResult = _generateAnalysisResult(
      widgetName,
      widgetPath,
      parameters,
      fieldTypes,
    );

    // AIエージェントへの依頼メッセージを生成
    final aiRequest = _generateAiRequest(analysisResult);

    // AIエージェントに依頼ファイルを作成
    final requestPath = 'tools/golden_test/ai_mock_request.json';
    await _writeAiRequest(requestPath, aiRequest);

    print('');
    print('🤖 AI Assistant Required!');
    print('');
    print('📄 Widget analysis saved to: $requestPath');
    print('');
    print('🔥 Please ask your AI Assistant to:');
    print('');
    print('1. Read the analysis file: $requestPath');
    print('2. Generate appropriate mock data for each parameter');
    print('3. Create the Golden Test file using the template');
    print('');
    print('💡 Sample AI prompt:');
    print(
      '   "この${requestPath}ファイルを読んで、適切なモックデータを生成し、Golden Testファイルを作成してください"',
    );
    print('');
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
    final relativePath = widgetPath.replaceFirst('lib/', '');
    final testName = relativePath.replaceAll('.dart', '_golden_test.dart');
    return 'test/$testName';
  }

  static Map<String, dynamic> _generateAnalysisResult(
    String widgetName,
    String widgetPath,
    List<WidgetParameterInfo> parameters,
    Map<String, String> fieldTypes,
  ) {
    final depth = _calculateRelativePathDepth(widgetPath);
    final backPath = '../' * depth;
    final packagePath = widgetPath.replaceFirst('lib/', '');

    return {
      'widget_name': widgetName,
      'widget_path': widgetPath,
      'package_path': packagePath,
      'test_path': _getTestPath(widgetPath),
      'relative_path_depth': depth,
      'back_path': backPath,
      'parameters':
          parameters
              .map(
                (p) => {
                  'name': p.name,
                  'type': fieldTypes[p.name] ?? 'dynamic',
                  'is_required': p.isRequired,
                  'default_value': p.defaultValue,
                },
              )
              .toList(),
      'widget_category': _guessWidgetCategory(widgetName),
      'common_use_cases': _generateCommonUseCases(widgetName, parameters),
    };
  }

  static String _guessWidgetCategory(String widgetName) {
    final name = widgetName.toLowerCase();
    if (name.contains('button')) return 'button';
    if (name.contains('text')) return 'text';
    if (name.contains('input') || name.contains('field')) return 'input';
    if (name.contains('card')) return 'card';
    if (name.contains('dialog') || name.contains('modal')) return 'dialog';
    if (name.contains('list') || name.contains('item')) return 'list';
    if (name.contains('image') || name.contains('avatar')) return 'image';
    return 'general';
  }

  static List<String> _generateCommonUseCases(
    String widgetName,
    List<WidgetParameterInfo> parameters,
  ) {
    final useCases = <String>[];

    // パラメータから使用ケースを推測
    if (parameters.any((p) => p.name == 'onPressed' || p.name == 'onTap')) {
      useCases.add('interactive_element');
    }
    if (parameters.any((p) => p.name == 'text' || p.name == 'title')) {
      useCases.add('text_display');
    }
    if (parameters.any((p) => p.name == 'icon' || p.name == 'iconData')) {
      useCases.add('icon_display');
    }
    if (parameters.any(
      (p) => p.name == 'color' || p.name == 'backgroundColor',
    )) {
      useCases.add('customizable_appearance');
    }
    if (parameters.any((p) => p.name == 'isLoading' || p.name == 'isEnabled')) {
      useCases.add('state_management');
    }

    return useCases;
  }

  static Map<String, dynamic> _generateAiRequest(
    Map<String, dynamic> analysisResult,
  ) {
    return {
      'request_type': 'golden_test_mock_generation',
      'timestamp': DateTime.now().toIso8601String(),
      'analysis_result': analysisResult,
      'instructions': {
        'goal': 'Generate appropriate mock data for Flutter Widget Golden Test',
        'requirements': [
          'Create realistic mock data for each parameter',
          'Consider parameter names and types for context',
          'Avoid infinite animations (e.g., isLoading: false)',
          'Use appropriate default values for optional parameters',
          'Generate readable test data that showcases the widget properly',
          'Handle nullable types appropriately (use null or meaningful values)',
          'Consider widget category and common use cases',
        ],
        'output_format':
            'Generate a complete Golden Test file with proper mock data',
        'template_structure': _generateTemplateStructure(),
        'mock_data_examples': _generateMockDataExamples(),
      },
    };
  }

  static Map<String, dynamic> _generateTemplateStructure() {
    return {
      'imports': [
        "import 'package:alchemist/alchemist.dart';",
        "import 'package:flutter/material.dart';",
        "import 'package:flutter_test/flutter_test.dart';",
        "import 'package:sample_flutter2025/{{package_path}}';",
        "import '{{back_path}}support/alchemist/device.dart';",
      ],
      'test_structure': {
        'group_name': '{{widget_name}} Golden Tests',
        'test_name': 'renders correctly on various devices and themes',
        'file_name': '{{widget_name_snake_case}}',
        'widget_wrapper': 'Scaffold with Center child',
        'theme': 'Material Design 3 with purple seed color',
      },
    };
  }

  static Map<String, dynamic> _generateMockDataExamples() {
    return {
      'String': {
        'text': "'Sample Text'",
        'title': "'Sample Title'",
        'description': "'Sample Description'",
        'label': "'Sample Label'",
        'hint': "'Enter text here'",
        'default': "'Mock Value'",
      },
      'VoidCallback': "() { print('{{parameter_name}} tapped'); }",
      'bool': {
        'isLoading': 'false',
        'isEnabled': 'true',
        'isSelected': 'false',
        'isVisible': 'true',
        'default': 'true',
      },
      'Color': 'Colors.blue',
      'IconData': 'Icons.star',
      'double': {
        'fontSize': '16.0',
        'width': '100.0',
        'height': '50.0',
        'default': '1.0',
      },
      'int': {'maxLines': '2', 'itemCount': '5', 'default': '1'},
      'enum_examples': {
        'ButtonSize': 'ButtonSize.medium',
        'TextVariant': 'TextVariant.body',
        'TextAlign': 'TextAlign.center',
      },
    };
  }

  static Future<void> _writeAiRequest(
    String path,
    Map<String, dynamic> request,
  ) async {
    final file = File(path);
    final dir = file.parent;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    const encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(request));
  }

  static int _calculateRelativePathDepth(String widgetPath) {
    final relativePath = widgetPath.replaceFirst('lib/', '');
    final segments = relativePath.split('/');
    return segments.length - 1;
  }
}

// エントリーポイント
void main(List<String> args) async {
  await AiAssistedGoldenTestGenerator.main(args);
}
