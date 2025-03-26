class PagoModel {
  int id;
  int idCliente;
  int montoPago;
  DateTime fechaPago;
  DateTime proximaFechaPago;
  String tipoPago;

  PagoModel({
    required this.id,
    required this.idCliente,
    required this.montoPago,
    required this.fechaPago,
    required this.proximaFechaPago,
    required this.tipoPago,
  });

  // Pago -> Map Para leerlo en la UI
  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'idCliente': idCliente,
      'montoPago': montoPago,
      'fechaPago': fechaPago,
      'proximaFechaPago': proximaFechaPago,
      'tipoPago': tipoPago
    };
  }

  //Map -> Pago, para guardar en BD
  factory PagoModel.fromMap(Map<String, dynamic> map){
    return PagoModel(
      id: map['id'], 
      idCliente: map['idCliente'], 
      montoPago: map['montoPago'], 
      fechaPago: map['fechaPago'], 
      proximaFechaPago: map['proximaFechaPago'], 
      tipoPago: map['tipoPago']
    );
  }
}