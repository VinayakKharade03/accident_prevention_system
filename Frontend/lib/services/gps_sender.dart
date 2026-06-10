import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'api.dart';

class GpsSender {
  Timer? _timer;

  Future<void> start() async {
    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      print("GPS SERVICE DISABLED");
      return;
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
      await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      print("LOCATION PERMISSION DENIED");
      return;
    }

    if (permission ==
        LocationPermission.deniedForever) {
      print("LOCATION PERMISSION DENIED FOREVER");
      return;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 2),
          (_) async {
        try {
          Position pos =
          await Geolocator.getCurrentPosition(
            desiredAccuracy:
            LocationAccuracy.high,
          );

          await ApiService.sendGps(
            pos.latitude,
            pos.longitude,
          );

          print(
            "GPS SENT => "
                "${pos.latitude}, ${pos.longitude}",
          );
        } catch (e) {
          print("GPS ERROR: $e");
        }
      },
    );
  }

  void stop() {
    _timer?.cancel();
  }
}