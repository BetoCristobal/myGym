import 'package:flutter/material.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';

void alertDialogVerInformacion(BuildContext context, ClienteModel cliente) {
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("${cliente.nombres} ${cliente.apellidos}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Teléfono: ${cliente.telefono}")
          ],
        ),
      );
    }
  );
}