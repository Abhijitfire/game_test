import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int randomDigit = 0;
  int timeUnit = 0;
  int score = 0;
  Timer? _timer;
  final Random _random = Random();
  int attempt = 1;

  int _timerDuration = 5; // Timer duration in seconds
  CountDownController _controller = CountDownController();

  late DateTime currentTime;
  late int currentSecond;

  @override
  void initState() {
    super.initState();
    _generateRandomDigit();
    updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  void _generateRandomDigit() {
    setState(() {
      randomDigit = _random.nextInt(60);
      attempt++;
      if (attempt == 6) {
        _resetGame();
        setState(() {
          attempt = 1;
        });
      }
    });
  }

  void _resetGame() {
    setState(() {
      score = 0;
      attempt = 0;
    });
  }

  void updateTime() {
    setState(() {
      currentTime = DateTime.now();
      currentSecond = currentTime.second;
      _generateRandomDigit();
      if (randomDigit == currentSecond) {
        score++;
        print(score);
      } else {
        print("No matcj");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Card Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 70),
                    height: 200,
                    // width: 300,
                    child: Column(
                      children: [
                        Text(
                          'Random Digit',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '$randomDigit',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  child: Container(
                    // width: 300,
                    height: 200,
                    padding: EdgeInsets.symmetric(vertical: 70),
                    child: Column(
                      children: [
                        Text(
                          "Current time",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${currentTime.second}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Card(
              child: Container(
                decoration: BoxDecoration(color: Colors.green),
                child: Text(
                  "Score :$score",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              child: Text("attempt: $attempt"),
            ),
            CircularCountDownTimer(
              duration: _timerDuration,
              initialDuration: 0,
              controller: _controller,
              width: MediaQuery.of(context).size.width / 2,
              height: 400,
              ringColor: Colors.grey[300]!,
              ringGradient: null,
              fillColor: Colors.purpleAccent[100]!,
              fillGradient: null,
              backgroundColor: Colors.purple[500],
              backgroundGradient: null,
              strokeWidth: 20.0,
              strokeCap: StrokeCap.round,
              textStyle: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textFormat: CountdownTextFormat.SS,
              isReverse: false,
              isReverseAnimation: false,
              isTimerTextShown: true,
              autoStart: true,
              onStart: () {
                debugPrint('Countdown Started');
              },
              onComplete: () {
                debugPrint('Countdown Ended');
                Future.delayed(Duration(seconds: 5), () {
                  _controller.restart();
                  updateTime();
                });
              },
              onChange: (String timeStamp) {
                debugPrint('Countdown Changed $timeStamp');
              },
              timeFormatterFunction: (defaultFormatterFunction, duration) {
                if (duration.inSeconds == 0) {
                  return "Start";
                } else {
                  return Function.apply(defaultFormatterFunction, [duration]);
                }
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: updateTime,
              child: Text('Match Random Digit'),
            ),
          ],
        ),
      ),
    );
  }
}
