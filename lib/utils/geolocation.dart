import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../service_locator.dart';

requestLocationPermissions() async {
  final bool enabled = await Geolocator.isLocationServiceEnabled();
  final Logger logger = getIt<Logger>();
  if (!enabled){
    //TODO: implement
  }

  LocationPermission permission = await Geolocator.requestPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
  }else if (permission == LocationPermission.deniedForever){
    logger.i("Location permission denied forever");
  }

}