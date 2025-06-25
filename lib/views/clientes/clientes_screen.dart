import 'package:flutter/material.dart';
import 'package:my_gym_oficial/data/models/pago_model.dart';
import 'package:my_gym_oficial/providers/cliente_provider.dart';
import 'package:my_gym_oficial/providers/pago_provider.dart';
import 'package:my_gym_oficial/views/pruebas/ver_fotos.dart';
import 'package:my_gym_oficial/views/reportes/reportes_screen.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/barra_busqueda.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/cliente_card.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/form_agregar_editar_cliente.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/my_toggle_buttons.dart';
import 'package:provider/provider.dart';

class ClientesScreen extends StatefulWidget {
  final bool isFreeVersion;
  const ClientesScreen({super.key, required this.isFreeVersion});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {

  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Provider.of<PagoProvider>(context, listen: false).cargarPagosTodosById();
  }

  void _unfocusTextField() {
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {    
    return GestureDetector(
      onTap: _unfocusTextField,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 0, 0, 0),
              const Color.fromARGB(255, 83, 83, 83),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(widget.isFreeVersion ? "Clientes - Version gratuita" : "Clientes"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VerFotos()));
                }, 
                icon: Icon(Icons.photo_album)),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReportesScreen()));
                }, 
                icon: const Icon(Icons.bar_chart), color: Colors.white,),
              IconButton(
                onPressed: () {
                  final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
        
                  //VERIFICAR SI ALCNZASTE REGISTROS MAXIMO VERSION GRATUITA
                  if(widget.isFreeVersion && clienteProvider.clientes.length >= 7){
                    showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Advertencia"),
                                  content: Text("Solo puedes registrar a 7 clientes en la version gratuita"),
                                );
                              }
                            );
                  } else {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context, 
                      builder: (BuildContext context) {
                        return FormAgregarEditarCliente(estaEditando: false,);
                      }  
                    );
                  }              
                }, 
                icon: const Icon(Icons.person_add), color: Colors.white,)
            ],
            titleTextStyle: TextStyle(fontSize: 23, color: Colors.white),
            backgroundColor: Colors.black,
          ),
          body: Column(
            children: [
              //BARRA BUSQUEDA--------------------------------------------------------------------------
              Consumer<ClienteProvider>(
                builder: (context, clienteProvider, _) {
                  bool desactivarBarraBusqueda = true;
        
                  if(clienteProvider.isSelected[0] != true) {
                    desactivarBarraBusqueda = false;
                  }
        
                  return Container(
                    padding: EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
                    child: BarraBusqueda(
                      desactivarBarraBusqueda: desactivarBarraBusqueda,
                      onSearchChanged: (value) {
                        clienteProvider.filtrarClientesPorNombresApellidos(value);
                      },
                      focusNode: _searchFocusNode
                    )
                  );
                },
              ),
        
              //FILTROS CLIENTES----------------------------------------------------------------------
              Container(
                padding: EdgeInsets.only(top: 10),
                child: MyToggleButtons()
              ),
        
              //LISTVIEW------------------------------------------------------------------------------------
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Consumer2<ClienteProvider, PagoProvider>(
                    builder: (context, clienteProvider, pagoProvider, _) {                  
                      
                      if(clienteProvider.clientes.isEmpty) {
                        return const Center(child: Text("No hay clientes registrados"),);
                      }
                
                      return ListView.builder(
                        itemCount: clienteProvider.clientesFiltrados.length,
                        itemBuilder: (context, index) {
                          final cliente = clienteProvider.clientesFiltrados[index];
        
                          final ultimoPago = pagoProvider.pagos.firstWhere(
                            (pago) => pago.idCliente == cliente.id,
                            orElse: () => PagoModel(
                              idCliente: 100000, 
                              montoPago: 0, 
                              fechaPago: DateTime(1900), 
                              proximaFechaPago: DateTime(1900), 
                              tipoPago: "ninguno"),
                          );          
                      
                          return ClienteCard(cliente: cliente, ultimoPago: ultimoPago,);
                        }
                      );            
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}