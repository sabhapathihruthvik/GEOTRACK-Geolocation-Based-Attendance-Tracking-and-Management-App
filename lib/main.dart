import 'package:attendance_tracking_system/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AttendanceTrackingApp());
}

class AttendanceTrackingApp extends StatelessWidget {
  const AttendanceTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Tracking System',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const AuthScreen(),
    );
  }
}
