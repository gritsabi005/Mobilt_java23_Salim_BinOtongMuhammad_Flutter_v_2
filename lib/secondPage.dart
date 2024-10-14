import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
//import 'package:flutter_launcher_icons';
import 'package:http/http.dart' as http;

class SecondPage extends StatefulWidget {
  const SecondPage({super.key, required this.title});

  /*
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  */

  final String title;

  @override
  State<SecondPage> createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage> {
  int _counter = 0;
  final TextEditingController cityTextForecast = TextEditingController();
  //String? weatherInfo;
  List<Map<String, String>> weatherInfo = [];


  Future<void> fetchingWeatherFromAPI(String cityChosen) async {
    final apiKey = 'dda6b16ec8a316b37d36657a227c4111'; // Ganti dengan API key lo
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q='+cityChosen+'&appid='+apiKey+'&units=metric';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    // make an array, or List in the dart language, of the json data of 'list' to be later dissected
    final List<dynamic> list = data['list'];
    // crating empty hashmaps to be later used
    final List<Map<String, String>> fetchingDataPer3Hour = []; // this is only the list of


    for (var per3Hour in list){
      final date = per3Hour['dt_txt'].split(' ')[0];
      final clock = per3Hour['dt_txt'].split(' ')[1].substring(0, 5);
      final temperature = per3Hour['main']['temp'].toString();

      fetchingDataPer3Hour.add({
        'date' : date,
        'time' : clock,
        'temp' : temperature,
      });


    }
      setState(() {
        weatherInfo = fetchingDataPer3Hour;
        //print(weatherInfo);

        //weatherInfo = 'Temperature: ${data['list'][0]['main']['temp']}°C\nCondition: ${data['list'][0]['weather'][0]['description']}';
      });

  }


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    String s;

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your weather forecast for the next 5 days',
            ),
            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 70,
              alignment: Alignment.center,
              child: TextFormField(
                controller: cityTextForecast,
                decoration: const InputDecoration(
                  labelText: 'Input City',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
                onPressed: () {
                  final city = cityTextForecast.text;
                  if (city.isNotEmpty) {
                    fetchingWeatherFromAPI(city);
                    print(cityTextForecast.text);


                  }
                },
                child: const Text("Search")),

            /*const SizedBox(height: 40),
            if (weatherInfo != null)
              Text(weatherInfo!)
            else
              Container(),*/

            const SizedBox(height: 20),

            Expanded(

              child: ListView.builder(itemCount: weatherInfo.length, itemBuilder: (context, index) {
                  print(weatherInfo);
                  /*
                  for (var data in weatherInfo) {
                    final date = data['date'];
                    final clock = data['time'];
                    final temperature = data['temp'];

                    final List<String> datesAvailable = [];
                    for (int i = 0; i < data.length; i++) {
                      if (data(i).date == data(i+1)){
                        date
                      } else {

                      }
                    }
                  }
                  */
                  final tempPerHour = weatherInfo[index];
                  return ListTile(

                    title: Align(
                      alignment: Alignment.center,
                      child: Text('${tempPerHour['date']}')
                    ),
                    subtitle: Align(
                      alignment: Alignment.center,
                      child: Text('${tempPerHour['time']} - ${tempPerHour['temp']} °C'),
                    ),
                  );

                },


              ),

            ),
            const SizedBox(height: 30),
            FilledButton(
                onPressed: () => {
                  Navigator.pushNamed(context, '/home')
                },
                child: Text("Home page")),
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
}