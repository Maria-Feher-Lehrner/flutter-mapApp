import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service_locator.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final Logger _logger = getIt<Logger>();
  List<String> _locations = [];

  @override
  void initState() {
    super.initState();
    _logger.i("LocationsPage: initState called");
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;  // Check if widget is still mounted
    setState(() {
      _locations = prefs.getStringList('locations') ?? [];
    });
    _logger.i("LocationsPage: Loaded locations - $_locations");
  }

  @override
  Widget build(BuildContext context) {
    _logger.i("Building Locations Page");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Locations"),
      ),
      body: _locations.isEmpty
          ? const Center(child: Text("No locations available"))
          : ListView.builder(
        itemCount: _locations.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.location_pin),
            title: Text(_locations[index]),
          );
        },
      ),
    );
  }
}