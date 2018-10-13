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
import 'package:flutter_sample/page/donhang/dathang_detail.dart';

class DatHangScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new DatHangPage(),
    );
  }
}

Future<List<DonDatHang>> getKhoan(http.Client client, int type) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var manvtt = pref.getString("code");
  final response = await client.get('http://' +
      KeyUtils.url +
      ':5000/dondathang?mnvtt=' +
      manvtt +
      '&type=' +
      type.toString());
  return compute(parseChuaXuat, response.body);
}

List<DonDatHang> parseChuaXuat(String responseBody) {
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

  int _curIndex = 0;
  @override
  Widget buildBody() {
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _curIndex,
        onTap: (index) {
          _curIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz),
              title: Text("Chưa xuất"),
              backgroundColor: Colors.white10),
          BottomNavigationBarItem(
              icon: Icon(Icons.input),
              title: Text("Đã xuất"),
              backgroundColor: Colors.white10),
        ],
      ),
      body: _buildBodys(),
    );
  }

  Widget _buildBodys() {
    switch (_curIndex) {
      case 0:
        return _buildContentTab(1);
        break;
      default:
        return _buildContentTab(2);
        break;
    }
  }

  Widget _buildContentTab(int type) {
    return Container(
        child: FutureBuilder<List<DonDatHang>>(
      future: getKhoan(http.Client(), type),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? ListViewKhoan(khoans: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    ));
  }
}

class ListViewKhoan extends StatelessWidget {
  final List<DonDatHang> khoans;
  final int type;

  ListViewKhoan({Key key, this.khoans, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return createBody(khoans);
  }

  Widget createBody(List<DonDatHang> lstDonHang) {
    var f = new NumberFormat("###,###", "en_US");
    return Container(
      child: ListView.builder(
          itemCount: khoans.length,
          itemBuilder: (context, position) {
            return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              child: ListTile(
                leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right:
                                new BorderSide(width: 1.0, color: Colors.red))),
                    child: Text(
                      '${khoans[position].so}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.end,
                    )),
                title: Text(
                  '${khoans[position].madt}',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${khoans[position].hoten}',
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.linear_scale, color: Colors.redAccent),
                        Text('${khoans[position].trangthai}',
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                    Text(
                      '${khoans[position].nguoinhan == null ? '' : khoans[position].nguoinhan}',
                    ),
                  ],
                ),
                trailing: new Column(
                  children: <Widget>[
                    new Text('${f.format(khoans[position].sotien)}'),
                    new Text('${f.format(khoans[position].sokg)}'),
                  ],
                ),
                onTap: () => _onTapItem(context, khoans[position]),
              ),
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, DonDatHang post) {
    // Scaffold.of(context).showSnackBar(new SnackBar(
    //     backgroundColor: Colors.red,
    //     content:
    //         new Text(post.so.toString() + ' - ' + post.sotien.toString())));
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => new DonHangDetail(
              madt: post.madt,
              idkey: post.idkey,
            )));
  }
}
