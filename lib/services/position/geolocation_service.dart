import 'package:geolocator/geolocator.dart';

abstract class GeolocationService{
  Future<Position> getCurrentGeolocation();
}

//2.9: neues dartfile unter services abstract class GeolocationService erstellen
//2.10: --> neues dartfile default_geolocation_service