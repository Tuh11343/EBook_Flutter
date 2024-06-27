import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  String labelText;
  TextEditingController controller;
  bool obscureText;
  bool isNumber;
  String prefixIcon;

  MyTextField(
      {required this.labelText,
      required this.controller,
      required this.obscureText,
      required this.isNumber,
      required this.prefixIcon});

  @override
  State<StatefulWidget> createState() {
    return MyTextFieldState();
  }
}

class MyTextFieldState extends State<MyTextField> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText && !_show,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      keyboardType: widget.isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.7),
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
        fillColor: Colors.white,
        filled: true,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(_show ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _show = !_show;
                  });
                },
              )
            : null,
        prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Image.asset(
              widget.prefixIcon,
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            )),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}
