import 'package:first_flutter_project/services/better_logger.dart';
import 'package:first_flutter_project/services/position/default_geolocation_service.dart';
import 'package:first_flutter_project/services/position/geolocation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final GetIt getIt = GetIt
    .instance; //getIt ist jetzt eine globale Variable. getIt ist immer der Service für den call, den man gern verwenden würde

void setupServiceLocator() {
  if (kIsWeb) {
    //k ist einfach eine Framework Konstante
    getIt.registerSingleton<Logger>(Logger(printer: PrettyPrinter()));
  } else {
    //getIt.registerSingleton<Logger>(Logger(printer: PrettyPrinter()));
    getIt.registerSingleton<Logger>(BetterLogger());
  }
  getIt.registerSingleton<GeolocationService>(DefaultGeolocationService());
}

//2.0: packages get_it & logger von pub.dev runterladen
//getIt ist package, das mir container zur verfügung stellt
//logger gibt nur "hübschen" konsolenoutput
//generell einen logger zu Beginn des Projekts setzen macht Sinn, vor allem wenn es ein Projekt ist,
// das in die Produktion rausgeht. Damit kann man dann remote loggen, wenn die App beim Kunden läuft und checken, wo Probleme auftreten.
// Sehr schön ist z.B. dafür auch ein tool wie sentry...
// 2.1: dart file service_locator unter lib erstellen und setupServiceLocator implementieren
//2.2: --> in main implementieren
//2.3: --> Logger in home_page implementieren
//2.4: --> Logger in map page implementieren
//2.5: --> jetzt entscheiden, dass man doch lieber einen eigenen logger bauen möchte --> dart file "better_logger" unter services erstellen.

//2.13: --> Geolocator registrieren! (NACH dem Logger, weil wir eine Funktion haben, die einen Errorlog erwartet, falls der Geolocator nicht funktioniert.
// Sonst würde die beim Geolocator schon crashen und könnte mir dann keinen Log mehr auswerfen, weil der Logger noch nicht instanziert ist.

//2.14 --> default geolocation service