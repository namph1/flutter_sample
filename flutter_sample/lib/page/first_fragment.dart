import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstFragment extends StatelessWidget {
   final _key = '';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: new FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var _key = "";

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _key = (prefs.getString('name'));
    });
  }

  @override
  Widget build(BuildContext context) {
   return new  Text(_key);

  }
}
