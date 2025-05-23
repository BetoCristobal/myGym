import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';
import 'package:my_gym_oficial/data/models/pago_model.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/alert_dialog_eliminar_pago.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/form_agregar_editar_pago.dart';

class CardPagosCliente extends StatelessWidget {
  final int numeroPago;
  final ClienteModel cliente;
  final PagoModel pago;  

  CardPagosCliente({super.key, required this.numeroPago, required this.pago, required this.cliente});

  @override
  Widget build(BuildContext context) {
    String txtFechaPago = DateFormat("dd-MM-yy").format(pago.fechaPago);
    String txtFechaProximoPago = DateFormat("dd-MM-yy").format(pago.proximaFechaPago);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

        /* Cuando metes una column a un Row, el column no toma la altura disponible, siempre se centra
            Para ocupar la altura disponible por los hijos del Row de usa IntrinsicHeight
         */
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //# PAGO
              Center(child: Text("$numeroPago"),),

              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text("Fecha pago:"),
                        Text("Próx. pago:"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(txtFechaPago),                  
                        Text(txtFechaProximoPago)
                      ],
                    ),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("\$${pago.montoPago}"),
                        Text(pago.tipoPago)
                      ],
                    ),
                  ],
                ),
              ),          
          
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: (value) async {
                  switch (value) {
                    case "editar_pago":
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context, 
                          builder: (BuildContext context) {
                            return FormAgregarEditarPago(
                              idCliente: cliente.id!, 
                              estaEditando: true, 
                              pagoEditar: pago,
                            );
                          }
                        );
                      break;
          
                    case "eliminar_pago":
                      AlertDialogEliminarPago(context, pago.id!, cliente.id!);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: "editar_pago",
                      child: const Text("Editar pago")
                    ),
          
                    PopupMenuItem(
                      value: "eliminar_pago",
                      child: const Text("Eliminar pago")
                    ),
                  ];
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}