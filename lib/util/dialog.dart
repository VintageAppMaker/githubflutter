
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// 계정입력 input dialog
Future<void> askAccountDialog(BuildContext context, Function onChanged, Function onCancel, Function onOk ) async {
  TextEditingController _textFieldController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('account'),
          content: TextField(
            onChanged: (value) {
              onChanged(value);
            },
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "please enter github account"),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('CANCEL'),
              onPressed: () {
                onCancel();
              },
            ),
            FlatButton(
              color: Colors.black,
              textColor: Colors.white,
              child: Text('OK'),
              onPressed: () {
                onOk();
              },
            ),
          ],
        );
      });
}