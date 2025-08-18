import 'package:flutter/material.dart';
import 'web_hot_reload_demo_page.dart';
import 'material3_components_demo_page.dart';
import 'widget_previews_demo_page.dart';

/// Flutter 3.35の新機能をまとめて紹介するホームページ
class Flutter335HomePage extends StatelessWidget {
  const Flutter335HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 3.35 新機能デモ'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.flutter_dash,
                        size: 48,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Flutter 3.35 新機能',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hot Reload, Widget Previews, and More',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                '利用可能なデモ',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // デモ機能一覧
              Expanded(
                child: ListView(
                  children: [
                    _buildDemoCard(
                      context,
                      title: 'Web Hot Reload Demo',
                      description:
                          'WebでのStateful Hot Reload機能をテスト\n状態保持とリアルタイム更新を体験',
                      icon: Icons.web,
                      color: Colors.blue,
                      status: '✅ 利用可能',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WebHotReloadDemoPage(),
                          ),
                        );
                      },
                    ),

                    _buildDemoCard(
                      context,
                      title: 'Widget Previews',
                      description: '独立したウィジェットプレビュー機能\nデザインシステムの構築支援',
                      icon: Icons.preview,
                      color: Colors.purple,
                      status: '✅ 利用可能',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => const WidgetPreviewsDemoPage(),
                          ),
                        );
                      },
                    ),

                    _buildDemoCard(
                      context,
                      title: 'Material 3 Components',
                      description:
                          '新しいMaterial 3コンポーネント\nDropdownMenuFormField, NavigationRail等',
                      icon: Icons.widgets,
                      color: Colors.teal,
                      status: '✅ 利用可能',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const Material3ComponentsDemoPage(),
                          ),
                        );
                      },
                    ),

                    _buildDemoCard(
                      context,
                      title: 'Accessibility Features',
                      description: 'アクセシビリティ強化機能\nSemanticsLabelBuilder等',
                      icon: Icons.accessibility,
                      color: Colors.orange,
                      status: '🔄 準備中',
                      onTap: null, // まだ実装されていない
                    ),

                    _buildDemoCard(
                      context,
                      title: 'Cupertino Enhancements',
                      description: 'iOS風UIの改善\nCupertinoExpansionTile等',
                      icon: Icons.phone_iphone,
                      color: Colors.grey,
                      status: '🔄 準備中',
                      onTap: null, // まだ実装されていない
                    ),
                  ],
                ),
              ),

              // フッター情報
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '実装状況',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade700,
                              ),
                            ),
                            const Text(
                              'Flutter 3.35の新機能を順次実装中です。\n各デモで実際の改善効果を確認できます。',
                              style: TextStyle(fontSize: 12),
                            ),
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
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String status,
    VoidCallback? onTap,
  }) {
    final isAvailable = onTap != null;

    return Card(
      elevation: isAvailable ? 4 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color:
                      isAvailable
                          ? color.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isAvailable ? color : Colors.grey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isAvailable ? Colors.black87 : Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isAvailable
                                    ? color.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isAvailable ? color : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isAvailable ? Colors.grey.shade600 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (isAvailable)
                Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
