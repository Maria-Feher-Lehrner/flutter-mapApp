import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:first_flutter_project/service_locator.dart';
import 'package:first_flutter_project/utils/geolocation.dart';
import 'package:flutter/material.dart';

import 'components/navigation/tab_based_bottom_navigation_bar.dart';

void main() async {
  setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermissions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Map App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset(
          'assets/images/splash_image.gif',
          fit: BoxFit.cover,
        ),
        nextScreen: const TabBasedBottomNavigationBar(),
        splashTransition: SplashTransition.fadeTransition,
        duration: 3000,
        backgroundColor: Colors.teal,
      ),
    );
  }
}
