import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';
import 'package:my_gym_oficial/providers/pago_provider.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/PopUpMenu/form_agregar_editar_pago.dart';
import 'package:provider/provider.dart';

void VerPagos(BuildContext context, ClienteModel cliente) async {

  final pagoProvider = Provider.of<PagoProvider>(context, listen: false);
  await pagoProvider.cargarPagosClientePorId(cliente.id!);  

  bool mostrarTextButtons = pagoProvider.pagosPorCliente.isEmpty ? false : true;

  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Pagos de ${cliente.nombres} ${cliente.apellidos}"), //TODO necesitamos nombre cliente
        content: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //ENCABEZADO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("#"), Text("Pago:"), Text("Vence:"), Text("Monto:"), Text("Tipo:")
                ],
              ),
          
              Expanded(
                child: Consumer<PagoProvider>(
                  builder: (context, PagoProvider, _) {
                
                    if(pagoProvider.pagosPorCliente.isEmpty) {                    
                      return const Center(child: Text("No hay pagos registrados"),);                        
                    }
                
                    return ListView.builder(
                      itemCount: pagoProvider.pagosPorCliente.length,
                      itemBuilder: (context, index) {

                        mostrarTextButtons = true;

                        final pago = pagoProvider.pagosPorCliente[index];
                        String txtFechaPago = DateFormat("dd-MM-yy").format(pago.fechaPago);
                        String txtFechaProximoPago = DateFormat("dd-MM-yy").format(pago.proximaFechaPago);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //ID pago por cliente
                            Text((pago.id).toString()),
                    
                            //FECHA PAGO
                            Text(txtFechaPago),

                            //FECHA PROXIMO PAGO
                            Text(txtFechaProximoPago),

                            //MONTO
                            Text((pago.montoPago).toString()),

                            //TIPO PAGO
                            Text(pago.tipoPago),
                          ]                    
                        );
                      },
                    );
                  }
                ),
              ),

              //TextButtons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: mostrarTextButtons,
                    child: TextButton(
                      onPressed: () {

                        final ultimoPago = pagoProvider.pagosPorCliente.isNotEmpty
                          ? pagoProvider.pagosPorCliente.first
                          : null;

                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context, 
                          builder: (BuildContext context) {
                            return FormAgregarEditarPago(
                              idCliente: cliente.id!, 
                              estaEditando: true, 
                              pagoEditar: ultimoPago,
                            );
                          }
                        );
                      }, 
                      child: Text("Editar último pago"),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: Text("Cerrar"),
                  ),
              ],),       
            ],
          ),
        ),
      );
    }
  );
}