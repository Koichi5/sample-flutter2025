import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';

/// Ensures that fonts are loaded correctly for golden tests.
Future<void> loadAppFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();
}

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await loadAppFonts();
  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: false),
    ),
    run: testMain,
  );
}
