import 'package:flutter/material.dart';
import 'package:menu_swipe_helpers/menu_swipe_helpers.dart';
import 'package:flutter_sample/model/dondathang_model.dart';
import 'package:flutter_sample/utils/key.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatHangScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new DatHangPage(),
    );
  }
}

Future<List<DonDatHang>> getKhoan(http.Client client) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var manvtt = pref.getString("code");
  final response = await client
      .get('http://' + KeyUtils.url + ':5000/dondathang?mnvtt=' + manvtt);
  return compute(parseKhoan, response.body);
}

List<DonDatHang> parseKhoan(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<DonDatHang>((jsons) => DonDatHang.fromJson(jsons)).toList();
}

class DatHangPage extends StatefulWidget {
  @override
  _DatHangPageState createState() => _DatHangPageState();
}

class _DatHangPageState extends State<DatHangPage> with DrawerStateMixin {
  @override
  Widget buildAppBar() {
    return new AppBar(
      title: new Text("Đơn hàng"),
    );
  }
  
  Widget _buildBody() {
    return Container(
      child: FutureBuilder<List<DonDatHang>>(
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

  @override
  Widget buildBody() {
    return new DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: new TabBar(
          tabs: <Widget>[
            Tab(
              text: "Chưa xuất",
            ),
            Tab(
              text: "Đã xuất",
            ),
          ],
          labelColor: Colors.red,
          unselectedLabelColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Colors.blue,
        ),
        body: new TabBarView(
          children: <Widget>[
            _buildBody(),
            Icon(Icons.directions_bus),
          ],
        ),
      ),
    );
  }
}

class ListViewKhoan extends StatelessWidget {
  final List<DonDatHang> khoans;

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
                      new Text('${f.format(khoans[position].sotien)}'),
                      new Text('${f.format(khoans[position].sokg)}'),
                    ],
                  ),
                  onTap: () => _onTapItem(context, khoans[position]),
                ),
              ],
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, DonDatHang post) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        backgroundColor: Colors.red,
        content:
            new Text(post.so.toString() + ' - ' + post.sotien.toString())));
  }
}
