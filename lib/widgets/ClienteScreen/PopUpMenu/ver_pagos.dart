import 'package:flutter/material.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';
import 'package:my_gym_oficial/providers/pago_provider.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/card_pagos_cliente.dart';
import 'package:provider/provider.dart';

void VerPagos(BuildContext context, ClienteModel cliente) async {

  final pagoProvider = Provider.of<PagoProvider>(context, listen: false);
  await pagoProvider.cargarPagosClientePorId(cliente.id!);  

  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Pagos de ${cliente.nombres} ${cliente.apellidos}"), 
        content: SizedBox(
          width: double.maxFinite,
          child: Consumer<PagoProvider>(
            builder: (context, pagoProvider, _) {
          
              if(pagoProvider.pagosPorCliente.isEmpty) {                    
                return Text("No hay pagos registrados");                        
              }
          
              return ListView.builder(
                shrinkWrap: true,
                itemCount: pagoProvider.pagosPorCliente.length,
                itemBuilder: (context, index) {
                    
                  //OBTENEMOS EL NUMERO DE PAGO QUE SE MUESTRA EN #
                  int numeroPago = pagoProvider.pagosPorCliente.length - index;
                    
                  final pago = pagoProvider.pagosPorCliente[index];
                  
                  return CardPagosCliente(
                    numeroPago: numeroPago, 
                    pago: pago, 
                    cliente: cliente,
                  );
                },
              );
            }
          ),
        ),
      );
    }
  );
}