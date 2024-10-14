import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_v4/secondPage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Page',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const MyHomePage(title: 'Weather Page'),
        '/forecastPage': (context) =>
            const SecondPage(title: 'Weather Forecast Page')
      },
      home: const MyHomePage(title: 'Weather Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController cityText = TextEditingController();

  String temp = '';
  String description = '';
  String humidity = '';
  String icon = '';

  Future<void> fetchingWeatherFromAPI(String cityChosen) async {
    var url = Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=0e61e15f7f7e44b797a93849241209&q=' +
            cityChosen +
            '&aqi=no');
    var response = await http.get(url);

    var jsonResponse = jsonDecode(response.body);
    var todaysWeather = jsonResponse['current'];
    var conditionToday = todaysWeather['condition'];

    setState(() {
      temp = todaysWeather['temp_c'].toString();
      description = conditionToday['text'];
      humidity = todaysWeather['humidity'].toString();
      icon = 'https:' + conditionToday['icon'];
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
    const List<Widget> fruits = <Widget>[
      Text('Temp'),
      Text('Description'),
      Text('Humidity')
    ];


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
              'Nimbus your day!',
            ),
            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 70,
              alignment: Alignment.center,
              child: TextFormField(
                controller: cityText,
                decoration: const InputDecoration(
                  labelText: 'Input City',
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),
            FilledButton(
                onPressed: () => {fetchingWeatherFromAPI(cityText.text)},
                child: Text("Search")),
            const SizedBox(height: 40),
            /*Image.network(
                if (icon = null){
                  Image.asset(assets/images/nimbus6.JPG), height: 150, width: 150, fit: BoxFit.cover}
                else {icon, height: 150, width: 150, fit: BoxFit.cover},*/
            Image.network(icon, height: 150, width: 150, fit: BoxFit.cover),
            /*ToggleButtons(
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  isSelected[index] = !isSelected[index];
                });
              },
              children: const <Widget>[
                Icon(Icons.ac_unit),
                Icon(Icons.call),
                Icon(Icons.cake),
              ],
            ),*/
            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 70,
              alignment: Alignment.center,
              child: TextField(
                controller: TextEditingController(text: description),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              child:Row(
                children: <Widget>[
                  Expanded(
                    child:Container(


                      width: 150, height: 70, alignment: Alignment.center,
                      child: TextField(
                        controller: TextEditingController(text: humidity),
                        decoration: const InputDecoration(
                          labelText: 'Humidity',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        textAlign: TextAlign.center,
                      ),


                    ),
                  ),
                  Expanded(
                      child: Container(
                        width: 150, height: 70, alignment: Alignment.center,
                        child: TextField(
                          controller: TextEditingController(text: temp),
                          decoration: const InputDecoration(
                            labelText: 'Temperature',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          textAlign: TextAlign.center,
                        ),


                      ))
                ]
              )
            ),
            const SizedBox(height: 40),
            FilledButton(
                onPressed: () =>
                    {Navigator.pushNamed(context, '/forecastPage')},
                child: Text("5 days forecast")),
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
