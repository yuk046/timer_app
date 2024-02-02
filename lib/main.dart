import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'next_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'タイマー'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // titleを外から貰ってきてstringに代入
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _second = 0;
  int _minute = 0;
  int _millisecond = 0;
  // ?つけるとデフォルトでNULL
  Timer? _timer;
  bool _isRunning = false;

  @override
  // 最初に呼び出される関数
  void initState() {
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _second++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // センターに配置する
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_formatNuber(_minute)} : ${_formatNuber(_second)} . ${_formatNuber(_millisecond)}',
              style: TextStyle(fontSize: 65),
            ),
            ElevatedButton(
              onPressed: () {
                toggleTimer();
              },
              // ? tureの処理　falseの処理
              child: Text(_isRunning ? 'ストップ' : 'スタート',
              style: TextStyle(color: _isRunning ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                resetTimer();
              },
              // ? tureの処理　falseの処理
              child: Text(
              'リセット',
                style: TextStyle(color:Colors.black,
                fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNuber(int number) {
    return NumberFormat('00').format(number);
  }

  void toggleTimer(){
    if (_isRunning){
      _timer?.cancel();
    }
    else{
      _timer = Timer.periodic(
        const Duration(milliseconds: 10), 
        (timer) {
          setState(() {
            _millisecond++;
            if (_millisecond > 100){
              _millisecond = 0;
              _second++;
            }
            if(_second > 60){
              _second = 0;
              _minute++;
            }
            if(_minute == 1 && _millisecond == 0){
              _timer?.cancel();
              _isRunning = false;
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NextPage()),
              );
            }
          });
        },
      );
    }
    setState(() {
      // 逆にする
      _isRunning = !_isRunning;
    });
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      _second = 0;
      _millisecond = 0;
      _minute = 0;
      _isRunning = false;
    });
  }
}
