import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/orientation.dart';
import 'design/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Both orientations are permitted for the launch sequence; the app locks to
  // portrait as soon as bootstrap reports it is done.
  await OrientationPolicy.allowLaunchOrientations();
  SystemChrome.setSystemUIOverlayStyle(AppTheme.overlayStyle);

  runApp(const ProviderScope(child: TumblingTricksApp()));
}
