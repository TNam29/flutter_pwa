import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe_book/services/pwa_service.dart';

class PwaControls extends StatefulWidget {
  const PwaControls({super.key});

  @override
  State<PwaControls> createState() => _PwaControlsState();
}

class _PwaControlsState extends State<PwaControls> {
  final bool _online = true;

  @override
  void initState() {
    super.initState();
    // Basic online/offline detection
    if (kIsWeb) {
      // Use browser APIs via dart:html in web implementation if needed
      PwaService.checkServiceWorker();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.download_outlined),
          tooltip: 'Install PWA',
          onPressed: () async {
            await PwaService.installPwa();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            _online ? Icons.wifi : Icons.wifi_off,
            color: _online ? Colors.greenAccent : Colors.redAccent,
          ),
        ),
      ],
    );
  }
}
