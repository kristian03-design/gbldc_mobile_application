import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'onboarding_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Outfit',
        primarySwatch: Colors.green,
      ),
      home: const OnboardingScreen(), // ✅ Always show onboarding first
    );
  }
}
