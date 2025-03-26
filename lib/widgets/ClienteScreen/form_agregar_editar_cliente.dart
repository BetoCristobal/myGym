import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cliente_provider.dart';

class FormAgregarEditarCliente extends StatelessWidget {

  final bool estaEditando;
  final GlobalKey<FormState> formKey;
  final TextEditingController nombresController;
  final TextEditingController apellidosController;
  final TextEditingController telefonoController;
  //final String? pathFotografiaInicial;

  const FormAgregarEditarCliente({
    super.key,
    required this.estaEditando,
    required this.formKey,
    required this.nombresController,
    required this.apellidosController,
    required this.telefonoController,
    //this.pathFotografiaInicial
  });

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
                Text(estaEditando == false ? "Agregar cliente" : "Editar cliente"),
            
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
                  margin: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () async {
                      if(formKey.currentState!.validate()) {
                        //OBTENEMOS PROVIDER
                        final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
        
                        // SI NO ESTA EDITANDO, OSEA SI SE ESTA AGREGANDO NUEVO CLIENTE
                        if(!estaEditando) {
                          await clienteProvider.agregarCliente(
                            nombresController.text, 
                            apellidosController.text, 
                            telefonoController.text
                          );

                          Navigator.pop(context);
                        } else {
                          //TODO LOGICA ACTUALIZAR CLIENTE
                        }
                      }
                    }, 
                    child: Text(estaEditando == false ? "Guardar" : "Actualizar")
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