import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gym_oficial/data/models/pago_model.dart';
import 'package:my_gym_oficial/providers/cliente_provider.dart';
import 'package:my_gym_oficial/providers/pago_provider.dart';
import 'package:my_gym_oficial/styles/text_styles.dart';
import 'package:my_gym_oficial/utils/asignar_estatus.dart';
import 'package:my_gym_oficial/utils/calcular_dias_restantes.dart';
import 'package:my_gym_oficial/utils/seleccionar_fecha.dart';
import 'package:provider/provider.dart';

class FormAgregarEditarPago extends StatefulWidget {
  final int idCliente;
  final PagoModel? pagoEditar;
  final bool estaEditando;

  const FormAgregarEditarPago({super.key, required this.idCliente, required this.estaEditando, this.pagoEditar});

  @override
  State<FormAgregarEditarPago> createState() => _FormAgregarEditarPagoState();
}

class _FormAgregarEditarPagoState extends State<FormAgregarEditarPago> {

  final GlobalKey<FormState> formKeyPagos = GlobalKey<FormState>();
  TextEditingController montoController = TextEditingController();

  DateTime? fechaPago;
  String txtFechaPago = "Seleccionar"; 
  DateTime? fechaProximoPago;
  String txtFechaProximoPago = 'Seleccionar';

  final List<String> options = ['Efectivo', 'Tarjeta', 'Transferencia'];
  String? valorDropDownButton;

  @override
  void initState() {
    super.initState();
    if(widget.estaEditando == true) {
      montoController = TextEditingController(text: widget.pagoEditar!.montoPago.toString());

      valorDropDownButton = widget.pagoEditar!.tipoPago;

      fechaPago = widget.pagoEditar!.fechaPago;
      fechaProximoPago = widget.pagoEditar!.proximaFechaPago;

      txtFechaPago = DateFormat("dd-MM-yyyy").format(fechaPago!);
      txtFechaProximoPago = DateFormat("dd-MM-yyyy").format(fechaProximoPago!);
    }
  }
  @override
  Widget build(BuildContext context) {

final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);


    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: formKeyPagos,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(widget.estaEditando == false 
                  ? "Realizar pago:" 
                  : "Actualizar último pago:", style: TextStyles.tituloShowModal, ),
                ),
            
                //CAMPO MONTO
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: montoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Monto"),
                    validator: (value) =>
                      value == null || value.isEmpty ? "Ingrese monto" : null,
                  ),
                ),
            
                //LISTA DROPDOWN TIPO PAGO
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButton<String>(
                    hint: const Text("Elige una forma de pago"),
                    value: valorDropDownButton,
                    items: options.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(), 
                    onChanged: (String? newValue) {
                      setState(() {
                        valorDropDownButton = newValue;
                      });
                    }
                  ),
                ),
            
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //FECHA PAGO
                      Column(
                        children: [
                          const Text("Fecha de pago:"),                          
                          ElevatedButton(
                            onPressed: () async {
                              fechaPago = await seleccionarFecha(context);
                              if(fechaPago != null){
                                setState(() {
                                  txtFechaPago = DateFormat("dd-MM-yyyy").format(fechaPago!);
                                });
                              }
                            }, 
                            child: Text(txtFechaPago)
                          ),  
                        ],
                      ),
                              
                      //FECHA PROXIMO PAGO
                      Column(
                        children: [
                          const Text("Próximo pago:"),                              
                          ElevatedButton(
                            onPressed: () async {
                              fechaProximoPago = await seleccionarFecha(context);
                              if(fechaProximoPago != null) {
                                setState(() {
                                  txtFechaProximoPago = DateFormat('dd-MM-yyyy').format(fechaProximoPago!);
                                });
                              }
                            }, 
                            child: Text(txtFechaProximoPago)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                                            

                      if(formKeyPagos.currentState!.validate() && fechaPago != null && fechaProximoPago != null && valorDropDownButton != null) {
                        final pagoProvider = Provider.of<PagoProvider>(context, listen: false);
                        int diasRestantes = calcularDiasRestantes(fechaProximoPago!);
                        String estatus = asignarEstatus(diasRestantes, widget.idCliente);
                      
                        if(widget.estaEditando == false) {
                          await pagoProvider.agregarPago(
                            widget.idCliente, 
                            double.parse(montoController.text), 
                            fechaPago!, 
                            fechaProximoPago!, 
                            valorDropDownButton!
                          );
                          await clienteProvider.actualizarEstatusCliente(widget.idCliente, estatus);
                          Navigator.pop(context);
                        } else if(widget.estaEditando == true) {
                          await pagoProvider.actualizarPago(
                            widget.pagoEditar!.id!, 
                            widget.pagoEditar!.idCliente, 
                            double.parse(montoController.text), 
                            fechaPago!, 
                            fechaProximoPago!, 
                            valorDropDownButton!
                          );
                          await clienteProvider.actualizarEstatusCliente(widget.idCliente, estatus);
                          Navigator.pop(context);
                        }
                      } else {
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Advertencia:"),
                              content: const Text("Debe ingresar monto, tipo de pago y fechas.")
                            );
                          }
                        );
                      }
                    }, 
                    child: Text(widget.estaEditando == false ? "Guardar" : "Actualizar")
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}