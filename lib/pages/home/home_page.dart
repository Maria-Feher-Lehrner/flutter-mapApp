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
    _logger.i("HomePage: initState called");
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;  // Check if widget is still mounted
    setState(() {
      _locations = prefs.getStringList('locations') ?? [];
    });
    _logger.i("HomePage: Loaded locations - $_locations");
  }

  Future<void> _saveLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;  // Check if widget is still mounted
    setState(() {
      _locations.add(location);
      prefs.setStringList('locations', _locations);
    });
    _logger.i("HomePage: Saved location - $location");
  }

  Future<void> _scanQrCode() async {
    _logger.i("HomePage: _scanQrCode called");
    try {
      final result = await scanQrCode(context);
      _logger.i("HomePage: QR scan result - $result");

      if (result != null && result.isNotEmpty) {
        await _saveLocation(result);
      } else {
        _logger.e("HomePage: QR scan failed or result is empty");
      }
    } catch (e) {
      _logger.e("HomePage: Error during QR scan - $e");
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
