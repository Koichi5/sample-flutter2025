import 'package:flutter/material.dart';

enum TextVariant { body, caption, subtitle, title, headline }

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.variant = TextVariant.body,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.onTap,
  });

  final String text;
  final TextVariant variant;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isSelectable;
  final VoidCallback? onTap;

  TextStyle get _baseStyle {
    switch (variant) {
      case TextVariant.body:
        return const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
      case TextVariant.caption:
        return const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal);
      case TextVariant.subtitle:
        return const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500);
      case TextVariant.title:
        return const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600);
      case TextVariant.headline:
        return const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
    }
  }

  TextStyle get _effectiveStyle {
    return _baseStyle.copyWith(
      color: color,
      fontSize: fontSize ?? _baseStyle.fontSize,
      fontWeight: fontWeight ?? _baseStyle.fontWeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.textTheme.bodyLarge?.color;

    final textWidget =
        isSelectable
            ? SelectableText(
              text,
              style: _effectiveStyle.copyWith(color: effectiveColor),
              textAlign: textAlign,
              maxLines: maxLines,
              onTap: onTap,
            )
            : Text(
              text,
              style: _effectiveStyle.copyWith(color: effectiveColor),
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: overflow,
            );

    return onTap != null && !isSelectable
        ? GestureDetector(onTap: onTap, child: textWidget)
        : textWidget;
  }
}

// 使用例用のヘルパークラス
class CustomTextDemo extends StatelessWidget {
  const CustomTextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Text Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基本的なテキスト
            const CustomText(text: 'This is a basic body text'),
            const SizedBox(height: 16),

            // 見出し
            const CustomText(
              text: 'This is a Headline',
              variant: TextVariant.headline,
            ),
            const SizedBox(height: 16),

            // タイトル
            const CustomText(
              text: 'This is a Title',
              variant: TextVariant.title,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            // サブタイトル
            const CustomText(
              text: 'This is a Subtitle',
              variant: TextVariant.subtitle,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),

            // キャプション
            const CustomText(
              text: 'This is a caption text',
              variant: TextVariant.caption,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),

            // カスタムスタイル
            const CustomText(
              text: 'Custom styled text',
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
            const SizedBox(height: 16),

            // 中央揃え
            const CustomText(
              text: 'Centered text',
              textAlign: TextAlign.center,
              variant: TextVariant.title,
            ),
            const SizedBox(height: 16),

            // 最大行数制限
            const CustomText(
              text:
                  'This is a very long text that should be truncated when it exceeds the maximum number of lines set for this text widget',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // 選択可能なテキスト
            const CustomText(
              text: 'This text is selectable',
              isSelectable: true,
              variant: TextVariant.subtitle,
            ),
            const SizedBox(height: 16),

            // タップ可能なテキスト
            CustomText(
              text: 'Tap me!',
              variant: TextVariant.title,
              color: Colors.blue,
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Text tapped!')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
