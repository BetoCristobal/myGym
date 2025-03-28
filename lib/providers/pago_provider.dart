import 'package:flutter/material.dart';
import 'package:my_gym_oficial/data/models/pago_model.dart';
import '../data/repositories/pago_repository.dart';

class PagoProvider extends ChangeNotifier {
  final PagoRepository pagoRepo;

  PagoProvider(this.pagoRepo);

  List<PagoModel> _pagos = [];
  List<PagoModel> _pagosPorCliente = [];

  List<PagoModel> get pagos => _pagos;
  List<PagoModel> get pagosPorCliente => _pagosPorCliente;

  Future<void> cargarPagosTodosById() async {
    try{
      _pagos = await pagoRepo.getPagosTodosOrdenadosById();
      notifyListeners();
      print("✅Se obtuvieron todos los pagos");
    } catch(e) {
      print("❌ Error al cargar todos pagos: $e");
    }
  }

  Future<void> cargarPagosClientePorId(int idCliente) async {
    try{
      _pagosPorCliente = await pagoRepo.getPagosPorIdCliente(idCliente);
      notifyListeners();
      print("✅Se obtuvieron los pagos POR CLIENTE");
    } catch(e){
      print("❌ Error al cargar los PAGOS POR CLIENTE: $e");
    }
  }

  Future<void> agregarPago(int idCliente, double monto, DateTime fechaPago, DateTime proximaFechaPago, String tipoPago) async {
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

  Future<void> actualizarUltimoPago(int id, int idCliente, double monto, DateTime fechaPago, DateTime proximaFechaPago, String tipoPago) async {
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
      await cargarPagosClientePorId(idCliente);
    } catch(e) {
      print("❌Error al actualizar pago: $e");
    }
  }

  Future<void> eliminarPago(int id, int idCliente) async {
    try{
      await pagoRepo.deletePago(id);
      notifyListeners();
      await cargarPagosClientePorId(idCliente);      
    }catch(e) {
      print("❌ Error al eliminar pago: $e");
    }
  }
}