import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Hola(),
    );
  }
}

class Hola extends StatefulWidget {
  @override
  _HolaState createState() => _HolaState();
}

class _HolaState extends State<Hola> {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token = "";

  @override
  void initState() {
    final pushNotificationService =
        PushNotificationService(_firebaseMessaging, context);
    pushNotificationService.initialise();
    pushNotificationService.getToken().then((value) {
      setState(() {
        _token = value;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'PRAKTIKUM HARI INI',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Container(
              height: 80,
              color: Colors.deepOrangeAccent,
              child: const Center(
                  child: Text(
                'Senin',
                style: TextStyle(fontWeight: FontWeight.w900),
              )),
            ),
            Container(
              height: 100,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Pemrograman Mobile',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Row(
                      //row run horizontal
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,

                      children: <Widget>[
                        new Icon(Icons.alarm),
                        new Text('07.00-08.40'),
                        new Icon(Icons.home),
                        new Text('Lab A'),
                        new Icon(Icons.computer),
                        new Text('B16'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PushNotificationService {
  final FirebaseMessaging _fcm;
  final context;

  PushNotificationService(this._fcm, this.context);

  Future getToken() async {
    String token = await _fcm.getToken();
    print("Firebase token :$token");
    return token;
  }

  void initialise() {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage : $message");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("$message"),
              ));
    }, onResume: (Map<String, dynamic> message) async {
      print("onMessage : $message");
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onMessage : $message");
    });
  }
}
