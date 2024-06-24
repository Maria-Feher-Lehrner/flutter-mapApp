import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service_locator.dart';
import '../../services/position/geolocation_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Logger _logger = getIt<Logger>();

  final GeolocationService _geolocationService = getIt<GeolocationService>();
  final List<Marker> _markers = [];
  Position? _currentPosition;
  late MapController _mapController;

  void _log() {
    _logger.i("Whatever");
  }

  @override
  void initState() {
    super.initState();
    _logger.i("MapPage: initState called");
    _mapController = MapController();
    _loadLocations();
    /*_geolocationService.getCurrentGeolocation().then((value) {
      _logger.i("Geolocation: $value");
      setState(() {
        _currentPosition =
            value; //setState ist notwendig, damit das UI später neu gezeichnet wird.
      });
    }).catchError((error) => _logger.e(error));
    // then und catch sollte immer vorhanden sein, damit user nicht kryptische Fehlermeldungen erhält, sondern gezielt etwas angezeigt bekommen kann*/
  }

  Future<void> _loadLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final locations = prefs.getStringList('locations') ?? [];
    _logger.i("MapPage: Loaded locations - $locations");
    if (!mounted) return;  // Check if widget is still mounted
    setState(() {
      for (var location in locations) {
        final parts = location.split(':');
        if (parts.length == 3) {
          final lat = double.tryParse(parts[0]);
          final lng = double.tryParse(parts[1]);
          final title = parts[2];
          if (lat != null && lng != null) {
            _markers.add(Marker(
              point: LatLng(lat, lng),
              child: Column(
                children: [
                  const Icon(Icons.location_pin, color: Colors.red),
                  Text(title, style: const TextStyle(color: Colors.black)),
                ],
              ),
            ));
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    //hier aktiv reingeben: wenn man irgendwelche subscriptions hat (z.B. ein clicklistener),
    // dann hier rein. Weil es ist nicht garantiert, dass der listerner nicht doch im memory liegen bleibt, auch wenn das widget zerstört wird.
    // Genereller Anwendungsfall jegliche subscriptions auf events.
  }

  void _handleMapReady() {
    _geolocationService.getCurrentGeolocation().then((value) {
      LatLng latLngPosition = LatLng(value.latitude, value.longitude);
      _logger.i("Geolocation: $value");
      _mapController.move(latLngPosition, 10);
      _markers.add(Marker(
          point: latLngPosition,
          child: const FlutterLogo(),
      ));
      if (!mounted) return;  // Check if widget is still mounted
      setState(() {
        _currentPosition = value;
      });
    }).catchError((error) {
      _logger.e(error);
    });
  }

  void _resetMapToCurrentLocation() {
    if (_currentPosition != null) {
      LatLng latLngPosition = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      _mapController.move(latLngPosition, 10);
    }
  }
  @override
  Widget build(BuildContext context) {
    _logger.i("Building map page");
    return Scaffold(
      body: Stack(
          children: [
            FlutterMap(
                mapController: _mapController,
                options: MapOptions(onMapReady: _handleMapReady),
                children: [
                  TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
                  ),
                  MarkerLayer(markers: _markers)
                ]
            )
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetMapToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

/** 5. flutter map von flutter pub.dev installieren via commandzeile im terminal
 * 6. flutter package latlng2 von flutter pub.dev installieren via commandzeile (siehe installing tab)
 * 7. geolocator package von flutter pub.dev installieren. (dafür brauchts vorher das Freischalten vom Entwicklermodus in den Windows Systemeinstellungen)
 * (findet man im Windows Terminal mit "start ms-settings:developers"
 * 8. Permissions in notwendigen Plattformen setzen (manifest und evtl. (!) SDK in build.gradle (die, die lose im android/app Ordner liegt), außerdem richtige kotlin Version in settings.gradle (1.9.0))
 * 9. methode zum Abfragen von Permission schreiben: dart file unter utils*/

//2.12 Geolocator in Map page implementieren. AAAABER - wenn man jetzt die App startet, wird sie noch crashen!
//2.13: --> Geolocator in service_locator implementieren

//2.14 oder .15? FlutterMap in build und in handleMapReady implementieren
