import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({Key? key}) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

enum _TimeModeState {
  study,
  rest,
}

class _CountDownTimerState extends State<CountDownTimer> {
  String _timeModeStr = "STUDY TIME";
  var _studytimer; //Timer型
  int _studyTimeHour = 0; //勉強したいHour
  int _studyTimeMinute = 0; //勉強したいMinute
  int _studyTimeSec = 2; //勉強したいSecond
  DateTime _studytime = DateTime.utc(0, 0, 0);
  bool _isStartButtonDisable = false; //スタートボタンが無効かどうか
  bool _isStopButtonDisable = true; //ストップボタンが無効がどうか

  @override
  void initState() {
    //初期化処理
    _studytime = _studytime.add(Duration(
      hours: _studyTimeHour,
      minutes: _studyTimeMinute,
      seconds: _studyTimeSec,
    ));
    super.initState();
  }

  void _onTimer() {
    // タイマー起動
    setState(() {
      //状態を変更
      _isStartButtonDisable = true;
      _isStopButtonDisable = false;
    });

    _studytimer = Timer.periodic(
      //タイマー開始
      Duration(seconds: 1), //一秒ごとに関数を実行
      (Timer timer) {
        setState(() {
          //状態を変更
          if (_studytime == DateTime.utc(0, 0, 0)) {
            //時間が0になったら
            _offTimer(); //タイマーストップ
            _resetTime(); //時間をリセット
            return; //関数終わり
          }
          _studytime = _studytime.add(Duration(seconds: -1));
        });
      },
    );
    return;
  }

  void _offTimer() {
    //タイマーストップ
    setState(() {
      _isStopButtonDisable = true;
      _isStartButtonDisable = false;
      if (_studytimer != null && _studytimer.isActive)
        _studytimer.cancel(); //タイマーストップ
    });
    return;
  }

  void _resetTime() {
    //時間をリセットする
    _studytime = _studytime.add(Duration(
      hours: _studyTimeHour,
      minutes: _studyTimeMinute,
      seconds: _studyTimeSec,
    ));
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        //勉強の時間なのか,休憩時間なのか表示
        "$_timeModeStr",
        style: Theme.of(context).textTheme.headline3,
      ),
      Text(
        //時間を表示
        DateFormat.Hms().format(_studytime),
        style: Theme.of(context).textTheme.headline1,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            //ストップボタン
            child: const Icon(Icons.pause),
            style: ElevatedButton.styleFrom(),
            onPressed: _isStopButtonDisable
                ? null
                : () {
                    _offTimer();
                  },
          ),
          ElevatedButton(
            //スタートボタン
            child: const Icon(Icons.play_arrow),
            style: ElevatedButton.styleFrom(),
            onPressed: _isStartButtonDisable
                ? null
                : () {
                    _onTimer();
                  },
          ),
        ],
      ),
    ]);
  }
}
