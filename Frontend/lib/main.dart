import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'services/gps_sender.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );

    print("✅ Supabase Initialized");
    print("✅ URL: ${SupabaseConfig.url}");
  } catch (e, stackTrace) {
    print("❌ Supabase Init Error");
    print("Type: ${e.runtimeType}");
    print("Error: $e");
    print(stackTrace);
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    GpsSender().start();
  }

  runApp(const AccidentApp());
}

class AccidentApp extends StatelessWidget {
  const AccidentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Accident Prevention System",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
      ),
      home: user == null
          ? const AuthScreen()
          : const HomeScreen(),
    );
  }
}