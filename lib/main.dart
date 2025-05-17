import 'package:flutter/material.dart';
import 'package:my_gym_oficial/data/repositories/cliente_repository.dart';
import 'package:my_gym_oficial/data/repositories/pago_repository.dart';
import 'package:my_gym_oficial/providers/cliente_provider.dart';
import 'package:my_gym_oficial/providers/pago_provider.dart';
import 'package:my_gym_oficial/providers/reportes_provider.dart';
import 'package:my_gym_oficial/providers/toggle_buttons_provider.dart';
import 'package:my_gym_oficial/views/clientes/clientes_screen.dart';
import 'package:my_gym_oficial/views/reportes/reportes_screen.dart';
import 'package:my_gym_oficial/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ToggleButtonsProvider()),
        ChangeNotifierProvider(create: (_) => ClienteProvider(ClienteRepository())),
        ChangeNotifierProvider(create: (_) => PagoProvider(PagoRepository())), 
        ChangeNotifierProvider(create: (_) => ReportesProvider(PagoRepository(), ClienteRepository())), 
      ],
      child: MyApp(),
    )
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "clientesScreen": (context) => ClientesScreen(),
        "reportesScreen": (context) => ReportesScreen(),
      },
    );
  }
}