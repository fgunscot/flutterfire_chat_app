import 'package:flutter/material.dart';

class ShowAlertDialog extends StatelessWidget {
  const ShowAlertDialog({
    Key? key,
    required this.e,
    required this.title,
  }) : super(key: key);
  final String title;
  final Exception e;
  static const alertDialogKey = Key('alertDialog');
  static const alertDialogAcceptButtonKey = Key('alertDialogAcceptButton');
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: alertDialogKey,
      title: Text(title, style: const TextStyle(fontSize: 24)),
      content: Text('${(e as dynamic).message}'),
      actions: <Widget>[
        TextButton(
          key: alertDialogAcceptButtonKey,
          child: const Text('Accept'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
