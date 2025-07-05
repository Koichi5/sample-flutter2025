# Golden Test 自動化フロー

このドキュメントは、Flutter プロジェクトで Golden Test を自動化するためのフローについて説明します。

## 概要

このフローは、指定された Widget に対して自動的に Golden Test を生成・実行するシステムです。
Git の差分検知は @Git で行い、Golden Test のシナリオ作成と実行に特化しています。

## 主な機能

1. **Golden Test 自動生成**: [weather_view_golden_test.dart](test/weather/widgets/weather_view_golden_test.dart) をベースとしたテンプレートで Golden Test を自動生成
2. **テスト実行**: 生成されたテストを実行し、Golden Image を作成・更新
3. **汎用性**: Cursor のエージェントモードや他の AI エージェントでも使用可能

## ディレクトリ構成

```
docs/
└── GOLDEN_TEST_AUTOMATION.md  # このドキュメント
tools/
└── golden_test/
    ├── simple_golden_test.dart # Golden Test生成・実行スクリプト
    └── golden_test.sh         # 実行用シェルスクリプト
```

## 基本的な使用方法

### 1. Golden Test の作成

```bash
dart tools/golden_test/simple_golden_test.dart create WeatherView lib/weather/widgets/weather_view.dart
```

### 2. Golden Test の実行

```bash
# 全てのGolden Testを実行
dart tools/golden_test/simple_golden_test.dart run
# または
./tools/golden_test/golden_test.sh run

# 特定のテストファイルのみ実行
dart tools/golden_test/simple_golden_test.dart run test/weather/widgets/weather_view_golden_test.dart
# または
./tools/golden_test/golden_test.sh run test/weather/widgets/weather_view_golden_test.dart
```

## AI エージェントでの使用方法

### Cursor エージェントモード

**Golden Test がない場合：**

```
WeatherViewのGolden Testを作成して実行して
```

**Golden Test がある場合：**

```
Golden Testを実行してUIの差分を確認して
```

### 他の AI エージェント

**Golden Test がない場合：**

```
WeatherViewのGolden Testを作成してください。
以下のコマンドを実行してください：
dart tools/golden_test/simple_golden_test.dart create WeatherView lib/weather/widgets/weather_view.dart
dart tools/golden_test/simple_golden_test.dart run
```

**Golden Test がある場合：**

```
Golden Testを実行してUIの差分を確認してください。
以下のコマンドを実行してください：
dart tools/golden_test/simple_golden_test.dart run
```

## テンプレートの詳細

### ベースとなるテンプレート

この自動化フローは、[weather_view_golden_test.dart](test/weather/widgets/weather_view_golden_test.dart) をベースとしています。

生成されるテストファイルの構成：

- **Alchemist** を使用したマルチデバイス・マルチテーマ対応
- **Material Design 3** のテーマ設定
- **Light/Dark テーマ** の両方に対応
- **複数デバイスサイズ** (Phone, Tablet, Web) に対応

### 対応するデバイス・テーマ

`test/support/alchemist/device.dart` で定義された以下の組み合わせでテストを実行：

- **Phone**: Portrait/Landscape (Light/Dark)
- **Tablet**: Portrait/Landscape (Light/Dark)
- **Web**: Desktop サイズ (Light/Dark)

## 実際の使用例

### 1. 新しい Widget に Golden Test を追加

```bash
# 1. Golden Testを作成
dart tools/golden_test/simple_golden_test.dart create WeatherIcon lib/weather/widgets/weather_icon.dart

# 2. テストを実行してGolden Imageを生成
dart tools/golden_test/simple_golden_test.dart run test/weather/widgets/weather_icon_golden_test.dart
```

### 2. 既存の Widget の UI を変更した場合

```bash
# Golden Testを実行してUIの差分を確認・更新
dart tools/golden_test/simple_golden_test.dart run test/weather/widgets/weather_view_golden_test.dart
```

## 生成されるテストファイルの例

`WeatherView` の場合：

```dart
import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter2025/weather/widgets/weather_view.dart';
import 'package:sample_flutter2025/weather/models/weather.dart';

import '../../support/alchemist/device.dart';

void main() {
  group('WeatherView Golden Tests', () {
    const mockWeather = Weather(
      currentWeather: CurrentWeather(
        temperature: 15.0,
        windSpeed: 10.0,
        weatherCode: 3, // Overcast
      ),
    );

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
        home: const WeatherView(weather: mockWeather),
      );
    }

    goldenTest(
      'renders correctly on various devices and themes',
      fileName: 'weather_view',
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
```

## カスタマイズ

### 新しい Widget タイプの対応

`tools/golden_test/simple_golden_test.dart` の `_expandTemplate` メソッドで、新しい Widget タイプに対応するモックデータを追加できます：

```dart
// 例：ButtonWidgetの場合
if (widgetName.toLowerCase().contains('button')) {
  mockData = 'const buttonText = "Sample Button";';
  widgetConstructor = 'ButtonWidget(text: buttonText)';
}
```

### デバイス設定の変更

`test/support/alchemist/device.dart` でテスト対象のデバイスやテーマを変更できます。

## トラブルシューティング

### Golden Test が失敗する場合

1. **依存関係の問題**

   ```bash
   flutter pub get
   ```

2. **Golden Image の強制更新**

   ```bash
   flutter test --update-goldens
   ```

3. **特定のテストファイルのみ実行**
   ```bash
   dart tools/golden_test/simple_golden_test.dart run test/weather/widgets/weather_view_golden_test.dart
   ```

### スクリプトが実行できない場合

```bash
# Dart SDKの確認
dart --version

# スクリプトの実行確認
dart tools/golden_test/simple_golden_test.dart
```

## 注意事項

- Golden Test は UI の見た目をピクセルレベルで比較するため、フォントやレンダリングの違いに敏感です
- 既存のテストファイルがある場合は上書きされません
- `weather` が含まれる Widget は自動的に Weather モデルのモックデータが使用されます

---

このドキュメントは、Golden Test 自動化フローの基本的な使用方法を説明しています。プロジェクトの要件に応じて、適宜カスタマイズしてご使用ください。
