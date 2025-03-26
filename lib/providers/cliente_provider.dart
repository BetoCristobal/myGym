import 'package:flutter/material.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';
import 'package:my_gym_oficial/data/repositories/cliente_repository.dart';

class ClienteProvider extends ChangeNotifier{
  //Inyección de Dependencias:
  //Requiere que se pase una instancia de ClienteRepository al crear el Provider.
  final ClienteRepository clienteRepo;

  List<ClienteModel> _clientes = [];

  ClienteProvider(this.clienteRepo) {
    cargarClientes();
  }

  List<ClienteModel> get clientes => _clientes;

  Future<void> cargarClientes() async {    
    try{      
      _clientes = await clienteRepo.getClientes();
      notifyListeners();  
    } catch(e){
      print("❌ Error al cargar clientes: $e");
    }            
  }

  Future<void> agregarCliente(String nombres, String apellidos, String telefono) async {
    try {
      final nuevoCliente = ClienteModel(
      nombres: nombres, 
      apellidos: apellidos, 
      telefono: telefono, 
      estatus: "vencido"
      //Estatus: corriente, vencido, urgente, proximo.
      );
      await clienteRepo.insertCliente(nuevoCliente);
      print("Se agrego cliente a la BD ${nuevoCliente}");
      notifyListeners();
      await cargarClientes();

    }catch(e) {
      print("❌ Error al agregar cliente: $e");
    }
  }

  Future<void> actualizarCliente(ClienteModel cliente) async {
    try {
      await clienteRepo.updateCliente(cliente);      
      notifyListeners();
     } catch(e) {
      print("❌ Error al actualizar cliente: $e");
    }
  }

  Future<void> eliminarCliente(int id) async {
    try{
      await clienteRepo.deleteCliente(id);
      notifyListeners();
      await cargarClientes();
    } catch(e) {
      print("❌ Error al eliminar cliente: $e");
    }    
  }
}