import 'package:flutter/material.dart';
import 'package:my_gym_oficial/providers/cliente_provider.dart';
import 'package:provider/provider.dart';

//VAMOS A INTENTAR SOLO CREAR LA FUNCION SIN STATELESS

void AlertDialogEliminarCliente(BuildContext context, int id) {
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("¿Desea eliminar cliente?"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red
              ),
              onPressed: () async {
                final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
                await clienteProvider.eliminarCliente(id);
                Navigator.pop(context);
              }, 
              child: const Text("Eliminar", style: TextStyle(color: Colors.white),)
            ),
            ElevatedButton(onPressed: () {Navigator.pop(context);}, child: const Text("Cancelar"))
          ],
        ),
      );
    }
  );
}

