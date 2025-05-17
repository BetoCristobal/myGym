import 'package:flutter/material.dart';
import 'package:my_gym_oficial/views/clientes/clientes_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ClientesScreen())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final desiredWidth = screenWidth * 0.7;

    return Container(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Center(
        child: Image.asset(
          'assets/logo.png',
          width: desiredWidth,
        ),
      ),
    );
  }
}