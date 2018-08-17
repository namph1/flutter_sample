import 'package:flutter/material.dart';
import 'package:flutter_sample/utils/share_pref_utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_sample/model/sanluongchung_model.dart';
import 'package:flutter_sample/utils/key.dart';
import 'dart:convert';
import 'dart:async';

class FirstFragment extends StatelessWidget {
  final WebSocketChannel channel;

  FirstFragment({Key key, @required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: new FirstPage(
        channel: channel,
      ),
    );
  }
}

class FirstPage extends StatefulWidget {
  final WebSocketChannel channel;
  FirstPage({Key key, @required this.channel}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var token = "", users = "";

  @override
  void initState() {
    SharePreUtils sharePreUtils = new SharePreUtils();
    sharePreUtils.getPref("token").then(initToken);
    sharePreUtils.getPref("name").then(initUser);
    super.initState();
    getsanluong();
  }

  void getsanluong() {
    var obj = new SanLuong(
        action: KeyUtils.sanluongchungaction, key: "", user: users);
    widget.channel.sink.add(json.encode(obj.toMap()));

    // Stream<dynamic> broad = widget.channel.stream.asBroadcastStream();
    // broad.listen((message) => print("class b: "+message));
    // widget.channel.stream.listen((content) {
    //     SanLuongChungList sanluongs = SanLuongChungList.fromJson(json.decode(content));
    //       sanluongs.sanluongs
    //           .forEach((element) => print(element.ngay + '-' + element.sanluong.toString()));
    // });
  }

  void initToken(String _token) {
    setState(() {
      this.token = _token;
    });
  }

  void initUser(String _user) {
    setState(() {
      this.users = _user;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildListTile(String title) {
      return new ListTile(
          leading: new Icon(
            Icons.calendar_view_day,
            color: Colors.blue,
            size: 26.0,
          ),
          title: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(title),
              ),
              new Expanded(
                child: new Text("100"),
              ),
              new Text("Tấn"),
            ],
          ));
    }

    final card = new Card(
      color: Colors.white70,
      child: new Column(
        children: <Widget>[
          new ListTile(
            leading: new Icon(
              Icons.date_range,
              color: Colors.blue,
              size: 26.0,
            ),
            title: new Text("Ngày 16-08-2018"),
          ),
          new Divider(
            color: Colors.blue,
            indent: 16.0,
          ),
          buildListTile("Hải Dương"),
          buildListTile("Hà Nam"),
          buildListTile("Đồng Nai")
        ],
      ),
    );

    final sizeBox = new Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: new SizedBox(
        child: card,
        height: 260.0,
      ),
    );

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[sizeBox, sizeBox],
    );
  }
}
