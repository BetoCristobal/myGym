import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';
import 'package:my_gym_oficial/data/models/pago_model.dart';
import 'package:my_gym_oficial/providers/cliente_provider.dart';
import 'package:my_gym_oficial/styles/text_styles.dart';
import 'package:my_gym_oficial/utils/asignar_color_fondo_card_cliente.dart';
import 'package:my_gym_oficial/utils/asignar_emoji.dart';
import 'package:my_gym_oficial/utils/asignar_estatus.dart';
import 'package:my_gym_oficial/utils/calcular_dias_restantes.dart';
import 'package:my_gym_oficial/utils/enviar_whatsapp.dart';
import 'package:my_gym_oficial/views/informacion/informacion_screen.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/alert_dialog_eliminar_cliente.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/form_agregar_editar_pago.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/ver_pagos.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/form_agregar_editar_cliente.dart';
import 'package:provider/provider.dart';

class ClienteCard extends StatelessWidget {
  final ClienteModel cliente;
  final PagoModel ultimoPago;

  const ClienteCard({super.key, required this.cliente, required this.ultimoPago});  

  @override
  Widget build(BuildContext context) {   

    String txtFechaPago;
    String txtProximaFechaPago;
    if(ultimoPago.idCliente != 100000) {
      txtFechaPago = DateFormat("dd-MM-yyyy").format(ultimoPago.fechaPago);
      txtProximaFechaPago = DateFormat("dd-MM-yyyy").format(ultimoPago.proximaFechaPago);
    }else {
      txtFechaPago ="Falta pago";
      txtProximaFechaPago ="Falta pago";
    }

    int diasRestantes = calcularDiasRestantes(ultimoPago.proximaFechaPago);
    String estatus = asignarEstatus(diasRestantes, cliente.id!);

    if(cliente.estatus != estatus)  {
      final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
      clienteProvider.actualizarEstatusCliente(cliente.id!, estatus);
    }
    
    LinearGradient fondoCard = asignarColorFondoCardCliente(estatus);
    String emoji = asignarEmoji(estatus);
    
    return Card(
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                gradient: fondoCard
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(emoji),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Text("${cliente.nombres} ${cliente.apellidos}", 
                            style: TextStyles.textoCardCliente,
                            softWrap: true,
                            maxLines: 2,                            
                          ),
                        ),
                      ],
                    ),                    
                                
                    Divider(color: Colors.white, height: 5,),                    
                                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pago: $txtFechaPago", style: TextStyles.textoCardCliente),
                            Text("Prox. pago: $txtProximaFechaPago", style: TextStyles.textoCardCliente),
                            Visibility(visible: ultimoPago.idCliente == 100000 ? false : true, 
                              child: Text('Días restantes: $diasRestantes', style: TextStyles.textoCardCliente)), 
                            //Text('Estatus: ${cliente.estatus}', style: TextStyles.textoCardCliente,)
                          ],
                        ),

                        PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      onSelected: (value) async {
                        switch(value) {
                          case 'ver_informacion':
                            //alertDialogVerInformacion(context, cliente);
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => InformacionScreen(clienteId: cliente.id!, ultimoPago: ultimoPago,)));
                            // print("✅✅✅✅✅✅$result");
                            // if(result is int) {
                            //   final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
                            //   await clienteProvider.eliminarCliente(result);
                            // } 
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
                  
                          // case 'ver_pagos':
                          //   VerPagos(context, cliente);
                          //   break;
                  
                          // case 'enviar_whatsapp':
                          //   enviarWhatsapp(ultimoPago.proximaFechaPago, cliente.telefono);
                          //   break;
                  
                          // case 'editar_cliente':
                          //   showModalBottomSheet(
                          //     isScrollControlled: true,
                          //     context: context, 
                          //     builder: (BuildContext context) {
                          //       return FormAgregarEditarCliente(estaEditando: true, cliente: cliente,);
                          //     }
                          //   );
                          //   break;
                  
                          case 'eliminar_cliente':
                            AlertDialogEliminarCliente(context, cliente.id!);
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: "ver_informacion",
                            child: Text("Ver información")
                          ),
                          PopupMenuItem(
                            value: "realizar_pago",
                            child: Text("Realizar pago")
                          ),
                          // PopupMenuItem(
                          //   value: "ver_pagos",
                          //   child: Text("Ver pagos")
                          // ),
                          // PopupMenuItem(
                          //   value: "enviar_whatsapp",
                          //   child: Text("Enviar WhatsApp")
                          // ),
                          // PopupMenuItem(
                          //   value: "editar_cliente",
                          //   child: Text("Editar cliente")
                          // ),
                          PopupMenuItem(
                            value: 'eliminar_cliente',
                            child: Text("Eliminar cliente")
                          ),
                        ];
                      }
                    ),
                      ],
                    ), 
                  ],
                ),
              ),
            ),
          );
  }
}