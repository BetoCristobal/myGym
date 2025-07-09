import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_gym_oficial/providers/cliente_provider.dart';

/// Función original para asignar estatus
String asignarEstatus(int diasRestantes, int id) {
  String nuevoEstatus;

  if (diasRestantes < 0) {
    nuevoEstatus = "Pago vencido";
  } else if (diasRestantes >= 0 && diasRestantes < 1) {
    nuevoEstatus = "Pago urgente";
  } else if (diasRestantes >= 1 && diasRestantes <= 3) {
    nuevoEstatus = "Próximo a pagar";
  } else {
    nuevoEstatus = "Pago al corriente";
  }

  return nuevoEstatus;
}

/// Función para agregar 100 clientes
Future<void> agregarClientesDePrueba(BuildContext context) async {
  final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
  final random = Random();

  final nombres = ["Luis", "María", "Juan", "Ana", "Carlos", "Laura", "Pedro", "Elena", "Miguel", "Sofía"];
  final apellidos = ["Pérez", "García", "Rodríguez", "López", "Martínez", "Hernández", "Gómez", "Sánchez", "Romero", "Vargas"];

  for (int i = 0; i < 100; i++) {
    final nombre = nombres[random.nextInt(nombres.length)];
    final apellido = apellidos[random.nextInt(apellidos.length)];

    // Generar número de teléfono de 10 dígitos
    final telefono = '5' + (random.nextInt(1000000000) + 100000000).toString().padLeft(9, '0');

    // Simular días restantes entre -5 y 10
    final diasRestantes = random.nextInt(16) - 5; // valores de -5 a 10
    final estatus = asignarEstatus(diasRestantes, i + 1);

    await clienteProvider.agregarCliente(
      nombre,
      apellido,
      telefono,
      null, // Sin foto
    );

    print("✅ Cliente agregado: $nombre $apellido | Tel: $telefono | Estatus: $estatus");
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Se agregaron 100 clientes de prueba")),
  );
}
