import 'package:flutter/material.dart';

LinearGradient asignarColorFondoCardCliente(String estatus) {

  LinearGradient gradient;
  
  late Color color1 = Colors.white;
  late Color color2 = Colors.white;

  switch(estatus) {
    case 'vencido':
      color1 = Color.fromARGB(255, 122, 122, 122);
      color2 = Color.fromARGB(255, 168, 168, 168);
      break;

    case 'urgente':
      color1 = Color.fromARGB(255, 209, 17, 17);
      color2 = Color.fromRGBO(255, 87, 87, 1);
      break;

    case 'proximo':
      color1 = Color.fromARGB(255, 223, 164, 1);
      color2 = Color.fromARGB(255, 255, 230, 1);
      break;

    case 'corriente':
      color1 = Color.fromARGB(255, 0, 139, 0);
      color2 = Color.fromARGB(255, 0, 253, 42);
      break;
  } 

  
  return gradient = LinearGradient(
    colors: [color1, color2],
    begin: Alignment.topLeft, 
    end: Alignment.bottomRight
  );
}