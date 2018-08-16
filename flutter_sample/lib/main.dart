import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final channel = IOWebSocketChannel.connect("ws://192.168.123.1:5001");

  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(
          channel: channel,
        ),
    HomePage.tag: (context) => HomePage(channel: channel,),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: LoginPage(channel: channel),
      routes: routes,
    );
  }
}
