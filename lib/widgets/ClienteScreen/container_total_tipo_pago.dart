import 'package:flutter/material.dart';

class ContainerTotalTipoPago extends StatelessWidget {
  Color colorFondo;

  ContainerTotalTipoPago({super.key, required this.colorFondo});

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              color:  colorFondo,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                Text("Tipo pago", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                Text("\$ 21212122", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
              ],
            ),
          );
  }
}