import 'dart:async';

import 'package:flutter/material.dart';

import '../services/api.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  List<dynamic> objects = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();

    fetchData();

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => fetchData(),
    );
  }

  Future<void> fetchData() async {
    try {
      final data = await ApiService.getLive();

      if (!mounted) return;

      setState(() {
        objects = data["objects"] ?? [];
      });
    } catch (e) {
      debugPrint("LOG ERROR: $e");
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Logs"),
      ),
      body: objects.isEmpty
          ? const Center(
        child: Text(
          "No objects detected",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: objects.length,
        itemBuilder: (context, i) {
          final obj = objects[i];

          final label =
              obj["label"]?.toString() ?? "Unknown";

          final distance =
              obj["distance"]?.toString() ?? "0";

          final risk =
              obj["risk"]?.toString() ?? "SAFE";

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: const Icon(
                Icons.warning_amber_rounded,
              ),
              title: Text(label),
              subtitle: Text(
                "Distance: $distance m",
              ),
              trailing: Text(
                risk,
                style: TextStyle(
                  color: risk == "COLLISION"
                      ? Colors.red
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}