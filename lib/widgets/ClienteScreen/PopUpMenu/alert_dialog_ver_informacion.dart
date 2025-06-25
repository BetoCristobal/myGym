import 'dart:io';

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
            cliente.fotoPath != null && cliente.fotoPath!.isNotEmpty
              ? Image.file(
                File(cliente.fotoPath!),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
              : const Icon(Icons.person, size: 100),
            Text("Teléfono: ${cliente.telefono}")
          ],
        ),
      );
    }
  );
}