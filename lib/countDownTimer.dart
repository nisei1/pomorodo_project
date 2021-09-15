import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:pomorodo_project/alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({Key? key}) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

//タイマーモードを切り替える用 列挙体
enum _TimeModeState {
  study,
  rest,
}

class _CountDownTimerState extends State<CountDownTimer> {
  String _timerModeStr = ""; //勉強時間か休憩時間か表示用変数
  late Timer _timer; //Timer型
  _TimeModeState _mode = _TimeModeState.study;

  DateTime _setTime = DateTime.utc(0, 0, 0); //使用する時間を代入するための変数
  //勉強時間設定に使う変数
  int _studyTimeHour = 0; //勉強したいHour
  int _studyTimeMinute = 0; //勉強したいMinute
  int _studyTimeSec = 3; //勉強したいSecond
  DateTime _studyTime = DateTime.utc(0, 0, 0); //勉強する時間
  //休憩時間設定に使う変数
  int _restTimeHour = 0; //休憩したいHour
  int _restTimeMinute = 0; //休憩したいMinute
  int _restTimeSec = 2; //休憩したいSecond
  DateTime _restTime = DateTime.utc(0, 0, 0); //休憩する時間

  bool _isStartButtonDisable = false; //スタートボタンが無効かどうか
  bool _isStopButtonDisable = true; //ストップボタンが無効がどうか

  //進捗状況を保存するために使う変数
  int _dateTimeDiffarence = 0; //勉強した時刻の差を格納
  late SharedPreferences _preferences;

  @override
  void initState() {
    //初期化処理
    _timerModeStr = "STUDY TIME";
    _studyTime = _studyTime.add(Duration(
      hours: _studyTimeHour,
      minutes: _studyTimeMinute,
      seconds: _studyTimeSec,
    ));
    _restTime = _restTime.add(Duration(
      hours: _restTimeHour,
      minutes: _restTimeMinute,
      seconds: _restTimeSec,
    ));

    _setTime = _studyTime;

    _initPreferences();

    super.initState();
  }

  void _onTimer(_TimeModeState _timerMode, BuildContext context) {
    // タイマー起動
    setState(() {
      //状態を変更
      _isStartButtonDisable = true;
      _isStopButtonDisable = false;
    });

    //タイマーモードによって使用する時間を切り替え,代入
    if (_timerMode == _TimeModeState.study) {
      setState(() {
        _setTime = _studyTime;
      });
    } else {
      setState(() {
        _setTime = _restTime;
      });
    }

    _timer = Timer.periodic(
      //タイマー開始
      Duration(seconds: 1), //一秒ごとに関数を実行
      (Timer timer) async {
        if (_timerMode == _TimeModeState.study) {
          _dateTimeDiffarence = _studyTime.difference(_setTime).inSeconds;
        } else {
          _dateTimeDiffarence = 0;
        }
        if (_setTime == DateTime.utc(0, 0, 0)) {
          //時間が0になったら
          _offTimer(); //タイマーストップ
          _modeSwitch(_timerMode); //モード切り替え
          StopOrNextAlert _alert = StopOrNextAlert(); //アラートのインスタンス作成
          await _alert.timeIsUpAlert(context); //アラートを出すawaitでこの処理を待つ
          //アラートにあるボタンの答えNEXT=true,STOP=false
          if (_alert.answer == true) {
            //NEXTをおしたなら
            _onTimer(_mode, context); //もう一度タイマーを起動
            return;
          }
          return; //関数終わり
        }
        //状態を変更
        setState(() {
          _setTime = _setTime.add(Duration(seconds: -1));
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
      if (_timer.isActive) _timer.cancel(); //タイマーストップ
    });
    _setPreferences(_dateTimeDiffarence);
    return;
  }

  //受け取った_TimeModeStateを反転させる関数
  void _modeSwitch(_TimeModeState _timerMode) {
    if (_timerMode == _TimeModeState.study) {
      setState(() {
        _timerModeStr = "REST TIME";
        _mode = _TimeModeState.rest;
        _setTime = _restTime;
      });
      return;
    } else {
      setState(() {
        _timerModeStr = "STUDY TIME";
        _mode = _TimeModeState.study;
        _setTime = _studyTime;
      });
      return;
    }
  }

  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences.setInt("progress_time_key", 0);
    return;
  }

  Future<void> _setPreferences(int _setInt) async {
    // SharedPreferencesに値を設定.
    int _progressTime = 0;
    _progressTime = _preferences.getInt("progress_time_key")!; //進捗時間を取得
    int _addedTime = _progressTime + _setInt; //経過した時間と進捗時間を加算
    await _preferences.setInt("progress_time_key", _addedTime); //SET
    print(_preferences.getInt("progress_time_key"));
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        //勉強の時間なのか,休憩時間なのか表示
        "$_timerModeStr",
        style: Theme.of(context).textTheme.headline3,
      ),
      Text(
        //時間を表示
        DateFormat.Hms().format(_setTime),
        style: Theme.of(context).textTheme.headline1,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            child: ElevatedButton(
              //ストップボタン
              child: const Icon(Icons.pause),
              style: ElevatedButton.styleFrom(),
              onPressed: _isStopButtonDisable
                  ? null
                  : () {
                      _offTimer();
                    },
            ),
            visible: !_isStopButtonDisable,
          ),
          Visibility(
            child: ElevatedButton(
              //スタートボタン
              child: const Icon(Icons.play_arrow),
              style: ElevatedButton.styleFrom(),
              onPressed: _isStartButtonDisable
                  ? null
                  : () {
                      _onTimer(_mode, context);
                    },
            ),
            visible: !_isStartButtonDisable,
          ),
        ],
      ),
    ]);
  }
}
