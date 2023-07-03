import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gbbf_beer_app/settings.dart';
import 'package:gbbf_beer_app/saved_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GBBF Beers',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GBBF Beers'),
    );
  }
}

class MyHomePage extends StatefulHookWidget {
   const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
   final String title;
   @override
   State<StatefulWidget> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0;
  String year = "2023";

  @override
  void initState(){
    super.initState();
    _loadSavedState();
  }

  void _incrementCounter(){
    setState(() {
      _counter++;
    });
  }

  void _settingsResult(newYear){
    debugPrint("returned from settings");
    setState(() {
      year = newYear;
    });

  }

  @override
  Widget build(BuildContext context) {

    useEffect(() {
      saveState();
    },[year]);

    // useEffect(() {
    //   // filter beers
    // },[year]);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Gbbf Beers $year'),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Settings(year)))
                        .then((value) => _settingsResult(value));
                  },
                  child: const Icon(
                    Icons.settings,
                    size: 26,
                  )))
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> saveState() async {
    debugPrint("saving state");
    final prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(SavedState(year));
    prefs.setString("state", json);
  }

  Future _loadSavedState() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      String json = prefs.getString("state") ?? '';
      if(json.isNotEmpty){
        SavedState savedState = SavedState.fromJson(jsonDecode(json));
        year = savedState.year;
        debugPrint("Saved state loaded");
      } else {
        debugPrint("Saved state not found, using defaults");
        // use default values
        year= "2023";
      }
    } catch(e){
      debugPrint("Error loading saved state");
      debugPrint(e.toString());

      const snackBar =SnackBar(content: Text("Error loading saved state"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}