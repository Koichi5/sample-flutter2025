import 'dart:io';

class WidgetParameterInfo {
  final String name;
  final String type;
  final bool isRequired;
  final String? defaultValue;

  const WidgetParameterInfo({
    required this.name,
    required this.type,
    required this.isRequired,
    this.defaultValue,
  });

  @override
  String toString() =>
      '$type $name${isRequired ? ' (required)' : ''}${defaultValue != null ? ' = $defaultValue' : ''}';
}

class WidgetAnalyzer {
  static Future<List<WidgetParameterInfo>> analyzeWidget(
    String widgetPath,
  ) async {
    final file = File(widgetPath);
    if (!await file.exists()) {
      throw Exception('Widget file not found: $widgetPath');
    }

    final content = await file.readAsString();
    final className = _extractClassName(widgetPath);

    if (className == null) {
      throw Exception('Could not extract class name from path: $widgetPath');
    }

    return _parseConstructorParameters(content, className);
  }

  static String? _extractClassName(String widgetPath) {
    final fileName = widgetPath.split('/').last;
    final baseName = fileName.replaceAll('.dart', '');

    // snake_case to PascalCase conversion
    final parts = baseName.split('_');
    return parts
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join('');
  }

  static List<WidgetParameterInfo> _parseConstructorParameters(
    String content,
    String className,
  ) {
    final parameters = <WidgetParameterInfo>[];

    // コンストラクタのパターンを検索
    final constructorPattern = RegExp(
      r'const\s+' + RegExp.escape(className) + r'\s*\(\s*\{([^}]*)\}\s*\)',
      dotAll: true,
    );

    final match = constructorPattern.firstMatch(content);
    if (match == null) {
      print('Warning: Could not find constructor for $className');
      return parameters;
    }

    final constructorBody = match.group(1) ?? '';
    final lines = constructorBody.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty ||
          trimmed.startsWith('//') ||
          trimmed == 'super.key,') {
        continue;
      }

      final param = _parseParameterLine(trimmed);
      if (param != null) {
        parameters.add(param);
      }
    }

    return parameters;
  }

  static WidgetParameterInfo? _parseParameterLine(String line) {
    // Remove trailing comma
    line = line.replaceAll(',', '').trim();

    // Check for required parameters
    final isRequired = line.startsWith('required ');
    if (isRequired) {
      line = line.replaceFirst('required ', '');
    }

    // Parse "this.paramName" pattern
    final thisPattern = RegExp(r'this\.(\w+)');
    final thisMatch = thisPattern.firstMatch(line);
    if (thisMatch != null) {
      final paramName = thisMatch.group(1)!;
      return WidgetParameterInfo(
        name: paramName,
        type: 'dynamic', // We'll infer this from field declarations
        isRequired: isRequired,
      );
    }

    // Parse default value assignments
    final defaultPattern = RegExp(r'this\.(\w+)\s*=\s*(.+)');
    final defaultMatch = defaultPattern.firstMatch(line);
    if (defaultMatch != null) {
      final paramName = defaultMatch.group(1)!;
      final defaultValue = defaultMatch.group(2)!;
      return WidgetParameterInfo(
        name: paramName,
        type: 'dynamic',
        isRequired: false,
        defaultValue: defaultValue,
      );
    }

    return null;
  }

  static Future<Map<String, String>> getFieldTypes(
    String content,
    List<WidgetParameterInfo> parameters,
  ) async {
    final fieldTypes = <String, String>{};

    for (final param in parameters) {
      // フィールド宣言から型を取得
      final fieldPattern = RegExp(
        r'final\s+(\S+)\??\s+' + RegExp.escape(param.name) + r'\s*;',
      );
      final match = fieldPattern.firstMatch(content);

      if (match != null) {
        String type = match.group(1)!;
        // Nullable型の処理
        if (content.contains('$type? ${param.name}')) {
          type += '?';
        }
        fieldTypes[param.name] = type;
      }
    }

    return fieldTypes;
  }

  static String generateMockData(
    List<WidgetParameterInfo> parameters,
    Map<String, String> fieldTypes,
  ) {
    final mockLines = <String>[];
    final constructorArgs = <String>[];

    for (final param in parameters) {
      final type = fieldTypes[param.name] ?? 'dynamic';
      final mockValue = _generateMockValueForType(type, param.name);

      if (mockValue != null) {
        if (mockValue.startsWith('const ') || mockValue.startsWith('final ')) {
          mockLines.add('    $mockValue');
          // Extract variable name from declaration
          final varName = mockValue.split(' ')[1].split(' ')[0];
          constructorArgs.add('${param.name}: $varName');
        } else {
          constructorArgs.add('${param.name}: $mockValue');
        }
      }
    }

    final mockData = mockLines.join('\n');
    final constructor = constructorArgs.join(', ');

    return {'mockData': mockData, 'constructor': constructor}.toString();
  }

  static String? _generateMockValueForType(String type, String paramName) {
    // Remove nullable indicator for type checking
    final baseType = type.replaceAll('?', '');

    switch (baseType) {
      case 'String':
        return paramName == 'text' ? "'Sample Text'" : "'Mock $paramName'";
      case 'VoidCallback':
        return '() {}';
      case 'IconData':
        return 'Icons.star';
      case 'Color':
        return 'Colors.blue';
      case 'bool':
        return 'true';
      case 'int':
        return '1';
      case 'double':
        return '1.0';
      case 'ButtonSize':
        return 'ButtonSize.medium';
      default:
        if (type.endsWith('?')) {
          return 'null';
        }
        return null;
    }
  }
}

// テスト用のメイン関数
void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart widget_analyzer.dart <widget_path>');
    return;
  }

  try {
    final parameters = await WidgetAnalyzer.analyzeWidget(args[0]);
    print('Found parameters:');
    for (final param in parameters) {
      print('  $param');
    }
  } catch (e) {
    print('Error: $e');
  }
}
