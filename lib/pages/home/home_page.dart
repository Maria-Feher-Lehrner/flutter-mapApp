import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();

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

    /*final locations = prefs.getStringList('locations') ?? [];
    locations.add(location);
    await prefs.setStringList('locations', locations);*/

    if (_validateInputs()) {
      String location = "${_latitudeController.text}:${_longitudeController.text}:${_locationNameController.text}";
      _saveLocationToPrefs(location);
      Fluttertoast.showToast(
        msg: "Location saved successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _saveLocationToPrefs(String location) async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _locations.add(location);
      prefs.setStringList('locations', _locations);
    });
    _logger.i("HomePage: Saved location - $location");
  }

  bool _validateInputs() {
    final double? latitude = double.tryParse(_latitudeController.text);
    final double? longitude = double.tryParse(_longitudeController.text);
    final String description = _locationNameController.text;

    if (latitude == null || longitude == null) {
      _logger.e("Invalid latitude or longitude");
      Fluttertoast.showToast(
        msg: "Invalid latitude or longitude",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }

    if (latitude < -90 || latitude > 90) {
      _logger.e("Latitude must be between -90 and 90");
      Fluttertoast.showToast(
        msg: "Latitude must be between -90 and 90",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }

    if (longitude < -180 || longitude > 180) {
      _logger.e("Longitude must be between -180 and 180");
      Fluttertoast.showToast(
        msg: "Longitude must be between -180 and 180",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }

    if (description.isEmpty) {
      _logger.e("Description cannot be empty");
      Fluttertoast.showToast(
        msg: "Description cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }

    return true;
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

  void _generateLocation() {
    final latitude = _latitudeController.text;
    final longitude = _longitudeController.text;
    final locationName = _locationNameController.text;

    if (latitude.isEmpty || longitude.isEmpty || locationName.isEmpty) {
      _logger.e("HomePage: One or more fields are empty");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    final location = "$latitude:$longitude:$locationName";
    _saveLocation(location);

    _latitudeController.clear();
    _longitudeController.clear();
    _locationNameController.clear();

    //ScaffoldMessenger.of(context).showSnackBar(
      //SnackBar(content: Text("Location saved successfully")),
    //);
  }

  @override
  Widget build(BuildContext context) {
    _logger.i("Building Home Page");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _latitudeController,
              decoration: const InputDecoration(
                labelText: "Latitude",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _longitudeController,
              decoration: const InputDecoration(
                labelText: "Longitude",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationNameController,
              decoration: const InputDecoration(
                labelText: "Location Name",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateLocation,
              child: const Text("Save Location"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _scanQrCode,
              child: const Text("Scan QR Code"),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget build(BuildContext context) {
    _logger.i("Building Home Page");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: const Center(
        child: Text("Home Page Content Here"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQrCode,
        child: const Icon(Icons.qr_code_scanner),
      ),
    );

    //return const Center(child: Text("Home"));
  }*/
}
