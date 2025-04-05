import 'package:my_gym_oficial/data/repositories/cliente_repository.dart';

String asignarEstatus(int diasRestantes, int id) {
  //final clienteRepo = ClienteRepository();
  String nuevoEstatus;

  if(diasRestantes < 0) {
    nuevoEstatus = "vencido";
  } else if(diasRestantes >= 0 && diasRestantes < 1) {
    nuevoEstatus = "urgente";
  } else if(diasRestantes >= 1 && diasRestantes <= 3) {
    nuevoEstatus = "proximo";
  }else {
    nuevoEstatus = "corriente";
  }

  //clienteRepo.updateEstatusCliente(id, nuevoEstatus);
  return nuevoEstatus;
}