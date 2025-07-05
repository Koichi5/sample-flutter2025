import 'package:flutter/material.dart';

enum DialogType { success, error, warning, info, custom }

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.type = DialogType.custom,
    this.actions,
    this.icon,
    this.titleStyle,
    this.contentStyle,
    this.backgroundColor,
    this.borderRadius = 16.0,
    this.isDismissible = true,
    this.showCloseButton = true,
    this.onClosed,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(24.0),
  });

  final String title;
  final String content;
  final DialogType type;
  final List<Widget>? actions;
  final IconData? icon;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Color? backgroundColor;
  final double borderRadius;
  final bool isDismissible;
  final bool showCloseButton;
  final VoidCallback? onClosed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;

  Color get _typeColor {
    switch (type) {
      case DialogType.success:
        return Colors.green;
      case DialogType.error:
        return Colors.red;
      case DialogType.warning:
        return Colors.orange;
      case DialogType.info:
        return Colors.blue;
      case DialogType.custom:
        return Colors.grey;
    }
  }

  IconData get _typeIcon {
    if (icon != null) return icon!;

    switch (type) {
      case DialogType.success:
        return Icons.check_circle;
      case DialogType.error:
        return Icons.error;
      case DialogType.warning:
        return Icons.warning;
      case DialogType.info:
        return Icons.info;
      case DialogType.custom:
        return Icons.help_outline;
    }
  }

  TextStyle get _defaultTitleStyle {
    return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: _typeColor,
    );
  }

  TextStyle get _defaultContentStyle {
    return const TextStyle(fontSize: 16.0, color: Colors.black87);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.dialogBackgroundColor;

    return Dialog(
      backgroundColor: effectiveBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        width: width,
        height: height,
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            if (showCloseButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onClosed?.call();
                    },
                  ),
                ],
              ),

            // Icon
            Icon(_typeIcon, size: 48, color: _typeColor),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: titleStyle ?? _defaultTitleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Content
            Flexible(
              child: Text(
                content,
                style: contentStyle ?? _defaultContentStyle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            if (actions != null && actions!.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions!,
              )
            else
              // Default OK button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _typeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClosed?.call();
                  },
                  child: const Text('OK'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Utility method to show the dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    DialogType type = DialogType.custom,
    List<Widget>? actions,
    IconData? icon,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    Color? backgroundColor,
    double borderRadius = 16.0,
    bool isDismissible = true,
    bool showCloseButton = true,
    VoidCallback? onClosed,
    double? width,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24.0),
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return CustomDialog(
          title: title,
          content: content,
          type: type,
          actions: actions,
          icon: icon,
          titleStyle: titleStyle,
          contentStyle: contentStyle,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          isDismissible: isDismissible,
          showCloseButton: showCloseButton,
          onClosed: onClosed,
          width: width,
          height: height,
          padding: padding,
        );
      },
    );
  }
}

// 使用例用のヘルパークラス
class CustomDialogDemo extends StatelessWidget {
  const CustomDialogDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Dialog Demo')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const Text(
              'Dialog Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Success Dialog
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              label: const Text('Success Dialog'),
              onPressed: () => _showSuccessDialog(context),
            ),
            const SizedBox(height: 16),

            // Error Dialog
            ElevatedButton.icon(
              icon: const Icon(Icons.error, color: Colors.red),
              label: const Text('Error Dialog'),
              onPressed: () => _showErrorDialog(context),
            ),
            const SizedBox(height: 16),

            // Warning Dialog
            ElevatedButton.icon(
              icon: const Icon(Icons.warning, color: Colors.orange),
              label: const Text('Warning Dialog'),
              onPressed: () => _showWarningDialog(context),
            ),
            const SizedBox(height: 16),

            // Info Dialog
            ElevatedButton.icon(
              icon: const Icon(Icons.info, color: Colors.blue),
              label: const Text('Info Dialog'),
              onPressed: () => _showInfoDialog(context),
            ),
            const SizedBox(height: 16),

            // Custom Dialog with Actions
            ElevatedButton.icon(
              icon: const Icon(Icons.settings, color: Colors.purple),
              label: const Text('Custom Dialog with Actions'),
              onPressed: () => _showCustomDialog(context),
            ),
            const SizedBox(height: 16),

            // Confirmation Dialog
            ElevatedButton.icon(
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Confirmation Dialog'),
              onPressed: () => _showConfirmationDialog(context),
            ),
          ],
        ),
      ),
    ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    CustomDialog.show(
      context: context,
      type: DialogType.success,
      title: 'Success!',
      content: 'Your operation has been completed successfully.',
    );
  }

  void _showErrorDialog(BuildContext context) {
    CustomDialog.show(
      context: context,
      type: DialogType.error,
      title: 'Error Occurred',
      content: 'Something went wrong. Please try again later.',
    );
  }

  void _showWarningDialog(BuildContext context) {
    CustomDialog.show(
      context: context,
      type: DialogType.warning,
      title: 'Warning',
      content: 'This action may have unintended consequences.',
    );
  }

  void _showInfoDialog(BuildContext context) {
    CustomDialog.show(
      context: context,
      type: DialogType.info,
      title: 'Information',
      content: 'Here is some important information you should know.',
    );
  }

  void _showCustomDialog(BuildContext context) {
    CustomDialog.show(
      context: context,
      type: DialogType.custom,
      title: 'Settings',
      content: 'Would you like to enable notifications?',
      icon: Icons.settings,
      backgroundColor: Colors.grey[50],
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications enabled!')),
            );
          },
          child: const Text('Enable'),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    CustomDialog.show(
      context: context,
      type: DialogType.error,
      title: 'Delete Item',
      content:
          'Are you sure you want to delete this item? This action cannot be undone.',
      showCloseButton: false,
      isDismissible: false,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Item deleted!')));
          },
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
