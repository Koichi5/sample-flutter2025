import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter 3.35で追加された新しいMaterial 3コンポーネントのデモページ
/// Flutter Hooksを使用した実装
class Material3ComponentsDemoPage extends HookWidget {
  const Material3ComponentsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hooks を使用した状態管理
    final selectedDropdownValue = useState<String?>(null);
    final selectedRailIndex = useState<int>(0);
    final showCupertinoDemo = useState<bool>(false);
    final selectedFormDropdownValue = useState<String?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // DropdownMenuFormField用のサンプルデータ
    final countries = useMemoized(
      () => [
        'Japan',
        'United States',
        'United Kingdom',
        'Canada',
        'Australia',
        'Germany',
        'France',
        'South Korea',
      ],
    );

    // NavigationRail用のサンプルデータ（多数の項目）
    final railDestinations = useMemoized(
      () => [
        const NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: Text('Explore'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.favorite_outline),
          selectedIcon: Icon(Icons.favorite),
          label: Text('Favorites'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: Text('Cart'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profile'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications),
          label: Text('Notifications'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.message_outlined),
          selectedIcon: Icon(Icons.message),
          label: Text('Messages'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.bookmark_outline),
          selectedIcon: Icon(Icons.bookmark),
          label: Text('Bookmarks'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.help_outline),
          selectedIcon: Icon(Icons.help),
          label: Text('Help'),
        ),
      ],
    );
    // レスポンシブレイアウトの判定
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    final isMobile = MediaQuery.of(context).size.width <= 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 Components Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: _buildNavigationDrawerWithHeaderFooter(context),
      body:
          isMobile
              ? // モバイル用レイアウト（NavigationRailなし）
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ヘッダー
                      _buildSectionHeader(
                        context,
                        'Flutter 3.35 Material 3 Components',
                        'New and enhanced components for modern UI design',
                        Icons.widgets,
                      ),

                      const SizedBox(height: 24),

                      // DropdownMenuFormField デモ
                      _buildDropdownMenuFormFieldDemo(
                        context,
                        formKey,
                        countries,
                        selectedDropdownValue,
                        selectedFormDropdownValue,
                      ),

                      const SizedBox(height: 24),

                      // NavigationRail スクロール機能デモ（モバイル用）
                      _buildNavigationRailDemoMobile(
                        context,
                        railDestinations,
                        selectedRailIndex,
                      ),

                      const SizedBox(height: 24),

                      // NavigationDrawer デモ
                      _buildNavigationDrawerDemo(context),

                      const SizedBox(height: 24),

                      // CupertinoExpansionTile デモ
                      _buildCupertinoExpansionTileDemo(
                        context,
                        showCupertinoDemo,
                      ),
                    ],
                  ),
                ),
              )
              : // タブレット・デスクトップ用レイアウト
              Row(
                children: [
                  // Scrollable NavigationRail（デスクトップ・タブレットのみ）
                  SizedBox(
                    height: MediaQuery.of(context).size.height - kToolbarHeight,
                    child: SingleChildScrollView(
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          extended: isDesktop,
                          destinations: railDestinations,
                          selectedIndex: selectedRailIndex.value,
                          onDestinationSelected: (index) {
                            selectedRailIndex.value = index;
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          elevation: 1,
                          // Flutter 3.35の新機能：スクロール可能なNavigationRail
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),

                  // メインコンテンツ
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ヘッダー
                          _buildSectionHeader(
                            context,
                            'Flutter 3.35 Material 3 Components',
                            'New and enhanced components for modern UI design',
                            Icons.widgets,
                          ),

                          const SizedBox(height: 32),

                          // DropdownMenuFormField デモ
                          _buildDropdownMenuFormFieldDemo(
                            context,
                            formKey,
                            countries,
                            selectedDropdownValue,
                            selectedFormDropdownValue,
                          ),

                          const SizedBox(height: 32),

                          // NavigationRail スクロール機能デモ
                          _buildNavigationRailDemo(
                            context,
                            railDestinations,
                            selectedRailIndex,
                          ),

                          const SizedBox(height: 32),

                          // NavigationDrawer デモ
                          _buildNavigationDrawerDemo(context),

                          const SizedBox(height: 32),

                          // CupertinoExpansionTile デモ
                          _buildCupertinoExpansionTileDemo(
                            context,
                            showCupertinoDemo,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  static Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDropdownMenuFormFieldDemo(
    BuildContext context,
    GlobalKey<FormState> formKey,
    List<String> countries,
    ValueNotifier<String?> selectedDropdownValue,
    ValueNotifier<String?> selectedFormDropdownValue,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. DropdownMenuFormField',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Flutter 3.35で追加：フォーム内でMaterial 3のDropdownMenuを直接使用可能',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            Form(
              key: formKey,
              child: Column(
                children: [
                  // 従来のDropdownButtonFormField
                  DropdownButtonFormField<String>(
                    initialValue: selectedDropdownValue.value,
                    decoration: const InputDecoration(
                      labelText: '従来のDropdownButtonFormField',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        countries.map((country) {
                          return DropdownMenuItem(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                    onChanged: (value) {
                      selectedDropdownValue.value = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return '国を選択してください';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // 新しいDropdownMenuFormField
                  DropdownMenu<String>(
                    width: double.infinity,
                    label: const Text('新しいDropdownMenuFormField'),
                    hintText: '国を選択してください',
                    dropdownMenuEntries:
                        countries.map((country) {
                          return DropdownMenuEntry<String>(
                            value: country,
                            label: country,
                            leadingIcon: const Icon(Icons.flag),
                          );
                        }).toList(),
                    onSelected: (value) {
                      selectedFormDropdownValue.value = value;
                    },
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ 新機能の改善点',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('• より現代的なMaterial 3デザイン'),
                  const Text('• 検索・フィルタリング機能の内蔵'),
                  const Text('• アイコン付きエントリーのサポート'),
                  const Text('• よりアクセシブルな操作性'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'フォーム検証成功！\n'
                        '従来: ${selectedDropdownValue.value}\n'
                        '新機能: ${selectedFormDropdownValue.value}',
                      ),
                    ),
                  );
                }
              },
              child: const Text('フォーム検証テスト'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildNavigationRailDemo(
    BuildContext context,
    List<NavigationRailDestination> railDestinations,
    ValueNotifier<int> selectedRailIndex,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2. Scrollable NavigationRail',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Flutter 3.35で追加：項目が多い場合にNavigationRailがスクロール可能に',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // スクロール可能なNavigationRailのデモ
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          destinations: railDestinations,
                          selectedIndex: selectedRailIndex.value,
                          onDestinationSelected: (index) {
                            selectedRailIndex.value = index;
                          },
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<int>(
                            valueListenable: selectedRailIndex,
                            builder: (context, index, _) {
                              return Text(
                                '選択された項目: ${railDestinations[index].label}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('左のNavigationRailには10個の項目があります。'),
                          const Text('画面の高さが足りない場合、自動的にスクロール可能になります。'),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '💡 使用ケース',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text('• 管理画面での多数のメニュー項目'),
                                Text('• 複雑なアプリケーションのナビゲーション'),
                                Text('• タブレット・デスクトップでの利用'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // モバイル用のNavigationRailデモ（画面に収まるようにコンパクト化）
  static Widget _buildNavigationRailDemoMobile(
    BuildContext context,
    List<NavigationRailDestination> railDestinations,
    ValueNotifier<int> selectedRailIndex,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2. Scrollable NavigationRail',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Flutter 3.35で追加：項目が多い場合にNavigationRailがスクロール可能に',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // モバイルでは横スクロールで表示
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            railDestinations.asMap().entries.map((entry) {
                              final index = entry.key;
                              final destination = entry.value;
                              final isSelected =
                                  selectedRailIndex.value == index;

                              return GestureDetector(
                                onTap: () => selectedRailIndex.value = index,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primaryContainer
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      isSelected
                                          ? destination.selectedIcon
                                          : destination.icon,
                                      const SizedBox(height: 4),
                                      destination.label,
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      child: ValueListenableBuilder<int>(
                        valueListenable: selectedRailIndex,
                        builder: (context, index, _) {
                          return Text(
                            '選択: ${railDestinations[index].label}',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📱 モバイル対応',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• 横スクロールで項目を表示'),
                  Text('• タッチしやすいサイズに調整'),
                  Text('• デスクトップでは縦型NavigationRail'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildNavigationDrawerDemo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3. NavigationDrawer with Header/Footer',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Flutter 3.35で追加：NavigationDrawerにヘッダーとフッターを追加可能',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
              label: const Text('NavigationDrawerを開く'),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎨 新機能の特徴',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• ユーザー情報表示用のヘッダー'),
                  Text('• 設定・ログアウト用のフッター'),
                  Text('• より柔軟なレイアウト設計'),
                  Text('• ブランディング要素の配置'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCupertinoExpansionTileDemo(
    BuildContext context,
    ValueNotifier<bool> showCupertinoDemo,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '4. CupertinoExpansionTile',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: showCupertinoDemo,
                      builder: (context, value, _) {
                        return Switch.adaptive(
                          value: value,
                          onChanged: (newValue) {
                            showCupertinoDemo.value = newValue;
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('iOS風表示'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Flutter 3.35で追加：iOS風の展開可能リストアイテム',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            ValueListenableBuilder<bool>(
              valueListenable: showCupertinoDemo,
              builder: (context, value, _) {
                if (value) {
                  // Cupertinoスタイルのデモ
                  return CupertinoTheme(
                    data: const CupertinoThemeData(),
                    child: Column(
                      children: [
                        _buildCupertinoExpansionTile(
                          context,
                          'アカウント設定',
                          Icons.person,
                          ['プロフィール編集', 'パスワード変更', 'プライバシー設定', 'セキュリティ設定'],
                        ),
                        _buildCupertinoExpansionTile(
                          context,
                          '通知設定',
                          Icons.notifications,
                          ['プッシュ通知', 'メール通知', 'SMS通知', '通知時間設定'],
                        ),
                        _buildCupertinoExpansionTile(
                          context,
                          'アプリ設定',
                          Icons.settings,
                          ['テーマ設定', '言語設定', 'データ使用量', 'キャッシュクリア'],
                        ),
                      ],
                    ),
                  );
                } else {
                  // Material版との比較
                  return Column(
                    children: [
                      ExpansionTile(
                        leading: const Icon(Icons.person),
                        title: const Text('アカウント設定（Material版）'),
                        children:
                            ['プロフィール編集', 'パスワード変更', 'プライバシー設定', 'セキュリティ設定']
                                .map(
                                  (item) =>
                                      ListTile(title: Text(item), onTap: () {}),
                                )
                                .toList(),
                      ),
                      ExpansionTile(
                        leading: const Icon(Icons.notifications),
                        title: const Text('通知設定（Material版）'),
                        children:
                            ['プッシュ通知', 'メール通知', 'SMS通知', '通知時間設定']
                                .map(
                                  (item) =>
                                      ListTile(title: Text(item), onTap: () {}),
                                )
                                .toList(),
                      ),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🍎 iOS風デザインの特徴',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• iOS標準のアニメーション'),
                  Text('• Cupertino風のスタイリング'),
                  Text('• iOS HIG準拠のUX'),
                  Text('• プラットフォーム適応デザイン'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCupertinoExpansionTile(
    BuildContext context,
    String title,
    IconData icon,
    List<String> items,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoExpansionTile(
        leading: Icon(icon, color: CupertinoColors.systemBlue),
        title: Text(title),
        children:
            items
                .map(
                  (item) => CupertinoListTile(
                    title: Text(item),
                    trailing: const Icon(
                      CupertinoIcons.chevron_right,
                      size: 16,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$item がタップされました')),
                      );
                    },
                  ),
                )
                .toList(),
      ),
    );
  }

  static Widget _buildNavigationDrawerWithHeaderFooter(BuildContext context) {
    return NavigationDrawer(
      children: [
        // ヘッダー（Flutter 3.35の新機能）
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.secondaryContainer,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 35, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                'ユーザー名',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'user@example.com',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        const Divider(),

        // メニュー項目
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: Text('Explore'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.favorite_outline),
          selectedIcon: Icon(Icons.favorite),
          label: Text('Favorites'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),

        const Spacer(),

        const Divider(),

        // フッター（Flutter 3.35の新機能）
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('ヘルプ'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('ヘルプページを開きます')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('ログアウト'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('ログアウトしました')));
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Flutter 3.35 Demo\nVersion 1.0.0',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// CupertinoExpansionTileの実装（Flutter 3.35で追加される予定の機能をシミュレート）
// Flutter Hooksを使用した実装
class CupertinoExpansionTile extends HookWidget {
  final Widget title;
  final Widget? leading;
  final List<Widget> children;

  const CupertinoExpansionTile({
    super.key,
    required this.title,
    this.leading,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final animation = useMemoized(
      () =>
          CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
      [animationController],
    );
    final isExpanded = useState(false);

    return Column(
      children: [
        CupertinoListTile(
          leading: leading,
          title: title,
          trailing: AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: isExpanded.value ? 0.25 : 0,
            child: const Icon(CupertinoIcons.chevron_right),
          ),
          onTap: () {
            isExpanded.value = !isExpanded.value;
            if (isExpanded.value) {
              animationController.forward();
            } else {
              animationController.reverse();
            }
          },
        ),
        SizeTransition(
          sizeFactor: animation,
          child: Container(
            padding: const EdgeInsets.only(left: 16),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

// CupertinoListTileの実装（必要に応じて）
class CupertinoListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CupertinoListTile({
    super.key,
    this.leading,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: onTap,
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(child: title),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
