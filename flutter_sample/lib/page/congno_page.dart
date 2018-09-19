import 'package:flutter/material.dart';
import 'package:menu_swipe_helpers/menu_swipe_helpers.dart';
import 'package:flutter_sample/utils/key.dart';
import 'package:flutter_sample/model/congno_model.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CongNoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new CongNoPage(),
    );
  }
}

Future<List<CongNoModel>> getKhoan(http.Client client) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var manvtt = pref.getString("code");
  final response = await client.get('http://' +
      KeyUtils.url +
      ':5000/getcongnohientaitonghop?manv=' +
      manvtt);
  return compute(parseKhoan, response.body);
}

List<CongNoModel> parseKhoan(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<CongNoModel>((jsons) => CongNoModel.fromJson(jsons))
      .toList();
}

class CongNoPage extends StatefulWidget {
  CongNoPageState createState() => CongNoPageState();
}

class CongNoPageState extends State<CongNoPage> with DrawerStateMixin {
  @override
  Widget buildAppBar() {
    return new AppBar(
      title: new Text("Công nợ"),
    );
  }

  @override
  Widget buildBody() {
    return Container(
      child: FutureBuilder<List<CongNoModel>>(
        future: getKhoan(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListViewKhoan(khoans: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

//------------------------------------------------
class ListViewKhoan extends StatelessWidget {
  final List<CongNoModel> khoans;

  ListViewKhoan({Key key, this.khoans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("###,###", "en_US");
    return Container(
      child: ListView.builder(
          itemCount: khoans.length,
          // padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    '${khoans[position].madt}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  subtitle: Text(
                    '${khoans[position].hoten}',
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  trailing: new Column(
                    children: <Widget>[
                      new Text('${f.format(khoans[position].sono)}'),
                    ],
                  ),
                  onTap: () => _onTapItem(context, khoans[position]),
                ),
              ],
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, CongNoModel post) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        backgroundColor: Colors.red,
        content:
            new Text(post.madt.toString() + ' - ' + post.sono.toString())));
  }
}

