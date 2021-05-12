import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/racemode.dart';

import 'controlpanel.dart';


class PlayPage extends StatefulWidget {
  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Text('Play'),
        //   actions: [
        //   IconButton(
        //       onPressed: () => Navigator.push( context, MaterialPageRoute(builder: (context) => RaceMode()
        //       )
        //       ),
        //       icon: Icon(Icons.speed),
        //   )
        // ],
        backgroundColor:Colors.green.shade400,
      ),
      body: Controlpanel(),

    );
  }
}
