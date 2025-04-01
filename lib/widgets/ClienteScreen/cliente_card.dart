import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';
import 'package:my_gym_oficial/data/models/pago_model.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/alert_dialog_eliminar_cliente.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/form_agregar_editar_pago.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/ver_pagos.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/form_agregar_editar_cliente.dart';

class ClienteCard extends StatelessWidget {
  final ClienteModel cliente;
  final PagoModel ultimoPago;

  const ClienteCard({super.key, required this.cliente, required this.ultimoPago});  

  @override
  Widget build(BuildContext context) {   

    String txtFechaPago;
    String txtProximaFechaPago;
    if(ultimoPago.idCliente != 100000) {
      txtFechaPago = DateFormat("dd-MM-yyyy").format(ultimoPago!.fechaPago);
      txtProximaFechaPago = DateFormat("dd-MM-yyyy").format(ultimoPago!.proximaFechaPago);
    }else {
      txtFechaPago ="-";
      txtProximaFechaPago ="-";
    }

    return Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${cliente.id}.- ${cliente.nombres} ${cliente.apellidos}"),
                      Text(ultimoPago != null ? "Fecha de pago: ${txtFechaPago}" : "Fecha de pago: -"),
                      Text(ultimoPago != null ? "Próxima fecha de pago: ${txtProximaFechaPago}" : "Próxima fecha de pago: -"),
                      Text("Días restantes: 30"), //TODO FALTA CALCULAR DIAS
                    ],
                  ),

                  PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch(value) {
                        case 'ver_informacion':
                          break;  

                        case 'realizar_pago':
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context, 
                            builder: (BuildContext context) {
                              return FormAgregarEditarPago(idCliente: cliente.id!, estaEditando: false,);
                            }
                          );
                          break;

                        case 'ver_pagos':
                          VerPagos(context, cliente);
                          break;

                        case 'enviar_whatsapp':
                          break;

                        case 'editar_cliente':
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context, 
                            builder: (BuildContext context) {
                              return FormAgregarEditarCliente(estaEditando: true, cliente: cliente,);
                            }
                          );
                          break;

                        case 'eliminar_cliente':
                          AlertDialogEliminarCliente(context, cliente.id!);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          //value: ,
                          child: Text("Ver información")
                        ),
                        PopupMenuItem(
                          value: "realizar_pago",
                          child: Text("Realizar pago")
                        ),
                        PopupMenuItem(
                          value: "ver_pagos",
                          child: Text("Ver pagos")
                        ),
                        PopupMenuItem(
                          //value: ,
                          child: Text("Enviar WhatsApp")
                        ),
                        PopupMenuItem(
                          value: "editar_cliente",
                          child: Text("Editar cliente")
                        ),
                        PopupMenuItem(
                          value: 'eliminar_cliente',
                          child: Text("Eliminar cliente")
                        ),
                      ];
                    }
                  ),                  
                ],
              ),
            ),
          );
  }
}