import 'package:flutter/material.dart';

class StopOrNextAlert {
  bool answer = false;
  Future<void> timeIsUpAlert(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('TIME IS UP'),
          actions: <Widget>[
            TextButton(
              child: const Text('STOP'),
              onPressed: () {
                Navigator.of(context).pop(); //ダイアログを閉じる
                answer = false;
              },
            ),
            TextButton(
              child: const Text('NEXT'),
              onPressed: () {
                Navigator.of(context).pop(); //ダイアログを閉じる
                answer = true;
              },
            ),
          ],
        );
      },
    );
  }
}
