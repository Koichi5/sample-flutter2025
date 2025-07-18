# AI エージェント向け Golden Test 自動化ガイド

## 概要

このガイドは、Cursor、Claude Code、ChatGPT、Copilot などのコード生成 AI エージェントが、Flutter Golden Test の自動化を効率的に行うための指示書です。

## 🚀 基本的な使用方法

### 1. シンプルな Widget（必須パラメータなし）

```bash
# 作成のみ
dart tools/golden_test/enhanced_golden_test.dart create WeatherIcon lib/weather/widgets/weather_icon.dart

# 作成と実行
dart tools/golden_test/enhanced_golden_test.dart both WeatherIcon lib/weather/widgets/weather_icon.dart
```

### 2. 複雑な Widget（必須パラメータあり）

```bash
# 作成のみ
dart tools/golden_test/enhanced_golden_test.dart create CustomButton lib/components/custom_button.dart

# 作成と実行
dart tools/golden_test/enhanced_golden_test.dart both CustomButton lib/components/custom_button.dart
```

## 📁 テストディレクトリ構造

### 基本構造

```
test/
├── lib/                    # 実装コードと同じ構造
│   ├── main_test.dart      # lib/main.dart のテスト
│   ├── components/         # lib/components/ のテスト
│   │   ├── custom_button_golden_test.dart
│   │   └── goldens/
│   │       └── ci/
│   └── weather/            # lib/weather/ のテスト
│       └── widgets/
│           ├── weather_icon_golden_test.dart
│           └── goldens/
│               └── ci/
├── support/               # テスト共通ファイル
│   └── alchemist/
│       └── device.dart
└── flutter_test_config.dart
```

### 相対パス規則

- `test/lib/` 配下のテストから `test/support/` への相対パス: `../support/`
- `test/lib/components/` 配下のテストから `test/support/` への相対パス: `../../support/`
- `test/lib/weather/widgets/` 配下のテストから `test/support/` への相対パス: `../../../support/`

### 新しいテストファイル作成時のルール

**🎯 AI エージェントが従うべき原則**:

1. **ディレクトリ構造の維持**: 実装コード（`lib/`）と同じ構造を `test/lib/` 配下に作成
2. **ファイル配置例**:
   ```
   lib/main.dart                    → test/lib/main_golden_test.dart
   lib/components/button.dart       → test/lib/components/button_golden_test.dart
   lib/feature/widgets/item.dart    → test/lib/feature/widgets/item_golden_test.dart
   lib/pages/home/home_page.dart    → test/lib/pages/home/home_page_golden_test.dart
   ```
3. **必要なディレクトリの自動作成**: テストファイルを作成する前に、必要なディレクトリが存在しない場合は自動作成
4. **相対パスの自動計算**: ファイルの配置場所に応じて、適切な相対パスで device.dart をインポート

## 🤖 AI エージェントコマンド例

### ユーザーからの指示パターン

1. **"〜の Golden Test を作成して"**

   ```bash
   dart tools/golden_test/enhanced_golden_test.dart create [WidgetName] [widget_path]
   ```

2. **"〜の Golden Test を実行して"**

   ```bash
   dart tools/golden_test/enhanced_golden_test.dart run [WidgetName] [widget_path]
   ```

3. **"〜の Golden Test を作成して実行して"**
   ```bash
   dart tools/golden_test/enhanced_golden_test.dart both [WidgetName] [widget_path]
   ```

### 🚨 レンダリングオーバーフロー発生時の対応

**AI エージェントが従うべき手順：**

1. **即座にテスト実行を停止**
2. **以下のメッセージを開発者に報告**：

```
⚠️ レンダリングオーバーフローが発生しました

Widget: [WidgetName]
ファイル: [widget_path]
発生箇所: Golden Test実行中

【開発者による対応が必要です】
以下のいずれかの対応を選択してください：

1. Widget実装の修正（推奨）
   - 適切なScrollViewやレスポンシブデザインの実装
   - 小さなデバイスサイズでも適切に表示されるよう調整

2. 固定サイズテストの選択
   - 特定のデバイスサイズでのみテストを実行
   - 複数プラットフォーム対応を放棄

3. テストスキップ
   - 現在のWidgetはGolden Testに適さない判断

【AIエージェントは以下を行いません】
❌ Widget実装の自動修正
❌ テスト側でのScrollView追加
❌ 勝手な制約変更
```

3. **開発者の明示的な指示を待つ**
4. **指示があるまで当該 Widget のテストを実行しない**

## 📋 自動検出される情報

Enhanced Golden Test Generator は以下の情報を自動的に検出します：

- **必須パラメータ** (`required`)
- **オプションパラメータ**
- **パラメータの型** (`String`, `VoidCallback`, `IconData`, `Color`, `bool`, `int`, `double`, `enum`など)
- **デフォルト値**
- **Nullable 型** (`Type?`)

## 🔧 モックデータ生成ルール

### 自動生成される型

| 型             | 生成される値                                                | 例                                             |
| -------------- | ----------------------------------------------------------- | ---------------------------------------------- |
| `String`       | `'Sample Button'` (text の場合) または `'Mock [paramName]'` | `text: 'Sample Button'`                        |
| `VoidCallback` | `() { print("[paramName] tapped"); }`                       | `onPressed: () { print("onPressed tapped"); }` |
| `IconData`     | `Icons.star`                                                | `icon: Icons.star`                             |
| `Color`        | `Colors.blue`                                               | `backgroundColor: Colors.blue`                 |
| `bool`         | `true`                                                      | `isEnabled: true`                              |
| `int`          | `1`                                                         | `count: 1`                                     |
| `double`       | `1.0`                                                       | `width: 1.0`                                   |
| `ButtonSize`   | `ButtonSize.medium`                                         | `size: ButtonSize.medium`                      |
| `Type?`        | `null`                                                      | `icon: null`                                   |

### 未対応の型への対処

カスタム型や複雑なオブジェクトの場合、以下の TODO コメントが生成されます：

```dart
/* TODO: Please provide mock data for type: CustomModel */
```

## 🆘 AI エージェントへのモックデータ作成指示

### 基本的な対処方法

1. **TODO コメントを発見した場合**

   ```dart
   // 例: CustomModelが必要な場合
   const mockCustomModel = CustomModel(
     id: 1,
     name: 'Sample Model',
     isActive: true,
   );
   ```

2. **複雑なオブジェクトの場合**

   ```dart
   // 例: User オブジェクトの場合
   const mockUser = User(
     id: 'user-123',
     name: 'Test User',
     email: 'test@example.com',
     avatarUrl: 'https://example.com/avatar.jpg',
   );
   ```

3. **コールバック関数の場合**
   ```dart
   // 例: カスタムコールバック
   void mockOnCustomAction(String value) {
     print('Custom action called with: $value');
   }
   ```

### 必須手順

1. **型を確認**: 元の Widget 定義を確認し、必要な型を特定
2. **最小限のモックデータを作成**: テストが動作する最小限のデータを用意
3. **実際のデータに近い値を使用**: UI の見た目を適切に確認できるような値を設定
4. **コメント追加**: 生成したモックデータの目的を明記

## 🎯 特定の Widget タイプへの対処

### 1. ボタン系 Widget

```dart
// 必須パラメータ
text: 'Sample Button',
onPressed: () { print('Button pressed'); },

// オプションパラメータ
icon: Icons.star,
backgroundColor: Colors.blue,
size: ButtonSize.medium,
isEnabled: true,
```

### 2. 入力系 Widget

```dart
// 必須パラメータ
controller: TextEditingController(text: 'Sample Text'),
onChanged: (value) { print('Text changed: $value'); },

// オプションパラメータ
hintText: 'Enter text here',
validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
```

### 3. 表示系 Widget

```dart
// 必須パラメータ
title: 'Sample Title',
content: 'Sample content text',

// オプションパラメータ
icon: Icons.info,
color: Colors.green,
```

## 🔄 ワークフロー

### 1. 通常のフロー

```
1. ユーザーが "〜のGolden Testを作成して" と指示
2. enhanced_golden_test.dart を実行
3. 自動的にWidget解析とモックデータ生成
4. Golden Test ファイル作成
5. 必要に応じてテスト実行
```

### 2. エラーが発生した場合

```
1. エラーメッセージを確認
2. TODOコメントを探す
3. 必要なモックデータを手動で作成
4. テストファイルを編集
5. 再度テスト実行
```

## 📝 テンプレート構造

生成される Golden Test ファイルの構造：

```dart
import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter2025/components/custom_button.dart';

import '../../support/alchemist/device.dart'; // test/lib/components/ から test/support/ への相対パス

void main() {
  group('CustomButton Golden Tests', () {
    // 自動生成されるモックデータ

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
              // 自動生成されるコンストラクタ引数
            ),
          ),
        ),
      );
    }

    goldenTest(
      'renders correctly on various devices and themes',
      fileName: 'custom_button',
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

## 🎨 生成される Golden Image

- **複数デバイス対応**: Phone, Tablet, Web
- **複数テーマ対応**: Light, Dark
- **Material Design 3**: 最新の Material Design 使用
- **ファイル名**: `custom_button.png` (Widget 名を snake_case に変換)

## 🚨 注意点

1. **相対パス**: ディレクトリ構造に応じて自動調整
2. **必須パラメータ**: 必ず適切な値を設定
3. **型の一致**: Dart の型システムに従った値を使用
4. **可読性**: テストが理解しやすいようにコメントを追加

## 🔧 トラブルシューティング

### よくあるエラー

1. **Required parameter missing**: 必須パラメータが不足
   → モックデータを追加

2. **Type mismatch**: 型が一致しない
   → 正しい型の値を設定

3. **Import error**: パッケージが見つからない
   → 相対パスを確認

4. **Device not found**: Device.all が未定義
   → 正しい相対パスで device.dart を import

   **相対パスの例**:

   - `test/lib/` から: `import '../support/alchemist/device.dart';`
   - `test/lib/components/` から: `import '../../support/alchemist/device.dart';`
   - `test/lib/weather/widgets/` から: `import '../../../support/alchemist/device.dart';`

5. **RenderFlex overflowed**: レンダリングオーバーフロー
   → **⚠️ テスト実行を停止し、開発者に報告**
   → **AI エージェントによる自動修正は禁止**

## 🎯 成功のポイント

1. **段階的アプローチ**: 最初は基本的なテストから始める
2. **エラーメッセージを活用**: 具体的なエラーメッセージから問題を特定
3. **型システムを理解**: Dart の型システムに沿った値を使用
4. **実際のデータに近い値**: UI の見た目を適切に確認できる値を設定

## 📝 Golden Test 作成時の注意点

### 1. **デフォルトは複数プラットフォーム対応**

- **基本方針**: 常に`Device.all`を使用して複数のプラットフォーム（Phone、Tablet、Web 等）で検証
- **必須インポート**: `import '../support/alchemist/device.dart';`を含める
- **レスポンシブ UI**: 異なるサイズでのレイアウトの適応性を確認

```dart
// ✅ 推奨: 複数プラットフォーム対応（デフォルト）
import '../support/alchemist/device.dart';

goldenTest(
  'renders correctly on various devices and themes',
  fileName: 'component_name',
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
```

### 2. **レンダリングオーバーフロー対策**

**⚠️ 重要な方針：Golden Test では実際の Widget の状態をそのまま検証すること**

#### 🚫 やってはいけないこと

```dart
// ❌ テスト対象のWidgetを変更してはいけない
// ❌ Golden Test側でScrollViewなどで囲んではいけない
child: SingleChildScrollView(  // これは禁止
  child: YourWidget(),
)

// ❌ テスト用にWidgetの実装を変更してはいけない
// 実際のWidget実装にScrollViewを追加するのは禁止
```

#### ✅ 正しい対処方法

**レンダリングオーバーフローが発生した場合：**

1. **テスト実行を停止**
2. **開発者に以下の情報を報告**：

   ```
   レンダリングオーバーフローが発生しました:
   - Widget: [WidgetName]
   - ファイル: [widget_path]
   - 発生デバイス: [device.name]
   - 制約: [constraints]

   開発者による対応が必要です：
   - Widgetの実装を見直してください
   - 適切なScrollViewやレスポンシブデザインの実装を検討してください
   - または、固定サイズでのテストが適切か判断してください
   ```

3. **開発者の判断を待つ**

#### 🔧 開発者による対応例

開発者が判断する対応方法：

```dart
// 開発者が実装を修正する場合
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(  // 実装側で追加
      child: Column(
        children: [
          // 実際のコンテンツ
        ],
      ),
    );
  }
}

// または、開発者が固定サイズテストを選択する場合
// Golden Test側での最小限の調整（開発者の明示的な指示がある場合のみ）
```

### 3. **テストサイズの選択指針**

- **第一選択**: `Device.all`を使用した複数プラットフォーム対応
- **第二選択**: オーバーフロー発生時のみ固定サイズ
- **コンポーネント単体**: 通常は`Device.all`で問題なし
- **ページ全体**: `Device.all`で検証し、オーバーフロー時は要調整

### 4. **インポートの管理**

```dart
// ✅ Device.all を使う場合（推奨・デフォルト）
import '../support/alchemist/device.dart';

// ❌ 固定サイズのみの場合（device.dart不要だがプラットフォーム対応を失う）
// import '../support/alchemist/device.dart'; // 不要
```

---

このガイドに従うことで、AI エージェントは Flutter Golden Test の自動化を効率的に行うことができます。
