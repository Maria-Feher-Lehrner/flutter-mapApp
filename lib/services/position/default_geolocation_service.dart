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
    Position? position;
    try{
      if(!kIsWeb){
        position = await Geolocator.getLastKnownPosition();
      }
      if (position == null) {
        position = await Geolocator.getCurrentPosition();
      }
      return Future.value(position);
    }catch(e){
      _logger.e("Error while obtaining geolocation: $e");
      return Future.error(e);
    }
  }
}