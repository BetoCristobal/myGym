import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gym_oficial/providers/pago_provider.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/container_total_tipo_pago.dart';
import 'package:provider/provider.dart';

/*
TODO NOTA SUPER IMPORTANTES

Su usamos STATELESSWIDGET se mete provider y lo que usa context dentro de build

El error ocurre porque Provider.of<PagoProvider>(context) debe 
ser ejecutado dentro del ciclo de vida de un widget. En un StatelessWidget, 
context no está disponible fuera de build(), por eso la mejor práctica es 
usar StatefulWidget si necesitas hacer alguna inicialización.
*/


class ReportesScreen extends StatelessWidget {
  ReportesScreen({super.key,});

  @override
  Widget build(BuildContext context) {

    final pagoProvider = Provider.of<PagoProvider>(context, listen: false);
    pagoProvider.cargarPagosTodosById();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportes"),
        titleTextStyle: TextStyle(fontSize: 23, color: Colors.white),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.restart_alt)
          ),
          
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.filter_alt_outlined)
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          //Texto TOTAL - FECHAS - TIPO PAGO
          Text("Total: \$ 21231213212"),

          // TOTALES POR TIPO DE PAGO
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContainerTotalTipoPago(colorFondo: Colors.blue,),
                ContainerTotalTipoPago(colorFondo: Colors.green,),
                ContainerTotalTipoPago(colorFondo: Colors.red,),
              ],
            ),
          ),

          //LISTVIEW PAGOS
          Expanded(
            child: Consumer<PagoProvider>(
              builder: (context, pagoProvider, _) {
                if(pagoProvider.pagos.isEmpty) {
                  return const Center(child: Text("No hay pagos registrados"),);
                }
            
                return ListView.builder(
                  itemCount: pagoProvider.pagos.length,
                  itemBuilder: (context, index) {
            
                    //OBTENEMOS EL NUMERO DE PAGO QUE SE MUESTRA EN #
                    int numeroPago = pagoProvider.pagos.length - index;
            
                    final pago = pagoProvider.pagos[index];
                    String txtFechaPago = DateFormat("dd-MM-yyyy").format(pago.fechaPago);
            
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //#
                        Text(("$numeroPago")),
                      
                        //FECHA PAGO
                        Text(txtFechaPago),
            
                        //MONTO
                        Text((pago.montoPago).toString()),
            
                        //TIPO PAGO
                        Text(pago.tipoPago),

                        //NOMBRES CLIENTE
                        Text("Pedro Alberto"),
                      ],
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}