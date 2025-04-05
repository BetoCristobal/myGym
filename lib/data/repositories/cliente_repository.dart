import 'package:my_gym_oficial/data/db/database_helper.dart';
import 'package:my_gym_oficial/data/models/cliente_model.dart';

class ClienteRepository {

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertCliente(ClienteModel cliente) async {
    final db = await _dbHelper.database;
    print(cliente);
    await db.insert('clientes', cliente.toMap());
  }

  //En esta línea de código en Flutter, el parámetro conflictAlgorithm especifica 
  //cómo manejar conflictos cuando se intenta insertar un registro que ya existe 
  //en la base de datos (por ejemplo, si hay una clave primaria duplicada).

  //SI USAMOS REPLACE REEMPLAZA EN CASO DE CONFLICTO
//-----------------------------------------------------------------------------------

  Future<List<ClienteModel>> getClientes() async {
    final db= await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('clientes');
    return maps.map((map) => ClienteModel.fromMap(map)).toList();
  }

  //Flujo completo
  //Consulta SQL: Obtiene todas las filas de la tabla clientes como una lista de Maps.

  //Transformación: Convierte cada Map en un objeto ClienteModel.

  //Retorno: Devuelve la lista de clientes como Future<List<ClienteModel>>.

  //---------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------

  Future<List<ClienteModel>> getClientesOrdenadosById() async {
    final db= await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('clientes', orderBy: 'id DESC');
    return maps.map((map) => ClienteModel.fromMap(map)).toList();
  }

  //Flujo completo
  //Consulta SQL: Obtiene todas las filas de la tabla clientes como una lista de Maps.

  //Transformación: Convierte cada Map en un objeto ClienteModel.

  //Retorno: Devuelve la lista de clientes como Future<List<ClienteModel>>.

  //---------------------------------------------------------------------------------

  Future<void> updateCliente(ClienteModel cliente) async {
    final db= await _dbHelper.database;
    await db.update(
      'clientes', 
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id]
    );
    print("SE ACTUALIZO EL CLIENTE");
  }

  Future<void> updateEstatusCliente(int id, String nuevoEstatus) async {
    final db = await _dbHelper.database;
    await db.update(
      'clientes', 
      {'estatus': nuevoEstatus},
      where: 'id = ?',
      whereArgs: [id]
    );
  }


  Future<void> deleteCliente(int id) async {
    final db= await _dbHelper.database;
    await db.delete('clientes', where: 'id = ?', whereArgs: [id]);
  }

}