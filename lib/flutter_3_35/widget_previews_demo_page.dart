import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter 3.35 Widget Previews機能のデモページ
///
/// Widget Previewsは独立したウィジェット開発環境を提供し、
/// デザインシステムの構築やコンポーネントテストを効率化します
class WidgetPreviewsDemoPage extends HookWidget {
  const WidgetPreviewsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPreviewType = useState<PreviewType>(PreviewType.button);
    final selectedTheme = useState<ThemeMode>(ThemeMode.light);
    final selectedDeviceSize = useState<DeviceSize>(DeviceSize.mobile);
    final previewInteractive = useState<bool>(true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Previews Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            _buildSectionHeader(context),

            const SizedBox(height: 24),

            // プレビュー設定コントロール
            _buildPreviewControls(
              context,
              selectedPreviewType,
              selectedTheme,
              selectedDeviceSize,
              previewInteractive,
            ),

            const SizedBox(height: 24),

            // プレビューエリア
            _buildPreviewArea(
              context,
              selectedPreviewType.value,
              selectedTheme.value,
              selectedDeviceSize.value,
              previewInteractive.value,
            ),

            const SizedBox(height: 24),

            // 機能説明
            _buildFeatureExplanation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Card(
      elevation: 4,
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
                Icons.preview,
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
                    'Flutter 3.35 Widget Previews',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '独立したウィジェットプレビュー環境（実験的機能）',
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

  Widget _buildPreviewControls(
    BuildContext context,
    ValueNotifier<PreviewType> selectedPreviewType,
    ValueNotifier<ThemeMode> selectedTheme,
    ValueNotifier<DeviceSize> selectedDeviceSize,
    ValueNotifier<bool> previewInteractive,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'プレビュー設定',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // ウィジェットタイプ選択
            Text(
              'プレビューするウィジェット',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  PreviewType.values.map((type) {
                    return ValueListenableBuilder<PreviewType>(
                      valueListenable: selectedPreviewType,
                      builder: (context, selected, _) {
                        return ChoiceChip(
                          label: Text(type.displayName),
                          selected: selected == type,
                          onSelected: (isSelected) {
                            if (isSelected) selectedPreviewType.value = type;
                          },
                        );
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            // テーマ選択
            Text(
              'テーマ',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: selectedTheme,
              builder: (context, theme, _) {
                return SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.auto_mode),
                    ),
                  ],
                  selected: {theme},
                  onSelectionChanged: (Set<ThemeMode> selection) {
                    selectedTheme.value = selection.first;
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // デバイスサイズ選択
            Text(
              'デバイスサイズ',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<DeviceSize>(
              valueListenable: selectedDeviceSize,
              builder: (context, size, _) {
                return SegmentedButton<DeviceSize>(
                  segments:
                      DeviceSize.values.map((deviceSize) {
                        return ButtonSegment(
                          value: deviceSize,
                          label: Text(deviceSize.displayName),
                          icon: Icon(deviceSize.icon),
                        );
                      }).toList(),
                  selected: {size},
                  onSelectionChanged: (Set<DeviceSize> selection) {
                    selectedDeviceSize.value = selection.first;
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // インタラクティブモード切り替え
            ValueListenableBuilder<bool>(
              valueListenable: previewInteractive,
              builder: (context, interactive, _) {
                return SwitchListTile(
                  title: const Text('インタラクティブモード'),
                  subtitle: const Text('ウィジェットの操作を有効にする'),
                  value: interactive,
                  onChanged: (value) {
                    previewInteractive.value = value;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewArea(
    BuildContext context,
    PreviewType previewType,
    ThemeMode themeMode,
    DeviceSize deviceSize,
    bool interactive,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'プレビューエリア',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text('${deviceSize.displayName} - ${themeMode.name}'),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // プレビューフレーム
            Center(
              child: Container(
                width: deviceSize.width,
                height: deviceSize.height,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Theme(
                    data: _getThemeData(context, themeMode),
                    child: Material(
                      child: Container(
                        color:
                            _getThemeData(
                              context,
                              themeMode,
                            ).scaffoldBackgroundColor,
                        padding: const EdgeInsets.all(16),
                        child: _buildPreviewWidget(previewType, interactive),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // プレビュー情報
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📱 プレビュー情報',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('ウィジェット: ${previewType.displayName}'),
                  Text(
                    'サイズ: ${deviceSize.width.toInt()}×${deviceSize.height.toInt()}px',
                  ),
                  Text('テーマ: ${themeMode.name}'),
                  Text('インタラクティブ: ${interactive ? "有効" : "無効"}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewWidget(PreviewType type, bool interactive) {
    switch (type) {
      case PreviewType.button:
        return _ButtonPreview(interactive: interactive);
      case PreviewType.card:
        return _CardPreview(interactive: interactive);
      case PreviewType.form:
        return _FormPreview(interactive: interactive);
      case PreviewType.list:
        return _ListPreview(interactive: interactive);
      case PreviewType.navigation:
        return _NavigationPreview(interactive: interactive);
    }
  }

  ThemeData _getThemeData(BuildContext context, ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return ThemeData.light();
      case ThemeMode.dark:
        return ThemeData.dark();
      case ThemeMode.system:
        return Theme.of(context);
    }
  }

  Widget _buildFeatureExplanation(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Widget Previewsの恩恵',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('✅ デザインシステムの効率的な構築'),
            const Text('✅ 複数テーマでの同時確認'),
            const Text('✅ 様々な画面サイズでのレスポンシブテスト'),
            const Text('✅ ウィジェットの独立したテスト環境'),
            const Text('✅ アプリ全体を起動せずにUI開発'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '🚧 実験的機能: この機能は実験段階で、今後のアップデートで'
                'API や機能が変更される可能性があります。',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// プレビュータイプの定義
enum PreviewType {
  button('Button'),
  card('Card'),
  form('Form'),
  list('List'),
  navigation('Navigation');

  const PreviewType(this.displayName);
  final String displayName;
}

// デバイスサイズの定義
enum DeviceSize {
  mobile('Mobile', 320, 240, Icons.phone_android),
  tablet('Tablet', 480, 320, Icons.tablet),
  desktop('Desktop', 640, 400, Icons.computer);

  const DeviceSize(this.displayName, this.width, this.height, this.icon);
  final String displayName;
  final double width;
  final double height;
  final IconData icon;
}

// プレビューウィジェットの実装

class _ButtonPreview extends HookWidget {
  final bool interactive;

  const _ButtonPreview({required this.interactive});

  @override
  Widget build(BuildContext context) {
    final isPressed = useState(false);
    final counter = useState(0);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Button Variants',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Primary Button
          ElevatedButton(
            onPressed:
                interactive
                    ? () {
                      counter.value++;
                    }
                    : null,
            child: Text('Primary (${counter.value})'),
          ),

          const SizedBox(height: 8),

          // Secondary Button
          OutlinedButton(
            onPressed:
                interactive
                    ? () {
                      isPressed.value = !isPressed.value;
                    }
                    : null,
            child: Text(isPressed.value ? 'Pressed!' : 'Secondary'),
          ),

          const SizedBox(height: 8),

          // Text Button
          TextButton(
            onPressed: interactive ? () {} : null,
            child: const Text('Text Button'),
          ),
        ],
      ),
    );
  }
}

class _CardPreview extends StatelessWidget {
  final bool interactive;

  const _CardPreview({required this.interactive});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text('Card Example'),
              subtitle: const Text('This is a preview card'),
              trailing:
                  interactive
                      ? IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      )
                      : const Icon(Icons.more_vert),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content Card',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('Sample content text for preview'),
                  const SizedBox(height: 12),
                  if (interactive)
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Action'),
                    )
                  else
                    const ElevatedButton(
                      onPressed: null,
                      child: Text('Action'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormPreview extends HookWidget {
  final bool interactive;

  const _FormPreview({required this.interactive});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final agreeToTerms = useState(false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Form Preview',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: nameController,
              enabled: interactive,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: emailController,
              enabled: interactive,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),

            ValueListenableBuilder<bool>(
              valueListenable: agreeToTerms,
              builder: (context, agree, _) {
                return CheckboxListTile(
                  title: const Text('Terms & Conditions'),
                  value: agree,
                  enabled: interactive,
                  onChanged:
                      interactive
                          ? (value) {
                            agreeToTerms.value = value ?? false;
                          }
                          : null,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ListPreview extends StatelessWidget {
  final bool interactive;

  const _ListPreview({required this.interactive});

  @override
  Widget build(BuildContext context) {
    final items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(items[index]),
          subtitle: Text('Subtitle for ${items[index]}'),
          trailing:
              interactive
                  ? IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {},
                  )
                  : const Icon(Icons.arrow_forward_ios),
        );
      },
    );
  }
}

class _NavigationPreview extends HookWidget {
  final bool interactive;

  const _NavigationPreview({required this.interactive});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    return Column(
      children: [
        AppBar(
          title: const Text('Navigation'),
          automaticallyImplyLeading: false,
        ),
        Expanded(
          child: Center(
            child: Text(
              'Page ${selectedIndex.value + 1}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        ValueListenableBuilder<int>(
          valueListenable: selectedIndex,
          builder: (context, index, _) {
            return NavigationBar(
              selectedIndex: index,
              onDestinationSelected:
                  interactive
                      ? (newIndex) {
                        selectedIndex.value = newIndex;
                      }
                      : null,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
