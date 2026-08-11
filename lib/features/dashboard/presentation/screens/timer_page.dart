import 'dart:async';
import 'package:flutter/material.dart';

/// Dedicated timer screen - no state conflicts with dashboard
class TimerPage extends StatefulWidget {
  final int minutes;
  final String timerType;

  const TimerPage({
    required this.minutes,
    required this.timerType,
    super.key,
  });

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late int _remainingSeconds;
  late Timer _countdownTimer;
  bool _isRunning = true;

  // Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.minutes * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _showCompletionDialog();
      }
    });
  }

  void _pauseTimer() {
    _countdownTimer.cancel();
    setState(() => _isRunning = false);
  }

  void _resumeTimer() {
    setState(() => _isRunning = true);
    _startTimer();
  }

  void _stopTimer() {
    _countdownTimer.cancel();
    Navigator.pop(context);
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Great Work!'),
        content: Text('You completed your ${widget.timerType} session!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _stopTimer,
        ),
        title: const Text('Focus Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Type
            Text(
              widget.timerType,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),

            // Countdown Display
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [primaryBlue, darkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pause/Resume Button
                FloatingActionButton.extended(
                  onPressed: _isRunning ? _pauseTimer : _resumeTimer,
                  backgroundColor: Colors.white,
                  foregroundColor: primaryBlue,
                  icon: Icon(_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  label: Text(_isRunning ? 'Pause' : 'Resume'),
                ),

                const SizedBox(width: 16),

                // End Button
                FloatingActionButton.extended(
                  onPressed: _stopTimer,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.stop_rounded),
                  label: const Text('End'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
