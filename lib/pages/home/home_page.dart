import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../service_locator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State <HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Logger _logger = getIt<Logger>(); //2.3. Logger in Home page implementieren. Man kann logger jetzt überall mit diesem Aufruf verwenden, wo man ihn haben möchte
  @override
  Widget build(BuildContext context) {
    _logger.i("Building Home Page");
    return const Center(child: Text("Home"));
  }
}
