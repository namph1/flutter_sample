import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_sample/model/khoan_model.dart';
import 'package:flutter_sample/utils/key.dart';
import 'package:flutter/foundation.dart';
import 'package:menu_swipe_helpers/menu_swipe_helpers.dart';

class SecondFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(child: new KhoanPage());
  }
}

//===========================================================================
Future<List<Khoan>> getKhoan(http.Client client) async {
  final response = await client.get('http://' + KeyUtils.url + ':5000/khoan');
  return compute(parseKhoan, response.body);
}

List<Khoan> parseKhoan(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Khoan>((jsons) => Khoan.fromJson(jsons)).toList();
}

//=============================================================================
Future<List<DMKhoan>> getDmKhoan(http.Client client) async {
  final response = await client.get('http://' + KeyUtils.url + ':5000/dmkhoan');
  return compute(parseDmKhoan, response.body);
}

List<DMKhoan> parseDmKhoan(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<DMKhoan>((jsons) => DMKhoan.fromJson(jsons)).toList();
}

//=============================================================================
class KhoanPage extends StatefulWidget {
  @override
  _KhoanPageState createState() => _KhoanPageState();
}

class _KhoanPageState extends State<KhoanPage> with DrawerStateMixin {
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
          BottomNavigationBarItem(icon: Icon(Icons.home), 
          title: Text("Home"), backgroundColor: Colors.white10),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Setting"), backgroundColor: Colors.white10),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Setting"), backgroundColor: Colors.white10),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Setting"), backgroundColor: Colors.white10)
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
              future: getKhoan(http.Client()),
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
          child: new Icon(Icons.directions_bike),
        );
        break;
    }
  }
}

class ListViewKhoan extends StatelessWidget {
  final List<Khoan> khoans;

  ListViewKhoan({Key key, this.khoans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  trailing: new Text(
                    '${khoans[position].sotan} tấn',
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
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
