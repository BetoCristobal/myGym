String asignarEstatus(int diasRestantes) {

  if(diasRestantes < 0) {
    return "vencido";
  } else if(diasRestantes >= 0 && diasRestantes < 1) {
    return "urgente";
  } else if(diasRestantes >= 1 && diasRestantes <= 3) {
    return "proximo";
  }else {
    return "corriente";
  }
}