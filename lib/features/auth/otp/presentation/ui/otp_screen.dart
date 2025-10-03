import 'package:flutter/material.dart';
import '../widgets/otp_screen_body.dart';

class OtpScreen extends StatelessWidget {
  final String email;
  
  const OtpScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6), // Light green background from Figma
     
      body: SafeArea(
        child: SingleChildScrollView(
          child: OtpScreenBody(email: email),
        ),
      ),
    );
  }
}