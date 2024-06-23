import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../../service_locator.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final Logger _logger = getIt<Logger>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _logger.i("Building locations page");
    throw UnimplementedError();
  }
}
