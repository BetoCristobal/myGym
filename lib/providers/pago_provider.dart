import 'package:flutter/material.dart';
import 'package:my_gym_oficial/data/models/pago_model.dart';
import '../data/repositories/pago_repository.dart';

class PagoProvider extends ChangeNotifier {
  final PagoRepository pagoRepo;

  PagoProvider(this.pagoRepo);

  List<PagoModel> _pagos = [];

  List<PagoModel> get pagos => _pagos;

  Future<void> cargarPagosTodosById() async {
    try{
      _pagos = await pagoRepo.getPagosTodosOrdenadosById();
    } catch(e) {
      print("❌ Error al cargar clientes: $e");
    }
  }

  Future<void> agregarPago(int idCliente, int monto, DateTime fechaPago, DateTime proximaFechaPago, String tipoPago) async {
    try{
      final nuevoPago = PagoModel(
        idCliente: idCliente, 
        montoPago: monto, 
        fechaPago: fechaPago, 
        proximaFechaPago: proximaFechaPago, 
        tipoPago: tipoPago
      );
      await pagoRepo.insertPago(nuevoPago);
      print("✅Se agrego nuevo pago: $nuevoPago");
    }catch(e) {
      print("❌Error al agregar pago: $e");
    }
  }

  Future<void> actualizarUltimoPago(int id, int idCliente, int monto, DateTime fechaPago, DateTime proximaFechaPago, String tipoPago) async {
    try{
      final pagoActualizado = PagoModel(
        id: id,
        idCliente: idCliente, 
        montoPago: monto, 
        fechaPago: fechaPago, 
        proximaFechaPago: proximaFechaPago, 
        tipoPago: tipoPago
      );
      await pagoRepo.updatePago(pagoActualizado);
      notifyListeners();
      //TODO CREO QUE AQUI NECESITO ACTUALIZAR UI CUANDO SE VEANM LOS PAGOS POR CLIENTE
      //TODO => FALTA CARGAR PAGOS
    } catch(e) {
      print("❌Error al actualizar pago: $e");
    }
  }

  Future<void> eliminarPago(int id) async {
    try{
      await pagoRepo.deletePago(id);
      notifyListeners();
      //TODO CREO QUE AQUI NECESITO ACTUALIZAR UI CUANDO SE VEANM LOS PAGOS POR CLIENTE
      //TODO => FALTA CARGAR PAGOS
    }catch(e) {
      print("❌ Error al eliminar pago: $e");
    }
  }
}