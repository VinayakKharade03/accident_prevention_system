import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

import '../services/api.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final WebviewController controller = WebviewController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      await controller.initialize();

      await controller.setBackgroundColor(
        const Color(0xFF000000),
      );

      await controller.loadUrl(
        ApiService.videoUrl,
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    } catch (e) {
      debugPrint("VIDEO ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Webview(controller),
          ),

          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}