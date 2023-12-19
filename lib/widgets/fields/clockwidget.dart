import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockWidget extends StatefulWidget{
  const ClockWidget({super.key});

  @override
  State<StatefulWidget> createState() => _StateClockWidget();

}
class _StateClockWidget extends State<ClockWidget>{
  late String _timeString;

  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    _timer =Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.center,
      child: Text(_timeString,textAlign: TextAlign.center,style: Theme.of(context).textTheme.headlineSmall),
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy\nhh:mm:ss').format(dateTime);
  }

}