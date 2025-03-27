import 'package:flutter/material.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';
import 'package:provider/provider.dart';
import '../../providers/cliente_provider.dart';

class FormAgregarEditarCliente extends StatefulWidget {
  final ClienteModel? cliente;
  final bool estaEditando;

  const FormAgregarEditarCliente({super.key, this.cliente, required this.estaEditando});

  @override
  State<FormAgregarEditarCliente> createState() => _FormAgregarEditarClienteState();
}

class _FormAgregarEditarClienteState extends State<FormAgregarEditarCliente> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController nombresController;
  late TextEditingController apellidosController;
  late TextEditingController telefonoController;

  @override
  void initState() {
    super.initState();
    nombresController = TextEditingController(
      text: widget.estaEditando == true ? widget.cliente?.nombres : ""
    );
    apellidosController = TextEditingController(
      text: widget.estaEditando == true ? widget.cliente?.apellidos : ""
    );
    telefonoController = TextEditingController(
      text: widget.estaEditando == true ? widget.cliente?.telefono : ""
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // TITULO
                Text(widget.estaEditando == false ? "Agregar cliente" : "Editar cliente"),
            
                // CAMPO NOMBRES
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: nombresController,
                    decoration: InputDecoration(labelText: "Nombres"),
                    validator: (value) => 
                      value == null || value.isEmpty ? "Ingrese nombres" : null,
                  ),
                ),
            
                // CAMPO APELLIDOS
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: apellidosController,
                    decoration: InputDecoration(labelText: "Apellidos"),
                    validator: (value) => 
                      value == null || value.isEmpty ? "Ingrese apellidos" : null,
                  ),
                ),
            
                // CAMPO TELEFONO
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: telefonoController,
                    decoration: InputDecoration(labelText: "Teléfono"),
                    validator: (value) => 
                      value == null || value.isEmpty ? "Ingrese teléfono" : null,
                  ),
                ),
            
                // BOTON GUARDAR
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      if(formKey.currentState!.validate()) {
                        //OBTENEMOS PROVIDER
                        final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
        
                        // SI NO ESTA EDITANDO, OSEA SI SE ESTA AGREGANDO NUEVO CLIENTE
                        if(widget.estaEditando == false) {
                          await clienteProvider.agregarCliente(
                            nombresController.text, 
                            apellidosController.text, 
                            telefonoController.text
                          );

                          Navigator.pop(context);
                        } else if(widget.estaEditando == true) {
                          int? id = widget.cliente?.id;
                          await clienteProvider.actualizarCliente(
                            id!,
                            nombresController.text, 
                            apellidosController.text, 
                            telefonoController.text,
                            widget.cliente!.estatus,
                          );
                          Navigator.pop(context);
                        }
                      }
                    }, 
                    child: Text(widget.estaEditando == false ? "Guardar" : "Actualizar")
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}