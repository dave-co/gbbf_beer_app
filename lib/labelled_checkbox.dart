import 'package:flutter/material.dart';

class LabelledCheckbox extends StatelessWidget{

  const LabelledCheckbox({
    super.key,
    required this.text,
    required this.padding,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.black54
  });

  final Text text;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Checkbox(
              side: BorderSide(color: inactiveColor, width: 2),
              value: value,
              activeColor: activeColor,
              onChanged: (bool? newValue){
                onChanged(newValue!);
              }
            ),
            text,
          ]
        )
      )
    );
  }

}