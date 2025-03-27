import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gym_oficial/data/models/pago_model.dart';
import 'package:my_gym_oficial/providers/pago_provider.dart';
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
    /*
    montoController = TextEditingController(
      text: widget.estaEditando == true ? widget.pagoEditar?.montoPago.toString() : "");
    fechaPago = widget.estaEditando == true ? widget.pagoEditar?.fechaPago : null;
    fechaProximoPago = widget.estaEditando == true ? widget.pagoEditar?.proximaFechaPago : null;
    */
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: formKeyPagos,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(widget.estaEditando == false ? "Realizar pago:" : "Actualizar último pago:"),
            
                //CAMPO MONTO
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: montoController,
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
                          Text("Fecha de pago:"),                          
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
                          Text("Próximo pago:"),                              
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
                        if(widget.estaEditando == false) {
                          await pagoProvider.agregarPago(
                            widget.idCliente, 
                            double.parse(montoController.text), 
                            fechaPago!, 
                            fechaProximoPago!, 
                            valorDropDownButton!
                          );
                          Navigator.pop(context);
                        } else if(widget.estaEditando == true) {
                          await pagoProvider.actualizarUltimoPago(
                            widget.pagoEditar!.id!, 
                            widget.pagoEditar!.idCliente!, 
                            double.parse(montoController.text), 
                            fechaPago!, 
                            fechaProximoPago!, 
                            valorDropDownButton!
                          );
                          Navigator.pop(context);
                        }
                      } else {
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Advertencia:"),
                              content: Text("Debe ingresar monto, tipo de pago y fechas.")
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