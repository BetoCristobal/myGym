import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gym_oficial/providers/reportes_provider.dart';
import 'package:my_gym_oficial/styles/text_styles.dart';
import 'package:my_gym_oficial/utils/pdf_utils.dart';
import 'package:my_gym_oficial/widgets/ClienteScreen/container_total_tipo_pago.dart';
import 'package:my_gym_oficial/widgets/Reportes%20Screen/form_aplicar_filtros.dart';
import 'package:provider/provider.dart';

/*
TODO NOTA SUPER IMPORTANTES

Su usamos STATELESSWIDGET se mete provider y lo que usa context dentro de build

El error ocurre porque Provider.of<PagoProvider>(context) debe 
ser ejecutado dentro del ciclo de vida de un widget. En un StatelessWidget, 
context no está disponible fuera de build(), por eso la mejor práctica es 
usar StatefulWidget si necesitas hacer alguna inicialización.
*/

class ReportesScreen extends StatefulWidget {
  ReportesScreen({
    super.key,
  });

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ReportesProvider>(context, listen: false).reiniciarFiltros();
  }

  @override
  Widget build(BuildContext context) {
    final reportesProvider = Provider.of<ReportesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportes"),
        titleTextStyle: TextStyle(fontSize: 23, color: Colors.white),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [

          // ICONO PARA REINICIAR FILTROS
          IconButton(
            highlightColor: Colors.white38,
            onPressed: () {
            Provider.of<ReportesProvider>(context, listen: false).reiniciarFiltros();}, icon: const Icon(Icons.restart_alt)
          ),

          // ICONO APLICAR FILTROS
          IconButton(
            highlightColor: Colors.white38,
            onPressed: () {
            showModalBottomSheet(
              context: context, 
              builder: (BuildContext context) {
                return FormAplicarFiltros();
              }
            );
          }, icon: const Icon(Icons.filter_alt_outlined)),

          // ICONO GENERAR PDF
          IconButton(
            highlightColor: Colors.white38,
            onPressed: () async {
              final provider = Provider.of<ReportesProvider>(context, listen: false);
              await exportarReportePDFYGuardarEnDescargas(provider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("✅ PDF guardado en Descargas")),
              );
            }, 
            icon: const Icon(Icons.picture_as_pdf)
          ),
        ],
      ),
      body: Column(
              //crossAxisAlignment: CrossAxisAlignment.end, 
              children: [
                //Texto TOTAL - FECHAS - TIPO PAGO
                Text(reportesProvider.txtFechaInicioFiltro == null 
                  ? "Resultados no filtrados" 
                  : "Del  ${reportesProvider.txtFechaInicioFiltro}  al  ${reportesProvider.txtFechaFinFiltro}", style: TextStyles.textoFiltros),
                  Text("Tipo de pago: ${reportesProvider.txtTipoPago}", style: TextStyles.textoFiltros,),
                Text("Total: \$ ${reportesProvider.sumaPagos.toStringAsFixed(2)}", style: TextStyles.textoTotal,),

                // TOTALES POR TIPO DE PAGO
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ContainerTotalTipoPago(
                        tipoPago: "Efectivo",
                        totalPorTipo: reportesProvider.totalEfectivo,
                        porcentaje: reportesProvider.porcentajeEfectivo, 
                        colorFondo: Colors.blue,
                      ),
                      ContainerTotalTipoPago(
                        tipoPago: "Transferencia", 
                        totalPorTipo: reportesProvider.totalTransferencia,
                        porcentaje: reportesProvider.porcentajeTransferencia, 
                        colorFondo: Colors.green,
                      ),
                      ContainerTotalTipoPago(
                        tipoPago: "Tarjeta",
                        totalPorTipo: reportesProvider.totalTarjeta,
                        porcentaje: reportesProvider.porcentajeTarjeta,  
                        colorFondo: Colors.red,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: DataTable2(
                    columnSpacing: 10,
                    horizontalMargin: 12,
                    minWidth: 450,
                    columns: [
                      //DataColumn(label: Text("#")),
                      DataColumn2(label: Text("Cliente:")),
                      DataColumn2(label: Text("Fecha:"), ),
                      DataColumn2(label: Text("Monto:"), size: ColumnSize.S),
                      DataColumn2(label: Text("Tipo:"),),
                    ], 
                    rows: reportesProvider.reportesMostrar.map((reporte) {
                      
                      final txtFechaPago = DateFormat("dd-MM-yyyy").format(reporte.fechaPago);
                      return DataRow(
                        cells: [
                          DataCell(Text(reporte.nombreCliente)),
                          DataCell(Text(txtFechaPago)),
                          DataCell(Text("\$${reporte.montoPago}")),
                          DataCell(Text(reporte.tipoPago)),
                        ]
                      );
                    }).toList()
                  ),
                ),
              ]
            )
    );
  }     
}