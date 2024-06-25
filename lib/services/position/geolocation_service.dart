import 'package:geolocator/geolocator.dart';

abstract class GeolocationService{
  Future<Position> getCurrentGeolocation();
}
