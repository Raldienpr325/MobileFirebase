import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static final FirebaseMessaging _fcm = FirebaseMessaging();
  String _token = "";
  static String dataKelas = '';
  static String dataLokasi = '';
  static String dataTduduk = '';
  static String dataWaktu = '';

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
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        debugPrint('onMessage: $message');
        getDataFcm(message);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(title: Text("$message")));
      },
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint('onLaunch: $message');
        getDataFcm(message);
      },
    );
    _fcm.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true),
    );
    _fcm.onIosSettingsRegistered.listen((settings) {
      debugPrint('Settings registered: $settings');
    });
    _fcm.getToken().then((token) =>
        setState(() {
          this._token = token;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'MOBILE MODUL 3',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          leading: Icon(Icons.arrow_back_ios, color: Colors.white),
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

            Divider(thickness: 1),
            Text(
              'DATA',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildWidgetTextDataFcm(),
          ],
        ),
      ),
    );

  }

  Widget _buildWidgetTextDataFcm() {
    if (dataKelas == null || dataKelas.isEmpty || dataLokasi == null ||
        dataLokasi.isEmpty || dataTduduk == null || dataTduduk.isEmpty ||
        dataWaktu == null || dataWaktu.isEmpty) {
      return Text('Your data FCM is here');
    } else {
      return Text(
          'Kelas: $dataKelas & Lokasi: $dataLokasi TempatDuduk: $dataTduduk & Waktu: $dataWaktu');
    }
  }

  void getDataFcm(Map<String, dynamic> message) {
    String kelas = '';
    String lokasi = '';
    String tduduk = '';
    String waktu = '';
    if (Platform.isIOS) {
      kelas = message['kelas'];
      lokasi = message['lokasi'];
      tduduk = message['tduduk'];
      waktu = message['waktu'];
    } else if (Platform.isAndroid) {
      var data = message['data'];
      kelas = data['kelas'];
      lokasi = data['lokasi'];
      tduduk = data['tduduk'];
      waktu = data['waktu'];
    }
    if (kelas.isNotEmpty &&
        lokasi.isNotEmpty &&
        tduduk.isNotEmpty &&
        waktu.isNotEmpty) {
      setState(() {
        dataKelas = kelas;
        dataLokasi = lokasi;
        dataTduduk = tduduk;
        dataWaktu = waktu;
      });
    }
    debugPrint('getDataFcm: kelas: $kelas & lokasi: $lokasi');
  }
}

class PushNotificationService {
  final FirebaseMessaging _fcm;
  final context;

  PushNotificationService(this._fcm, this.context);

  Future getToken() async {
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
    return token;
  }

  void initialise() {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
  }
}
