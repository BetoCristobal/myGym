import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';
import 'package:my_gym_oficial/styles/text_styles.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/funciones_foto.dart';
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

  String? _fotoPath;
  File? fotoTemporal;

  @override
  void initState() {
    super.initState();
    _fotoPath = widget.estaEditando == true ? widget.cliente?.fotoPath : null;
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
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(widget.estaEditando == false 
                  ? "Agregar cliente" 
                  : "Editar cliente", style: TextStyles.tituloShowModal, ),
                ),

                //BOTON TOMAR FOTO
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [

                        //BOTON TOMAR FOTO-------------------------------------------------------------                       
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              iconColor: Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () async {
                              fotoTemporal = await FuncionesFoto.tomarFotoTemporal();
                        
                              if(fotoTemporal != null) {                                
                                setState(() {
                                  
                                });
                              }
                              print(_fotoPath);
                            }, 
                            child: Icon(Icons.camera_alt, size: 35),
                          ),
                        ),

                        // BOTON ELIMINAR FOTO----------------------------------------------------------
                        if(fotoTemporal != null || _fotoPath != null) 
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              iconColor: Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () async {
                              
                              setState(() {
                                fotoTemporal = null;
                                _fotoPath = null;
                              });
                            }, 
                            child: Icon(Icons.delete_forever_rounded, size: 35),
                          ),
                        ),
                      ],
                    ),
                    // IMAGEN FOTO ----------------------------------------------------------------------
                    fotoTemporal != null
                      ? Image.file(fotoTemporal!, width: 150, height: 150, fit: BoxFit.cover,)
                      : (_fotoPath != null && File(_fotoPath!).existsSync()
                        ? Image.file(File(_fotoPath!), width: 150, height:  150, fit: BoxFit.cover,)
                        : const Icon(Icons.person, size: 150,)
                      )
                  ],
                ),

                // CAMPO NOMBRES
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: nombresController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "Nombres",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1)
                      )
                    ),
                    validator: (value) => 
                      value == null || value.isEmpty ? "Ingrese nombres" : null,
                  ),
                ),
            
                // CAMPO APELLIDOS
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: apellidosController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "Apellidos",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1)
                      )
                    ),
                    validator: (value) => 
                      value == null || value.isEmpty ? "Ingrese apellidos" : null,
                  ),
                ),
            
                // CAMPO TELEFONO
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: telefonoController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Teléfono",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1)
                      )
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return "Ingrese teléfono";
                      } else if(value.length != 10) {
                        return "Ingrese un numero con 10 dígitos";
                      }
                      return null;
                    }
                  ),
                ),                
            
                // BOTON GUARDAR
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 29, 173, 33)
                    ),
                    onPressed: () async {
                      if(formKey.currentState!.validate()) {
                        //OBTENEMOS PROVIDER
                        final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);

                        if (fotoTemporal != null) {
                          _fotoPath = await FuncionesFoto.guardarFoto(fotoTemporal!);
                        }
                        
                        // SI NO ESTA EDITANDO, OSEA SI SE ESTA AGREGANDO NUEVO CLIENTE
                        if(widget.estaEditando == false) {
                          await clienteProvider.agregarCliente(
                            nombresController.text, 
                            apellidosController.text, 
                            telefonoController.text,
                            _fotoPath,                            
                          );

                          Navigator.pop(context);
                        } else if(widget.estaEditando == true) {
                          int? id = widget.cliente?.id;

                          //VERIFICAMOS SI HAY UNA FOTO ANTERIOR, SI SI HAY LA BORRAMOS
                          if(_fotoPath != null && widget.cliente?.fotoPath != null) {
                            if(_fotoPath != widget.cliente!.fotoPath) {
                              final fotoAnterior = File(widget.cliente!.fotoPath!);
                              if(await fotoAnterior.exists()) {
                                await fotoAnterior.delete();
                                print("❌ Foto anterior eliminada: ${widget.cliente!.fotoPath}");
                              } 
                            }
                          } else if (_fotoPath == null && widget.cliente?.fotoPath != null) {
                            final fotoAnterior = File(widget.cliente!.fotoPath!);
                            if(await fotoAnterior.exists()) {
                              await fotoAnterior.delete();
                              print("❌ Foto anterior eliminada: ${widget.cliente!.fotoPath}");
                            }
                          }

                          await clienteProvider.actualizarCliente(
                            id!,
                            nombresController.text, 
                            apellidosController.text, 
                            telefonoController.text,
                            widget.cliente!.estatus,
                            _fotoPath, // Si se actualiza la foto, se pasa la nueva ruta
                          );
                          Navigator.pop(context);
                        }
                      }
                    }, 
                    child: Text(widget.estaEditando == false ? "Guardar cliente" : "Actualizar cliente", style: TextStyle(color: Colors.white),)
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