import 'package:first_flutter_project/pages/about/about_page.dart';
import 'package:flutter/material.dart';

import '../../pages/home/home_page.dart';
import '../../pages/locations/locations_page.dart';
import '../../pages/map/map_page.dart';

class TabBasedBottomNavigationBar extends StatefulWidget {
  const TabBasedBottomNavigationBar({super.key});

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
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text( "Map Sample",
          style:
          TextStyle(color: Colors.teal, fontWeight: FontWeight.w700)
      ))),
        body: _pages.elementAt(_selectedTabIndex),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: "Map"),
        BottomNavigationBarItem(icon: Icon(Icons.pin_drop_outlined), label: "Locations"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "About")
      ], currentIndex: _selectedTabIndex,
          onTap: _handleTabSelection,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey));
  }
}
