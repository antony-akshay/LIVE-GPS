import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpsapk/helpers/gps.dart';

class homeScreen extends StatefulWidget {
  homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

final GPS _gps = GPS();

Position? _userPosition;

Exception? _exception;

class _homeScreenState extends State<homeScreen> {
  void _handlePositionStream(Position position) {
    setState(() {
      _userPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_exception != null) {
      child = Text('please provide GPS permission');
    } else if (_userPosition == null) {
      child = CircularProgressIndicator();
    } else {
      child = Text(_userPosition.toString());
    }

    return Scaffold(
      body: Center(child: child,),
    );
  }

  void initState() {
    super.initState();
    _gps.startPositionStream(_handlePositionStream).catchError((e) {
      setState(() {
        _exception = e;
      });
    });
  }
}
