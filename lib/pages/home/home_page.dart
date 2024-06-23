import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service_locator.dart';
import '../../utils/qr_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State <HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Logger _logger = getIt<Logger>(); //2.3. Logger in Home page implementieren. Man kann logger jetzt überall mit diesem Aufruf verwenden, wo man ihn haben möchte
  List<String> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locations = prefs.getStringList('locations') ?? [];
    });
  }

  Future<void> _saveLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locations.add(location);
      prefs.setStringList('locations', _locations);
    });
  }

  Future<void> _scanQrCode() async {
    final result = await scanQrCode(context);
    if (result != null) {
      _saveLocation(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.i("Building Home Page");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _locations.map((location) => Text(location)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQrCode,
        child: const Icon(Icons.qr_code_scanner),
      ),
    );

    //return const Center(child: Text("Home"));
  }
}
