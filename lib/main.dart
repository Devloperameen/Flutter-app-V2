import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safe/app.dart';
import 'package:safe/bootstrap.dart';
import 'package:safe/core/providers/core_providers.dart';

void main() async {
  final prefs = await bootstrap();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SafeApp(),
    ),
  );
}
