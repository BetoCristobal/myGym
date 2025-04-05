
String asignarEstatus(int diasRestantes, int id) {
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

  return nuevoEstatus;
}