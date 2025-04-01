import 'package:flutter/material.dart';
import 'package:nep_pay/views/auth/login_screen.dart';
import 'package:nep_pay/views/home/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final snapshot = Supabase.instance.client.auth.currentSession;
        if (snapshot != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
