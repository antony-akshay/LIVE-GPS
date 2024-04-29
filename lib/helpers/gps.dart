import 'dart:async';

import 'package:geolocator/geolocator.dart';

typedef PositionCallback = Function(Position position);

class GPS {
  late StreamSubscription<Position> _positionStream;

  bool isAccessGranted(LocationPermission permission) {
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<bool> requestPermission() async {
    LocationPermission permisson = await Geolocator.checkPermission();
    if (isAccessGranted(permisson)) {
      return true;
    }

    permisson = await Geolocator.requestPermission();
    return isAccessGranted(permisson);
  }

  Future<void> startPositionStream(Function(Position position) callback) async {
    bool permissionGranted = await requestPermission();
    if (!permissionGranted) {
      throw Exception("User did not grant GPS permissions");
    }
    _positionStream = Geolocator.getPositionStream(
            locationSettings:
                LocationSettings(accuracy: LocationAccuracy.bestForNavigation))
        .listen(callback);
  }

  Future<void> stopPositionStream() async{
   await _positionStream.cancel();
  }
}
