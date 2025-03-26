import 'package:flutter/material.dart';

class BarraBusqueda extends StatelessWidget {
  const BarraBusqueda({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
              decoration: InputDecoration(
                labelText: "Buscar...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              onChanged: (value) {}, //TODO: FALTA DAR ACCIONES A ESTA PARTE DE BUSQUEDA FILTRADA
            );
  }
}