import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // =====================================================
  // BACKEND URL
  // =====================================================
  // Current PC WiFi IP:
  // YOUR_SERVER_IP
  //
  // Make sure FastAPI runs with:
  // uvicorn app.main:app --host 0.0.0.0 --port 8000
  // =====================================================

  static const String baseUrl = "http://YOUR_SERVER_IP:8000";

  // =====================================================
  // SEND GPS (Android)
  // =====================================================

  static Future<void> sendGps(
      double lat,
      double lon,
      ) async {
    try {
      await http.post(
        Uri.parse("$baseUrl/gps"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "lat": lat,
          "lon": lon,
        }),
      );
    } catch (e) {
      print("GPS SEND ERROR: $e");
    }
  }

  // =====================================================
  // GET GPS (Dashboard / Map)
  // =====================================================

  static Future<Map<String, dynamic>> getGps() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/gps"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("GPS FETCH ERROR: $e");
    }

    return {
      "lat": null,
      "lon": null,
      "timestamp": null,
    };
  }

  // =====================================================
  // LIVE DETECTION DATA
  // =====================================================

  static Future<Map<String, dynamic>> getLive() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/live"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("LIVE ERROR: $e");
    }

    return {
      "online": false,
      "objects": [],
      "collision": false,
      "gps": {
        "lat": null,
        "lon": null,
        "timestamp": null,
      }
    };
  }

  // =====================================================
  // VIDEO STREAM URL
  // =====================================================

  static String get videoUrl =>
      "$baseUrl/video-ui";

  // =====================================================
  // GPS API URL
  // =====================================================

  static String get gpsUrl =>
      "$baseUrl/gps";

  // =====================================================
  // LIVE API URL
  // =====================================================

  static String get liveUrl =>
      "$baseUrl/live";
}