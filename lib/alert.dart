import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class StopOrNextAlert {
  bool answer = false; //ダイアログを閉じる時にどちらを押したかを保持

  Future<void> timeIsUpAlert(BuildContext context) async {
    AudioPlayer _audioPlayer = AudioPlayer(); //オーディオ再生で使うインスタンス
    await _audioPlayer.setUrl('assets/hato1.mp3'); //再生ファイルをセット
    await _audioPlayer.setReleaseMode(ReleaseMode.LOOP); //再生モードを設定
    await _audioPlayer.resume(); //再生
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
                _audioPlayer.stop(); //オーディオ停止
              },
            ),
            TextButton(
              child: const Text('NEXT'),
              onPressed: () {
                Navigator.of(context).pop(); //ダイアログを閉じる
                answer = true;
                _audioPlayer.stop(); //オーディオ停止
              },
            ),
          ],
        );
      },
    );
  }
}
