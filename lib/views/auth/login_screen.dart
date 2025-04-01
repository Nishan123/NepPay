import 'package:flutter/material.dart';
import 'package:nep_pay/controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("NepPay\nVery Simple Payment Gateway",textAlign: TextAlign.center,),
            ElevatedButton(
              onPressed: () {
                AuthController().googleSignIn();
              },
              child: Text("Login With Google"),
            ),
          ],
        ),
      ),
    );
  }
}
