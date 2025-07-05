import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadAppFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();
}

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await loadAppFonts();
  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      ciGoldensConfig: CiGoldensConfig(
        obscureText: false,
        renderShadows: true,
      ),
      platformGoldensConfig: PlatformGoldensConfig(
        enabled: false,
      ),
    ),
    run: testMain,
  );
}
