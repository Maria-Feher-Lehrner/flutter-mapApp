import 'package:first_flutter_project/pages/about/about_page.dart';
import 'package:flutter/material.dart';

import '../../pages/home/home_page.dart';
import '../../pages/locations/locations_page.dart';
import '../../pages/map/map_page.dart';

class TabBasedBottomNavigationBar extends StatefulWidget {
  const TabBasedBottomNavigationBar({super.key}); //jedes Widget hat einen key, um es eindeutig identifizieren zu können

  @override
  State <TabBasedBottomNavigationBar> createState() => _TabBasedBottomNavigationBarState();
}

class _TabBasedBottomNavigationBarState extends State<TabBasedBottomNavigationBar> {

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    MapPage(),
    LocationsPage(),
    AboutPage()
  ];

  int _selectedTabIndex = 0;
  void _handleTabSelection(int selectedTabIndex){
    setState((){
      _selectedTabIndex = selectedTabIndex;
    });
  }
  @override
  Widget build(BuildContext context) {
    //return Container(); //container wird benötigt, wenn hier mehrere widgets übergeben werden. Wenn hier z. B. nur ein einziges widget "text" übergeben würde, wäre der container unnöti
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text( "Map Sample",
          style:
          TextStyle(color: Colors.teal, fontWeight: FontWeight.w700)
      ))),
        body: _pages.elementAt(_selectedTabIndex), //hier wird einfach ganz simpel das Listenelemente (die Seite) angesprochen, die im Array an dem entsprechenden gleichen Platz wie der TabIndex sitzt.
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: "Map"),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: "Locations"),
        BottomNavigationBarItem(icon: Icon(Icons.pin_drop_outlined), label: "About")
      ], currentIndex: _selectedTabIndex,
          onTap: _handleTabSelection));
  }
}

/*3. class implementieren
* BottomNavigationBar benötigt mind. 2 items im Array
*
* Home Navigation: erst mal simpel: Liste an widgets, die angezeigt werden.
*
* 4. pages implementieren
*
*/