class ClienteModel {
  int? id;
  String nombres;
  String apellidos;
  String telefono;
  String estatus;
  String? fotoPath;

  ClienteModel({
    this.id,
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    required this.estatus,
    this.fotoPath,
  });

  //Cliente -> Map
  //Metodo para insertar a base de datos
  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'estatus': estatus,
      'fotoPath': fotoPath
    };
  }

  // Map -> Cliente
  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'], 
      nombres: map['nombres'], 
      apellidos: map['apellidos'], 
      telefono: map['telefono'], 
      estatus: map['estatus'],
      fotoPath: map['fotoPath']
      );
  }
}
