import 'package:first_flutter_project/services/better_logger.dart';
import 'package:first_flutter_project/services/position/default_geolocation_service.dart';
import 'package:first_flutter_project/services/position/geolocation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final GetIt getIt = GetIt
    .instance;

void setupServiceLocator() {
  if (kIsWeb) {
    getIt.registerSingleton<Logger>(Logger(printer: PrettyPrinter()));
  } else {
    getIt.registerSingleton<Logger>(BetterLogger());
  }
  getIt.registerSingleton<GeolocationService>(DefaultGeolocationService());
}