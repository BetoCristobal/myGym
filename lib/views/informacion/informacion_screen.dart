import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';
import 'package:my_gym_oficial/data/models/pago_model.dart';
import 'package:my_gym_oficial/providers/cliente_provider.dart';
import 'package:my_gym_oficial/providers/pago_provider.dart';
import 'package:my_gym_oficial/utils/enviar_whatsapp.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/alert_dialog_eliminar_cliente.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/form_agregar_editar_pago.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/form_agregar_editar_cliente.dart';
import 'package:provider/provider.dart';

class InformacionScreen extends StatefulWidget {

  final int clienteId;
  final PagoModel ultimoPago;

  const InformacionScreen({super.key, required this.clienteId, int? cliente, required this.ultimoPago});

  @override
  State<InformacionScreen> createState() => _InformacionScreenState();
}

class _InformacionScreenState extends State<InformacionScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<PagoProvider>(context, listen: false)
          .cargarPagosClientePorId(widget.clienteId);  }

  @override
  Widget build(BuildContext context) {

    final clienteProvider = Provider.of<ClienteProvider>(context);
    ClienteModel cliente;
    try {
      cliente = clienteProvider.clientes.firstWhere((c) => c.id == widget.clienteId);
    } catch (e) {
      Future.microtask(() {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      });
      return const Scaffold(); // Pantalla vacía temporalmente
    }

    //Al no tener listen: false cuamdo cambia  un pago se reconstruye todo el build
    //si quiero optimizar esta parte necesito poner listen: false y poner consumer a datatble2
    final pagoProvider = Provider.of<PagoProvider>(context);
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Informacion"),
        titleTextStyle: TextStyle(fontSize: 23, color: Colors.white),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20,),
            child: Consumer<ClienteProvider>(
              builder: (context, clienteProvider, _) {
                return Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                              
                      //IMAGEN CLIENTE
                      cliente.fotoPath != null && cliente.fotoPath!.isNotEmpty
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          File(cliente.fotoPath!),
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          ),
                      )
                      : const Icon(Icons.person, size: 150),
                              
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: 
                              Text(
                                "${cliente.nombres} ${cliente.apellidos}", 
                                style: TextStyle(
                                  fontSize: 20, 
                                  fontWeight: FontWeight.bold
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                        
                            //Text("Teléfono: ${widget.cliente.telefono}"),
                  
                            //---------------------------------------------------------BOTON WHATSAPP
                            ElevatedButton.icon(
                              icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.green[900]),
                              onPressed: () {enviarWhatsapp(widget.ultimoPago.proximaFechaPago, cliente.telefono);}, 
                              label: Text("WhatsApp"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[200],
                                foregroundColor: Colors.green[900],
                              ),
                            ),
                  
                            //---------------------------------------------------------BOTON EDITAR CLIENTE
                            ElevatedButton.icon(
                              icon: Icon(FontAwesomeIcons.userPen, color: Colors.blue[900]),
                              onPressed: () {
                                showModalBottomSheet(
                                isScrollControlled: true,
                                context: context, 
                                builder: (BuildContext context) {
                                  return FormAgregarEditarCliente(estaEditando: true, cliente: cliente,);
                                }
                              );
                              }, 
                              label: Text("Editar cliente"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[200],
                                foregroundColor: Colors.blue[900],
                              ),
                            ),
                  
                            //---------------------------------------------------------BOTON ELIMINAR CLIENTE
                            ElevatedButton.icon(
                              icon: Icon(FontAwesomeIcons.xmark, color: Colors.red[900]),
                              onPressed: () async {
                                  final resultado = await AlertDialogEliminarCliente(context, cliente.id!);
                                  if(resultado == true) {
                                    await clienteProvider.eliminarCliente(cliente.id!);
                                    Navigator.of(context).pop();
                                  }
                                }, 
                              label: Text("Eliminar cliente"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[200],
                                foregroundColor: Colors.red[900],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],              
                  ),
                ),
              );
              },            
            ),
          ),
          //---------------------------------------------------------TEXTO INFORMACION ADICIONAL
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text("Pagos"),
          ),
          Expanded(
            child: DataTable2(
              columnSpacing: 10,
              horizontalMargin: 12,
              minWidth: 450,
              columns: [
                DataColumn2(label: Text("Fecha pago:"),),
                DataColumn2(label: Text("Prox. pago:"),),
                DataColumn2(label: Text("Monto:"),),
                DataColumn2(label: Text("Tipo:"),),
                DataColumn2(label: Text("Editar:"), size: ColumnSize.S, numeric: true),
              ], 
              rows: pagoProvider.pagosPorCliente.map((reporte) {
                return DataRow(
                  cells: [
                    DataCell(Text(DateFormat("dd-MM-yyyy").format(reporte.fechaPago))),
                    DataCell(Text(DateFormat("dd-MM-yyyy").format(reporte.proximaFechaPago))),
                    DataCell(Text("\$${reporte.montoPago}")),
                    DataCell(Text(reporte.tipoPago)),
                    DataCell(IconButton(
                      icon: Icon(FontAwesomeIcons.penToSquare, color: Colors.blue[900]),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context, 
                          builder: (BuildContext context) {
                            return FormAgregarEditarPago(
                              idCliente: cliente.id!, 
                              estaEditando: true, 
                              pagoEditar: reporte,
                            );
                          }
                        );
                      },
                    )),
                  ]
                );
              }).toList()
            )
          )
        ],
      ),
    );
  }
}

