import 'package:flutter/material.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';
import 'package:my_gym_oficial/data/repositories/cliente_repository.dart';

enum Opciones {todos, vencidos, urgentes, proximos, corrientes}

class ClienteProvider extends ChangeNotifier{
  //Inyección de Dependencias:
  //Requiere que se pase una instancia de ClienteRepository al crear el Provider.
  final ClienteRepository clienteRepo;

  List<ClienteModel> _clientes = [];
  List<ClienteModel> _clientesFiltrados = [];
  String _busqueda = "";
  

  ClienteProvider(this.clienteRepo) {
    cargarClientes();
  }

  List<ClienteModel> get clientes => _clientes;
  List<ClienteModel> get clientesFiltrados => _clientesFiltrados;
  String get busqueda => _busqueda;

  Future<void> cargarClientes() async {    
    try{      
      _clientes = await clienteRepo.getClientesOrdenadosById();
      aplicarFiltro();
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
      //notifyListeners();
      await cargarClientes();

    }catch(e) {
      print("❌ Error al agregar cliente: $e");
    }
  }

  Future<void> actualizarCliente(int id, String nombres, String apellidos, String telefono, String estatus) async {
    try {
      final clienteActualizado = ClienteModel(
        id: id,
        nombres: nombres, 
        apellidos: apellidos, 
        telefono: telefono, 
        estatus: estatus
      );
      await clienteRepo.updateCliente(clienteActualizado);      
      //notifyListeners();
      await cargarClientes();
    } catch(e) {
      print("❌ Error al actualizar cliente: $e");
    }
  }

  Future<void> actualizarEstatusCliente(int id, String estatus) async {
    try{
      await clienteRepo.updateEstatusCliente(id, estatus);
      //notifyListeners();
      await cargarClientes();
    } catch(e){
      print("❌ Error al actualizar ESTATUS: $e");
    }
  }

  Future<void> eliminarCliente(int id) async {
    try{
      await clienteRepo.deleteCliente(id);
      //notifyListeners();
      await cargarClientes();
    } catch(e) {
      print("❌ Error al eliminar cliente: $e");
    }    
  }

  
  Opciones opcionesView = Opciones.todos;
  List<bool> isSelected = [true, false, false, false, false];

  void toggleButton(int index){
    for(int i = 0; i < isSelected.length; i++){
      isSelected[i] = (i == index);
    }
    opcionesView = Opciones.values[index];
    cargarClientes();
    notifyListeners();
  }

  void aplicarFiltro() {
    switch(opcionesView) {
      case Opciones.todos:
        _clientesFiltrados = List.from(_clientes);
      break;

      case Opciones.vencidos:
        _clientesFiltrados = _clientes.where((c) => c.estatus == "vencido").toList();
      break;

      case Opciones.urgentes:
        _clientesFiltrados = _clientes.where((c) => c.estatus == "urgente").toList();
      break;

      case Opciones.proximos:
        _clientesFiltrados = _clientes.where((c) => c.estatus == "proximo").toList();
      break;

      case Opciones.corrientes:
        _clientesFiltrados = _clientes.where((c) => c.estatus == "corriente").toList();
      break;
    }
    notifyListeners();
  }

  String normalizar(String texto) {
    final withTilde = texto.toLowerCase();
    const acentos = 'áéíóúüñ';
    const sinAcentos = 'aeiouun';

    String result = '';
    for (int i = 0; i < withTilde.length; i++) {
      int index = acentos.indexOf(withTilde[i]);
      result += (index >= 0) ? sinAcentos[index] : withTilde[i];
    }
    return result;
  }

  void filtrarClientesPorNombresApellidos(String query) {
    _busqueda = query;
    if(query.isEmpty) {
      aplicarFiltro();
    } else {
      //final lowerCaseQuery = query.toLowerCase();
      final listaBase = _clientes;
      _clientesFiltrados = listaBase.where((cliente) {
        final nombreCompleto = normalizar('${cliente.nombres} ${cliente.apellidos}');
        final consulta = normalizar(query);
        return nombreCompleto.contains(consulta);
      }).toList();
      notifyListeners();
    }
  }
}