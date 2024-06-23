import 'dart:math';

import 'package:first_flutter_project/services/position/geolocation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:logger/logger.dart';

import '../../service_locator.dart';

class DefaultGeolocationService implements GeolocationService{
  final _logger = getIt<Logger>();
  @override
  Future<Position> getCurrentGeolocation() async {
    // wenn man Future weglässt, wäre die Methode synchron und blocking. So kann mit Future asynchroner Code aufgerufen werden.
    Position? position;
    try{
      if(!kIsWeb){
        position = await Geolocator.getLastKnownPosition();
      }
      if (position == null) {
        position = await Geolocator.getCurrentPosition();
      }
      return Future.value(position);
      //final Position? position = await Geolocator.getCurrentPosition();
      //return await Geolocator.getCurrentPosition();
    }catch(e){
      _logger.e("Error while obtaining geolocation: $e");
      return Future.error(e);
    }
  }
}

//2.11 --> methode in class implementieren

//2.14 --> if- Fallstellung: wenn die App am Handy/Mobilgerät läuft, dann kann man die last Known position verwenden
// (Achtung! ist auch nicht unproblematisch - siehe Fall, in Flugzeug steigen und woanders rauskommen...) - in dem Fall evtl. lastKnownPosition ein Ablaufdatum geben.