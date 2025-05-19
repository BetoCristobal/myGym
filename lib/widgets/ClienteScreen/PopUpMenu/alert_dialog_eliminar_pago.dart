import 'package:flutter/material.dart';
import 'package:my_gym_oficial/providers/pago_provider.dart';
import 'package:provider/provider.dart';

void AlertDialogEliminarPago(BuildContext context, int idPago, int idCliente) {
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("¿Desea eliminar pago?"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: () async {
              final pagoProvider = Provider.of<PagoProvider>(context, listen: false);
              await pagoProvider.eliminarPago(idPago, idCliente);
              Navigator.pop(context);
            }, 
              child: Text("Eliminar")),
            ElevatedButton(onPressed: () {Navigator.pop(context);}, child: const Text("Cancelar"))
          ],
        ),
      );
    }
  );
}