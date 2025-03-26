import 'package:flutter/material.dart';
import 'package:my_gym_oficial/providers/cliente_provider.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/barra_busqueda.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/cliente_card.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/form_agregar_editar_cliente.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/my_toggle_buttons.dart';
import 'package:provider/provider.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {    
    final clienteProvider = Provider.of<ClienteProvider>(context);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final nombresController = TextEditingController();
    final apellidosController = TextEditingController();
    final telefonoController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes"),
        actions: [
          //TODO: Dar acciones a botones de Appbar
          IconButton(onPressed: () {
            
          }, 
          icon: Icon(Icons.bar_chart), color: Colors.white,),
          IconButton(onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context, 
              builder: (BuildContext context) {
                return FormAgregarEditarCliente(
                  estaEditando: false,
                  formKey: formKey,
                  nombresController: nombresController,
                  apellidosController: apellidosController,
                  telefonoController: telefonoController,
                );
              }
            );
          }, 
          icon: Icon(Icons.person_add), color: Colors.white,)
        ],
        titleTextStyle: TextStyle(fontSize: 23, color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          //BARRA BUSQUEDA--------------------------------------------------------------------------
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: BarraBusqueda()
          ),

          //FILTROS CLIENTES----------------------------------------------------------------------
          Container(
            child: MyToggleButtons()
          ),

          //LISTVIEW------------------------------------------------------------------------------------
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: Consumer<ClienteProvider>(
                builder: (context, ClienteProvider, _) {
                  
                  if(clienteProvider.clientes.isEmpty) {
                    return const Center(child: Text("No hay clientes registrados"),);
                  }
            
                  return ListView.builder(
                    itemCount: clienteProvider.clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = clienteProvider.clientes[index];
                      return ClienteCard(cliente: cliente,);
                    }
                  );
            
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}