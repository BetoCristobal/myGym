import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gym_oficial/providers/reportes_provider.dart';
import 'package:my_gym_oficial/styles/text_styles.dart';
import 'package:my_gym_oficial/utils/seleccionar_fecha.dart';
import 'package:provider/provider.dart';

class FormAplicarFiltros extends StatefulWidget {
  const FormAplicarFiltros({super.key});

  @override
  State<FormAplicarFiltros> createState() => _FormAplicarFiltrosState();
}

class _FormAplicarFiltrosState extends State<FormAplicarFiltros> {

  final GlobalKey<FormState> formFiltro = GlobalKey<FormState>();

  final List<String> options = ['Todos', 'Efectivo', 'Tarjeta', 'Transferencia'];
  String? valorDropDownButton;

  DateTime? fechaInicio;
  String txtFechaInicio = "Seleccionar";
  DateTime? fechaFin;
  String txtFechaFin = "Seleccionar";

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: formFiltro,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Aplicar filtro:", style: TextStyles.tituloShowModal,  ),
              ),

              //LISTA DROPDOWN
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: DropdownButton<String>(
                  hint: Text("Elige una forma de pago"),
                  value: valorDropDownButton,
                  items: options.map((String option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option)
                    );
                  }).toList(), 
                  onChanged: (String? newValue) {
                    setState(() {
                      valorDropDownButton = newValue;
                    });
                  }
                ),
              ),

              //FECHAS
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //FECHA INICIO
                    Column(
                      children: [
                        Text("Fecha inicio:"),
                        ElevatedButton(
                          onPressed: () async {
                            fechaInicio = await seleccionarFecha(context);
                            if(fechaInicio != null) {
                              setState(() {
                                txtFechaInicio = DateFormat('dd-MM-yyyy').format(fechaInicio!);
                              });
                            }
                          }, 
                          child: Text(txtFechaInicio)
                        )
                      ],
                    ),

                    //FECHA FIN
                    Column(
                      children: [
                        Text("Fecha fin:"),
                        ElevatedButton(
                          onPressed: () async {
                            fechaFin = await seleccionarFecha(context);
                            if(fechaFin != null && fechaFin!.isAfter(fechaInicio!)) {
                              setState(() {
                                txtFechaFin = DateFormat('dd-MM-yyyy').format(fechaFin!);
                              });
                            } else {
                              showDialog(
                                context: context, 
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Advertencia"),
                                    content: Text("La fecha fin debe ser posterior a la fecha inicio."),
                                  );
                                }
                              );
                            }
                          }, 
                          child: Text(txtFechaFin)
                        )
                      ],
                    )
                  ],
                ),
              ),

              //BOTON APLICAR
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if(fechaInicio != null && fechaFin != null && valorDropDownButton != null) {
                      print("FILTROS APLICADOS");
                      if(valorDropDownButton == "Todos") {
                        Provider.of<ReportesProvider>(context, listen: false).cargarReportesFiltradosTodosPorFecha(fechaInicio!, fechaFin!);
                        Navigator.pop(context);
                      } else {
                        Provider.of<ReportesProvider>(context, listen: false).cargarReportesFiltrados(valorDropDownButton!, fechaInicio!, fechaFin!);
                       Navigator.pop(context);
                      }                      
                    } else {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Advertencia"),
                            content: Text("Debe seleccionar los campos para aplicar filtro."),
                          );
                        }
                      );
                    }
                  }, 
                  child: Text("Aplicar")
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}