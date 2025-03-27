import 'package:flutter/material.dart';

class FormAgregarEditarPago extends StatefulWidget {

  final bool estaEditando;

  const FormAgregarEditarPago({super.key, required this.estaEditando});

  @override
  State<FormAgregarEditarPago> createState() => _FormAgregarEditarPagoState();
}

class _FormAgregarEditarPagoState extends State<FormAgregarEditarPago> {

  final List<String> options = ['Efectivo', 'Tarjeta', 'Transferencia'];
  String? valorDropDownButton;

  TextEditingController montoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
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
                            onPressed: () {}, 
                            child: Text(widget.estaEditando == false ? "Seleccionar" : "")
                          ),  
                        ],
                      ),
                              
                      //FECHA PROXIMO PAGO
                      Column(
                        children: [
                          Text("Próximo pago:"),
                              
                          ElevatedButton(
                            onPressed: () {}, 
                            child: Text(widget.estaEditando == false ? "Seleccionar" : "")
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {}, 
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