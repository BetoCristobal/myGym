import 'package:flutter/material.dart';

class ToggleButtonsProvider extends ChangeNotifier{
  List<bool> isSelected = [true, false, false, false, false];

  void toggleButton(int index){
    for(int i = 0; i < isSelected.length; i++){
      isSelected[i] = false;
    }
    isSelected[index] = true;
    notifyListeners();
  }
}