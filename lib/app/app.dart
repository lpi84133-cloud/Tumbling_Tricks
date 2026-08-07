import 'package:flutter/material.dart';

import '../design/theme.dart';
import 'router.dart';

/// Root widget.
class TumblingTricksApp extends StatelessWidget {
  const TumblingTricksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tumbling Tricks',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      routerConfig: appRouter,
      // The app is English-only by design, so no localisation delegates and no
      // locale-dependent layout.
      builder: (BuildContext context, Widget? child) {
        // Type scale is a deliberate part of the layout; allow the system text
        // size to influence it, but not enough to break the run-order rows.
        final MediaQueryData media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: media.textScaler.clamp(
              minScaleFactor: 0.9,
              maxScaleFactor: 1.3,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
