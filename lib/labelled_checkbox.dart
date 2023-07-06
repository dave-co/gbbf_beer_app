import 'package:flutter/material.dart';

class LabelledCheckbox extends StatelessWidget{

  const LabelledCheckbox({
    super.key,
    required this.text,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  final Text text;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

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
              value: value,
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