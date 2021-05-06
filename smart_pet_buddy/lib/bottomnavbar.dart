import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/custompage.dart';
import 'package:smart_pet_buddy/homepage.dart';
import 'package:smart_pet_buddy/playpage.dart';
import 'package:smart_pet_buddy/profilepage.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class BottomBar extends StatefulWidget {
  final FirebaseApp app;

  BottomBar(this.app);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  MqttServerClient client;

  List<Widget> tabs = <Widget>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //connect().then((value) {
    //client = value;
    //});
    tabs = [HomePage(), PlayPage(), CustomPage(), ProfilePage(widget.app)];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Bottom Bar'),
      // ),
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 40,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          backgroundColor: Colors.green.shade400,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_car_outlined),
                label: 'Play',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.play_circle_outline),
                label: 'Custom',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profile',
                backgroundColor: Colors.white)
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          }),
    );
  }
}
