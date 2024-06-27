

import 'package:flutter/material.dart';

class ExitConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thoát'),
      content: Text('Bạn có muốn thoát khỏi ứng dụng?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Không'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Vâng'),
        ),
      ],
    );
  }
}

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return (await showDialog(
    context: context,
    builder: (context) => ExitConfirmationDialog(),
  )) ??
      false;
}
