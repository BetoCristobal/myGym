import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';
import 'package:my_gym_oficial/data/models/pago_model.dart';
import 'package:my_gym_oficial/providers/pago_provider.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/alert_dialog_eliminar_pago.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/form_agregar_editar_pago.dart';
import 'package:provider/provider.dart';

class CardPagosCliente extends StatelessWidget {
  int numeroPago;
  ClienteModel cliente;
  PagoModel pago;  

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
          
              //DATOS FECHAS PAGO
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fecha pago:"),
                  Text("${txtFechaPago}"),
                  Text("Próximio pago:"),
                  Text("${txtFechaProximoPago}")
                ],
              ),
          
              //DATOS MONTO - TIPO
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${pago.montoPago}"),
                  Text("${pago.tipoPago}")
                ],
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
                      child: Text("Editar pago")
                    ),
          
                    PopupMenuItem(
                      value: "eliminar_pago",
                      child: Text("Eliminar pago")
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