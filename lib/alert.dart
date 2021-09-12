import 'package:flutter/material.dart';

enum _AlertAnswer {
  NEXT,
  STOP,
}

class Alert {
  String _value = '';
  void _setValue(String value) => _value = value;

  void openDialog(BuildContext context) {
    showDialog<_AlertAnswer>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text('SimpleDialog'),
        children: <Widget>[
          createDialogOption(context, _AlertAnswer.NEXT, 'NEXT'),
          createDialogOption(context, _AlertAnswer.STOP, 'STOP')
        ],
      ),
    ).then((value) {
      switch (value) {
        case _AlertAnswer.NEXT:
          _setValue('NEXT');
          break;
        case _AlertAnswer.STOP:
          _setValue('STOP');
          break;
        default:
          break;
      }
    });
  }

  SimpleDialogOption createDialogOption(BuildContext context, _AlertAnswer answer, String str) {
    return SimpleDialogOption(
      child: Text(str),
      onPressed: () {
        Navigator.pop(context, answer);
      },
    );
  }
}


// class Alert extends StatefulWidget {
//   const Alert({Key? key}) : super(key: key);

//   @override
//   _AlertState createState() => _AlertState();
// }

// class _AlertState extends State<Alert> {
//   String _value = '';

//   void _setValue(String value) => setState(() => _value = value);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(32.0),
//       child: Center(
//         child: Column(
//           children: <Widget>[
//             Text(
//               _value,
//               style: TextStyle(
//                 fontSize: 50,
//                 color: Colors.blueAccent,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 openDialog(context);
//               },
//               child: Text('ダイアログを開く'),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void openDialog(BuildContext context) {
//     showDialog<_AlertAnswer>(
//       context: context,
//       builder: (BuildContext context) => SimpleDialog(
//         title: Text('SimpleDialog'),
//         children: <Widget>[
//           createDialogOption(context, _AlertAnswer.NEXT, 'NEXT'),
//           createDialogOption(context, _AlertAnswer.STOP, 'STOP')
//         ],
//       ),
//     ).then((value) {
//       switch (value) {
//         case _AlertAnswer.NEXT:
//           _setValue('NEXT');
//           break;
//         case _AlertAnswer.STOP:
//           _setValue('STOP');
//           break;
//         default:
//           break;
//       }
//     });
//   }

//   createDialogOption(BuildContext context, _AlertAnswer answer, String str) {
//     return SimpleDialogOption(
//       child: Text(str),
//       onPressed: () {
//         Navigator.pop(context, answer);
//       },
//     );
//   }
// }
