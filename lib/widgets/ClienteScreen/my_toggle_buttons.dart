import 'package:flutter/material.dart';
import 'package:my_gym_oficial/providers/cliente_provider.dart';
import 'package:my_gym_oficial/styles/text_styles.dart';
import 'package:provider/provider.dart';

class MyToggleButtons extends StatelessWidget {
  const MyToggleButtons({super.key});

  @override
  Widget build(BuildContext context) {

    final toggleProvider = Provider.of<ClienteProvider>(context);

    return Consumer<ClienteProvider>(
              builder: (context, value, child) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: Center(
                    child: ToggleButtons(
                      borderRadius: BorderRadius.circular(10),
                      isSelected: toggleProvider.isSelected,
                      onPressed: (int index) {
                        toggleProvider.toggleButton(index);
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          child: Text("Todos", style: TextStyles.textoToggleButtons,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          child: Text("Vencidos", style: TextStyles.textoToggleButtons,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          child: Text("Urgentes", style: TextStyles.textoToggleButtons,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          child: Text("Próximos", style: TextStyles.textoToggleButtons,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          child: Text("Corrientes", style: TextStyles.textoToggleButtons,),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
  }
}