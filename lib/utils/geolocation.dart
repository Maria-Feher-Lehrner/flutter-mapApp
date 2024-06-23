import 'package:geolocator/geolocator.dart';

requestLocationPermissions() async {
  final bool enabled = await Geolocator.isLocationServiceEnabled();
  if (!enabled){
    //TODO: implement
  }

  LocationPermission permission = await Geolocator.requestPermission();
  if(permission == LocationPermission.denied){ // Das ist, wenn der User die Permission "nur jetzt nicht" erlaubt hat.
    permission = await Geolocator.requestPermission();
  }else if (permission == LocationPermission.deniedForever){ //deniedForever ist, wenn der User die Permissionentscheidung nicht auf später verschoben, sondern endgültig abgelehnt hat. Dann geht der Dialog nicht mehr auf und der User muss die Einstellung manuell freigeben.
    //TODO: let the user open settings
    print("Location permission denied forever");
  }

}