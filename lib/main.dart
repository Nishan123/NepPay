import 'package:flutter/material.dart';
import 'package:nep_pay/services/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://yxxsdjbdssokpqxixibt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl4eHNkamJkc3Nva3BxeGl4aWJ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM0ODg3NjUsImV4cCI6MjA1OTA2NDc2NX0.B6nlMFUnIHWz3Iht_ycmoG3TPhzbaqXY5-qqd1F-ryA',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthGate());
  }
}
