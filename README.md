# sample_flutter2025

A new Flutter project.

## Golden Test Workflow

### 🎯 簡単な運用手順

UI 関連の変更がある PR では、以下の手順で Golden Test を実行してください：

#### 1. PR の作成

```bash
git add .
git commit -m "feat: UI changes"
git push origin your-branch
```

#### 2. ラベルの付与

- PR を作成後、`golden_test` ラベルを**手動で**付与してください
- ラベルを付与すると自動的に Golden Test が実行されます

#### 3. 結果の確認

- PR コメントに自動生成される視覚的な比較結果を確認
- 意図した変更かどうかを検証

#### 4. Golden Image の更新（必要な場合）

変更が意図したものである場合：

```bash
# ローカルで Golden Image を更新
flutter test --tags golden --update-goldens

# 更新をコミット
git add test/**/goldens/**/*.png
git commit -m "chore: update golden test images"
git push origin your-branch
```

### 🔍 対象となるファイル

- `lib/components/` - UI コンポーネント
- `lib/pages/` - ページファイル
- `lib/*/widgets/` - ウィジェット
- `lib/*/views/` - ビューファイル

### 💡 Tips

- UI 変更がない場合は `golden_test` ラベルを付与する必要はありません
- 不明な点があれば既存のドキュメント（`docs/`）を参照してください

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
