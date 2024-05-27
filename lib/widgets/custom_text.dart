import 'package:flutter/material.dart';

class CustomText extends StatelessWidget{
  final String text;
  final Style style;
  final double textSize;
  final Color textColor;

  const CustomText({super.key, required this.text,required this.textSize,required this.style,required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
      fontSize: textSize,
      fontFamily: 'Poppins',
      color: textColor,
      fontWeight: style == Style.bold ? FontWeight.bold : FontWeight.normal,
      overflow: TextOverflow.ellipsis,
      fontStyle: FontStyle.normal,
    ),);


  }
}

enum Style{
  normal,bold
}