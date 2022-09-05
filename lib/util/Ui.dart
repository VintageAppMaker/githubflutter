
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// progress 보이기
Widget showProgress() =>Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [CircularProgressIndicator()]));

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
            decoration: InputDecoration(hintText: "🔔 please enter github account"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL', style: TextStyle(color: Colors.red),),
              onPressed: () {
                onCancel();
              },
            ),
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.black),),
              onPressed: () {
                onOk();
              },
            ),
          ],
        );
      });
}


// Appbar를 없애면 status 영역까지 침범함을 방지하기 위함
class BlankAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}