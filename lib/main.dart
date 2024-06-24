import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:first_flutter_project/service_locator.dart';
import 'package:first_flutter_project/utils/geolocation.dart';
import 'package:first_flutter_project/utils/splash_Screen.dart';
import 'package:flutter/material.dart';

import 'components/navigation/tab_based_bottom_navigation_bar.dart';

void main() async {
  setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermissions();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        // Configure your splash screen
        splash: Image.asset(
          'assets/images/splash_image.gif',
          fit: BoxFit.cover,
        ),
        nextScreen: const TabBasedBottomNavigationBar(), // Navigate to your bottom navigation bar after splash screen
        splashTransition: SplashTransition.fadeTransition,
        duration: 3000, // Adjust the duration as needed
        backgroundColor: Colors.white,
      ),
    );
  }
}

/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ergänzt wegen Fehlermeldung zu Binding, der wegen PermissionsDialog aufgeht, solange noch nicht alles fertig implementiert ist.
  setupServiceLocator(); //2.2 serviceLocator in main implementieren
  await requestLocationPermissions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Map App', //1. title individualisiert
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TabBasedBottomNavigationBar(), // 2. hier statt generic Code Home NavBar erstellt --> next: stateful widget in navigation erstellt
    );
  }
}*/



/*00: Strukturierung von Code:
* bei größeren Projekten bietet sich an: nach features - dann mit einem zusätzlichen Ordner "common" oder "core"
* bei kleineren Projekten (hier) bietet sich an nach Seiten und Komponenten*/


//Aufgabe: Eingabeseite voranstellen mit Eingabe von Lat/Long über Barcode
//dann noch zusätzliche Seite mit persistent gespeicherter Liste dieser Standorte
//Splash-Screen beim Starten: Plugin (Flutter splash-screen googeln)
//toast message ist auch schon vorgefertigt (plugin?)
//add a my location button: map fährt wieder auf aktuelle location zurück, wenn man rausgezoomt hat
//in einer option alle (persistent) gespeicherten locations gleichzeitig anzeigen
//wichtig: nicht alles in ein file packen, sondern code auslagern
//styling is wurscht