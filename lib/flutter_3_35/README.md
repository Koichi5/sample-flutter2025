# Flutter 3.35 新機能デモ

このディレクトリには、Flutter 3.35 で導入された新機能のデモが含まれています。

## 利用可能なデモ

### ✅ 1. Web Hot Reload Demo

**ファイル**: `web_hot_reload_demo_page.dart`

**機能**:

- Web での Stateful Hot Reload 機能をテスト
- 状態保持とリアルタイム更新を体験
- カウンター、UI 変更、アニメーション機能

**テスト方法**:

1. `flutter run -d chrome` で Web アプリを起動
2. カウンターを操作して状態を作成
3. `_dynamicText` の文字列を変更して保存
4. Hot Reload で状態が保持されることを確認

### ✅ 2. Material 3 Components Demo

**ファイル**: `material3_components_demo_page.dart`

**機能**:

- **DropdownMenuFormField**: フォーム内で M3 ドロップダウンメニューを使用
- **Scrollable NavigationRail**: 多数の項目でのスクロール対応
- **NavigationDrawer header/footer**: ヘッダー・フッター付きナビゲーション
- **CupertinoExpansionTile**: iOS 風の展開可能リストアイテム

**テスト内容**:

- 従来の DropdownButtonFormField との比較
- NavigationRail のスクロール機能
- NavigationDrawer のカスタマイズ
- iOS スタイルの ExpansionTile

### ✅ 3. Widget Previews Demo

**ファイル**: `widget_previews_demo_page.dart`

**機能**:

- **独立したウィジェットプレビュー**: アプリ全体を起動せずにコンポーネント開発
- **マルチテーマ対応**: Light/Dark/System テーマでの同時確認
- **レスポンシブテスト**: Mobile/Tablet/Desktop サイズでの表示確認
- **インタラクティブモード**: ウィジェットの動作テスト

**プレビュー可能ウィジェット**:

- Button variants (Primary, Secondary, Text)
- Card layouts (List tiles, Content cards)
- Form components (TextFields, Checkboxes)
- List views (Custom list items)
- Navigation patterns (AppBar, NavigationBar)

**テスト方法**:

1. プレビューするウィジェットタイプを選択
2. テーマ（Light/Dark/System）を切り替え
3. デバイスサイズ（Mobile/Tablet/Desktop）を選択
4. インタラクティブモードでウィジェットの動作を確認

## 🔄 準備中の機能

### Accessibility Features

- SemanticsLabelBuilder
- SliverEnsureSemantics
- 多言語セマンティクス対応

### Cupertino Enhancements

- 追加の iOS 風 UI 改善
- ハプティックフィードバック

## 使用方法

1. メインアプリを起動
2. ホームページから「Flutter 3.35 新機能」を選択
3. 各デモページで実際の機能を体験

## 実装のポイント

### Web Hot Reload

```dart
// 状態を保持しながらUIの変更を確認
String _dynamicText = "この文字列を変更してテスト";
```

### Material 3 Components

```dart
// 新しいDropdownMenuFormField
DropdownMenu<String>(
  dropdownMenuEntries: items.map((item) {
    return DropdownMenuEntry<String>(
      value: item,
      label: item,
      leadingIcon: const Icon(Icons.flag),
    );
  }).toList(),
)

// スクロール可能なNavigationRail
NavigationRail(
  destinations: manyDestinations, // 多数の項目
  // 自動的にスクロール可能になる
)
```

### NavigationDrawer with Header/Footer

```dart
NavigationDrawer(
  children: [
    // ヘッダー部分
    Container(/* ユーザー情報など */),

    // メニュー項目
    NavigationDrawerDestination(...),

    const Spacer(),

    // フッター部分
    Padding(/* 設定・ログアウトなど */),
  ],
)
```

## 恩恵と改善点

### Web Hot Reload

- **開発効率**: Web 開発時の反復速度が大幅向上
- **状態保持**: ページリロードなしでの開発が可能
- **生産性**: デバッグ・UI 調整の時間短縮

### Material 3 Components

- **モダンデザイン**: 最新の Material 3 準拠
- **アクセシビリティ**: より包括的な UI 対応
- **開発者体験**: より直感的な API 設計
- **柔軟性**: カスタマイズ性の向上

これらの機能を実際に使用することで、Flutter 3.35 の恩恵を具体的に体感し、他の開発者に伝えることができます。
