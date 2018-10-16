import 'package:flutter/material.dart';
import 'package:menu_swipe_helpers/menu_swipe_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sample/utils/key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sample/model/daily_model.dart';
import 'package:flutter_sample/model/donhang_model.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

class ThirdFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new SanPhamPage(),
    );
  }
}

Future<List<DaiLy>> getDaiLy(http.Client client) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var manvtt = pref.getString("code");
  final response = await client.get(
      'http://' + KeyUtils.url + ':5000/getdailytheotiepthi?manv=' + manvtt);
  return compute(parseDaiLy, response.body);
}

List<DaiLy> parseDaiLy(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<DaiLy>((jsons) => DaiLy.fromJson(jsons)).toList();
}

class SanPhamPage extends StatefulWidget {
  @override
  _SanPhamPageState createState() => _SanPhamPageState();
}

class _SanPhamPageState extends State<SanPhamPage> with DrawerStateMixin {
  @override
  Widget buildAppBar() {
    return new AppBar(
      title: new Text("Đặt hàng"),
    );
  }

  @override
  Widget buildFloatingButton() {
    return new FloatingActionButton(
      child: new Icon(Icons.check),
      onPressed: this.luuDonHang,
    );
  }

  void insert(String dataInput) async {
    var url = 'http://' + KeyUtils.url + ':5000/insertNew?data=' + dataInput;
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var jsonString = await response.transform(utf8.decoder).join();
      print(jsonString);
    } else {
    }
  }

  void sendDonHangToServer() async {
    var obj = new DonHangModelOri(
      action: KeyUtils.donhangaction,
      makh: makh,
      lstHangHoa: mapsp,
      key: '',
      idkey: '',
    );
    insert(json.encode(obj.toMap()));
    // var channel = IOWebSocketChannel.connect("ws://" + KeyUtils.url + ":5001");
    // channel.sink.add(json.encode(obj.toMap()));
    // channel.sink.close();
  }

  List<Widget> _buildContentDialog() {
    List<Widget> list = new List();
    mapsp.forEach((key, value) {
      list.add(new Text('${key} : ${value}'));
    });
    return list;
  }

  void luuDonHang() {
    int countSp = mapsp.length;
    if (countSp > 0) {
      showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text("Mặt hàng đã chọn"),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: this._buildContentDialog(),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: Text(
                "Hủy",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
            new FlatButton(
              child: Text(
                "Lưu",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () {
                sendDonHangToServer();
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Icon(
              Icons.error,
            ),
            content: new Text("Chưa chọn mặt hàng"),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  "Đóng",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  buildBody() {
    mapsp.clear();
    return new Container(
      child: FutureBuilder<List<DaiLy>>(
        future: getDaiLy(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          } else if (snapshot.hasData) {
            List<DropdownMenuItem<String>> lstDrop = new List();
            snapshot.data.forEach((ele) {
              lstDrop.add(new DropdownMenuItem(
                value: ele.code,
                child: new Text(
                  ele.code,
                  style: TextStyle(color: Colors.blue, fontSize: 20.0),
                ),
              ));
            });
            return PageDrop(
              dropDownMenuItems: lstDrop,
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

Map<String, int> mapsp = new Map();
String makh;

class PageDrop extends StatefulWidget {
  final List<DropdownMenuItem<String>> dropDownMenuItems;

  PageDrop({this.dropDownMenuItems});

  PageDropState createState() =>
      PageDropState(dropDownMenuItems: dropDownMenuItems);
}

class PageDropState extends State<PageDrop> {
  final List<DropdownMenuItem<String>> dropDownMenuItems;

  PageDropState({Key key, this.dropDownMenuItems});

  String selectvalue;
  List list = new List();

  void fetchData(String madt) {
    getData(madt).then((res) {
      setState(() {
        list.clear();
        list.addAll(res);
      });
    });
  }

  @override
  void initState() {
    selectvalue = dropDownMenuItems.first.value;
    super.initState();
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      selectvalue = selectedCity;
      makh = selectedCity;
    });
    fetchData(selectedCity);
  }

  Future<List> getData(String madt) async {
    var url = 'http://' + KeyUtils.url + ':5000/dshanghoadaily?madt=' + madt;
    List data = new List();
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var jsonString = await response.transform(utf8.decoder).join();
      data = json.decode(jsonString);
      return data;
    } else {
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Text(
                  "Đại lý: ",
                  style: new TextStyle(fontSize: 20.0),
                ),
                new Container(
                  padding: new EdgeInsets.all(16.0),
                ),
                new DropdownButton(
                  value: selectvalue,
                  items: dropDownMenuItems,
                  onChanged: changedDropDownItem,
                ),
              ],
            ),
          ),
          new Divider(),
          new Expanded(
              child: ListView.builder(
            itemCount: list.length,
            itemBuilder: ((BuildContext _context, int position) {
              return Card(
                  child: new ListTile(
                leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right:
                                new BorderSide(width: 1.0, color: Colors.red))),
                    child: Text(
                      '${position + 1}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.end,
                    )),
                title: new Text('${list[position]['TENTP']}'),
                subtitle: new Text(
                    '${list[position]["TenFull"].toString().split("(")[1].replaceAll(")", "")}'),
                trailing: new Container(
                  width: 100.0,
                  child: new TextField(
                    cursorColor: Colors.red,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    decoration: new InputDecoration.collapsed(hintText: '0'),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      var count = int.parse(text);
                      if (count > 0) {
                        var key = '${list[position]["MATP"]}';
                        mapsp[key] = count;
                      }
                    },
                  ),
                ),
              ));
            }),
          )),
        ],
      ),
    );
  }
}

// child: ListView(
//               children: <Widget>[
//                 new ListTile(
//                   title: Text('签名'),
//                   trailing: new Container(
//                     width: 150.0,
//                     child: new Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: <Widget>[
//                         new Expanded(
//                           flex: 3,
//                           child: new TextField(
//                             textAlign: TextAlign.end,
//                             style: new TextStyle(
//                                 color: Colors.red, fontSize: 20.0),
//                             decoration: new InputDecoration.collapsed(
//                                 hintText: 'userAddr'),
//                           ),
//                         ),
//                         new Expanded(
//                           child: new IconButton(
//                             icon: new Icon(Icons.chevron_right),
//                             color: Colors.black26,
//                             onPressed: () {},
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
