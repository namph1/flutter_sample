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
import 'package:flutter_sample/page/congno_detail.dart';

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
            return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: new ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: new Text('${f.format(khoans[position].sono)}', style: TextStyle(color: Colors.white),),
                  ),
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
                      color: Colors.white
                    ),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Colors.white, size: 30.0),
                  onTap: () => _onTapItem(context, khoans[position]),
                ),
              ),
            );

            // return Column(
            //   children: <Widget>[
            //     ListTile(
            //       title: Text(
            //         '${khoans[position].madt}',
            //         style: TextStyle(
            //           fontSize: 18.0,
            //           color: Colors.deepOrangeAccent,
            //         ),
            //       ),
            //       subtitle: Text(
            //         '${khoans[position].hoten}',
            //         style: new TextStyle(
            //           fontSize: 18.0,
            //           fontStyle: FontStyle.italic,
            //         ),
            //       ),
            //       trailing: new Column(
            //         children: <Widget>[
            //           new Text('${f.format(khoans[position].sono)}'),
            //         ],
            //       ),
            //       onTap: () => _onTapItem(context, khoans[position]),
            //     ),
            //   ],
            // );
          }),
    );
  }

  void _onTapItem(BuildContext context, CongNoModel post) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => new CongNoDetailWidget(post.madt)));
  }
}
