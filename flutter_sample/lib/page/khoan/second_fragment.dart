import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_sample/model/khoan_model.dart';
import 'package:flutter_sample/utils/key.dart';
import 'package:flutter/foundation.dart';
import 'package:menu_swipe_helpers/menu_swipe_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SecondFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(child: new KhoanPage());
  }
}

//===========================================================================
Future<List<Khoan>> getKhoan(http.Client client, int order) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var manvtt = pref.getString("code");
  final response = await client.get('http://' +
      KeyUtils.url +
      ':5000/khoanchitiet?id=' +
      order.toString() +
      '&manvtt=' +
      manvtt);
  return compute(parseKhoan, response.body);
}

List<Khoan> parseKhoan(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Khoan>((jsons) => Khoan.fromJson(jsons)).toList();
}

//=============================================================================
class KhoanPage extends StatefulWidget {
  @override
  _KhoanPageState createState() => _KhoanPageState();
}

class _KhoanPageState extends State<KhoanPage> with DrawerStateMixin {
  var ten1 = '';
  var ten2 = '';
  var id1 = 0;
  var id2 = 0;

  @override
  void initState() {
    super.initState();
    this.getTabName();
  }

  getTabName() async {
    final response = await http.get('http://' + KeyUtils.url + ':5000/dmkhoan');
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    List<DMKhoan> lst =
        parsed.map<DMKhoan>((jsons) => DMKhoan.fromJson(jsons)).toList();
    setState(() {
      ten1 = lst.elementAt(0).ten;
      ten2 = lst.elementAt(1).ten;
      id1 = lst.elementAt(0).id;
      id2 = lst.elementAt(1).id;
    });
  }

  @override
  Widget buildAppBar() {
    return new AppBar(
      title: new Text("Khoán sản lượng"),
    );
  }

  List<Widget> _buildTab() {
    List<Widget> list = new List();

    list.add(new Tab(
      text: "Tháng 7/2018",
    ));
    list.add(new Tab(
      text: "Tháng 6/2018",
    ));

    return list;
  }

  // @override
  // Widget buildBody() {
  //   return new DefaultTabController(
  //     length: 7,
  //     child: new Scaffold(
  //       body: new TabBarView(
  //         children: [
  //           Container(
  //             color: Colors.white,
  //             child: FutureBuilder<List<Khoan>>(
  //               future: getKhoan(http.Client()),
  //               builder: (context, snapshot) {
  //                 if (snapshot.hasError) print(snapshot.error);
  //                 return snapshot.hasData
  //                     ? ListViewKhoan(khoans: snapshot.data)
  //                     : Center(child: CircularProgressIndicator());
  //               },
  //             ),
  //           ),
  //           new Icon(
  //             Icons.directions_bike,
  //             size: 50.0,
  //           ),
  //         ],
  //       ),
  //       bottomNavigationBar: new TabBar(
  //         tabs: this._buildTab(),
  //         labelColor: Colors.red,
  //         unselectedLabelColor: Colors.blue,
  //         indicatorSize: TabBarIndicatorSize.label,
  //         indicatorPadding: EdgeInsets.all(5.0),
  //         indicatorColor: Colors.blue,
  //       ),
  //       backgroundColor: Colors.black12,
  //     ),
  //   );
  // }

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
              icon: Icon(Icons.home),
              title: Text(ten1),
              backgroundColor: Colors.white10),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text(ten2),
              backgroundColor: Colors.white10),
        ],
      ),
      body: new Center(
        child: _getWidget(),
      ),
    );
  }

  Widget _getWidget() {
    switch (_curIndex) {
      case 0:
        return Container(
            // color: Colors.red,
            child: FutureBuilder<List<Khoan>>(
          future: getKhoan(http.Client(), id1),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListViewKhoan(khoans: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ));
        break;
      default:
        return Container(
            // color: Colors.red,
            child: FutureBuilder<List<Khoan>>(
          future: getKhoan(http.Client(), id2),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListViewKhoan(khoans: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ));
        break;
    }
  }
}

class ListViewKhoan extends StatelessWidget {
  final List<Khoan> khoans;

  ListViewKhoan({Key key, this.khoans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     var f = new NumberFormat("###,###", "en_US");
    return Container(
      child: ListView.builder(
          itemCount: khoans.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${khoans[position].tenkh}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  subtitle: Text(
                    '${khoans[position].makh}-${khoans[position].diachi}',
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  trailing: new Container(
                    child: Column(
                      children: <Widget>[
                        new Text(
                          'Mức khoán: ${khoans[position].sotan}',
                          style: TextStyle(color: Colors.red, fontSize: 16.0),
                        ),
                        new Text(
                          'Sản lượng: ${f.format(khoans[position].tong == null ? 0: khoans[position].tong)}',
                          style: TextStyle(color: Colors.blue, fontSize: 16.0),
                        ),
                        new Text(
                          'Thừa/thiếu: ${f.format(khoans[position].sothuathieu == null? 0: khoans[position].sothuathieu)}',
                          style: TextStyle(color: Colors.black, fontSize: 15.0),
                        )
                      ],
                    ),
                  ),
                  onTap: () => _onTapItem(context, khoans[position]),
                ),
              ],
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, Khoan post) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        backgroundColor: Colors.red,
        content: new Text(post.id.toString() + ' - ' + post.makh)));
  }
}
