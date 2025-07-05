import 'package:flutter/material.dart';

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.size = ButtonSize.medium,
    this.isEnabled = true,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final ButtonSize size;
  final bool isEnabled;
  final bool isLoading;

  double get _buttonHeight {
    switch (size) {
      case ButtonSize.small:
        return 32.0;
      case ButtonSize.medium:
        return 48.0;
      case ButtonSize.large:
        return 56.0;
    }
  }

  double get _fontSize {
    switch (size) {
      case ButtonSize.small:
        return 12.0;
      case ButtonSize.medium:
        return 16.0;
      case ButtonSize.large:
        return 18.0;
    }
  }

  EdgeInsetsGeometry get _padding {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12.0);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16.0);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? theme.primaryColor;
    final effectiveTextColor = textColor ?? Colors.white;

    return SizedBox(
      height: _buttonHeight,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          padding: _padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: isEnabled ? 2.0 : 0.0,
        ),
        child: isLoading
            ? SizedBox(
                width: _fontSize,
                height: _fontSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: _fontSize,
                      color: effectiveTextColor,
                    ),
                    const SizedBox(width: 8.0),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: FontWeight.w600,
                      color: effectiveTextColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// 使用例用のヘルパークラス
class CustomButtonDemo extends StatelessWidget {
  const CustomButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Button Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 基本的なボタン
            CustomButton(
              text: 'Basic Button',
              onPressed: () {},
            ),
            const SizedBox(height: 16),

            // アイコン付きボタン
            CustomButton(
              text: 'Save',
              icon: Icons.save,
              onPressed: () {},
              backgroundColor: Colors.green,
            ),
            const SizedBox(height: 16),

            // 大きいボタン
            CustomButton(
              text: 'Large Button',
              size: ButtonSize.large,
              onPressed: () {},
              backgroundColor: Colors.purple,
            ),
            const SizedBox(height: 16),

            // 小さいボタン
            CustomButton(
              text: 'Small',
              size: ButtonSize.small,
              onPressed: () {},
              backgroundColor: Colors.orange,
            ),
            const SizedBox(height: 16),

            // 無効化されたボタン
            const CustomButton(
              text: 'Disabled Button',
              onPressed: null,
              isEnabled: false,
            ),
            const SizedBox(height: 16),

            // ローディング状態のボタン
            const CustomButton(
              text: 'Loading...',
              onPressed: null,
              isLoading: true,
            ),
          ],
        ),
      ),
    );
  }
}