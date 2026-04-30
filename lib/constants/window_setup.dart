import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowSetup {
  static Future<void> configure() async {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(1200, 600), // increased width
      size: Size(1200, 800),
      center: true,
      title: "GetShot",
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  static Future<void> lockResize(bool value) async {
    await windowManager.setResizable(!value);
  }
}
