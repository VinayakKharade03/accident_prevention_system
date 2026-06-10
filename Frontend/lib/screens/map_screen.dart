import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_windows/webview_windows.dart';

import '../services/api.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final WebviewController controller = WebviewController();

  bool isReady = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initMap();
  }

  Future<void> initMap() async {
    try {
      await controller.initialize();

      final html =
      await rootBundle.loadString('assets/map.html');

      await controller.loadUrl(
        'data:text/html;charset=utf-8,${Uri.encodeComponent(html)}',
      );

      if (!mounted) return;

      setState(() {
        isReady = true;
      });

      startTracking();
    } catch (e) {
      debugPrint("MAP INIT ERROR: $e");
    }
  }

  void startTracking() {
    timer = Timer.periodic(
      const Duration(seconds: 2),
          (_) async {
        try {
          final data = await ApiService.getGps();

          final lat = data["lat"];
          final lon = data["lon"];

          if (lat == null || lon == null) {
            return;
          }

          if (!isReady) return;

          await controller.executeScript(
            "updateLocation($lat, $lon);",
          );
        } catch (e) {
          debugPrint("MAP ERROR: $e");
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isReady
          ? Webview(controller)
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}