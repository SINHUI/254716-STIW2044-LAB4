import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_farmer/user.dart';
import 'package:my_farmer/tab_screen.dart';
import 'package:my_farmer/tab_screen2.dart';
import 'package:my_farmer/tab_screen3.dart';
import 'package:my_farmer/tab_screen4.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;
  
  int currentTabIndex=0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreen(user: widget.user),
      TabScreen3(user: widget.user),
      TabScreen2(user: widget.user),
      TabScreen4(user: widget.user),

    ];
  }

  String $pagetitle = "My Farmer";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

 @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.green));
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Goods"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, ),
            title: Text("Shopping Cart"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus, ),
            title: Text("Delivery"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, ),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }
}
