// Web implementation using dart:html and JS interop
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/foundation.dart';

class PwaService {
  static bool get isPwa {
    try {
      return html.window.matchMedia('(display-mode: standalone)').matches ||
          html.window.matchMedia('(display-mode: fullscreen)').matches ||
          html.window.matchMedia('(display-mode: minimal-ui)').matches;
    } catch (e) {
      return false;
    }
  }

  static Future<void> installPwa() async {
    // The install prompt is controlled from index.html. We call a JS function
    // that shows the deferred prompt if available.
    try {
      if (js.context.hasProperty('showInstallPrompt')) {
        js.context.callMethod('showInstallPrompt');
      }
    } catch (_) {}
  }

  static Future<void> checkServiceWorker() async {
    try {
      if (html.window.navigator.serviceWorker != null) {
        await html.window.navigator.serviceWorker!
              .register('/sw.js')
              .then((reg) => debugPrint('SW registered: ${reg.scope}'));
      }
    } catch (e) {
        debugPrint('Service Worker registration failed: $e');
    }
  }
}
