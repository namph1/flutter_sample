import 'package:flutter/material.dart';
import 'package:flutter_sample/utils/share_pref_utils.dart';
class FirstFragment extends StatelessWidget {
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
  var token = "";

  @override
  void initState() {
    SharePreUtils sharePreUtils = new SharePreUtils();
    sharePreUtils.getPref("token").then(initToken);
    super.initState();
  }

  void initToken(String _token) {
    setState(() {
      this.token = _token;
    });
  }


  @override
  Widget build(BuildContext context) {
   return new  Text(token);

  }
}
