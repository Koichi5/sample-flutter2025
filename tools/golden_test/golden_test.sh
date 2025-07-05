#!/bin/bash

# Golden Test 実行用スクリプト
# 使用方法:
#   ./tools/golden_test/golden_test.sh create WeatherView lib/weather/widgets/weather_view.dart
#   ./tools/golden_test/golden_test.sh run
#   ./tools/golden_test/golden_test.sh run test/weather/widgets/weather_view_golden_test.dart

dart tools/golden_test/simple_golden_test.dart "$@"