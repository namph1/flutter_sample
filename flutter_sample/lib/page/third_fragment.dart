import 'package:flutter/material.dart';
import 'package:menu_swipe_helpers/menu_swipe_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sample/utils/key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sample/model/daily_model.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';

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
      'http://' + KeyUtils.url + ':5000/getdailytheotiepthi?mnvtt=' + manvtt);
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
  // List _cities = ["Select"];

  // @override
  // void initState() {
  //   _dropDownMenuItems = getDropDownMenuItems();
  //   _currentCity = _dropDownMenuItems[0].value;
  //   super.initState();
  // }

  // List<DropdownMenuItem<String>> getDropDownMenuItems() {
  //   List<DropdownMenuItem<String>> items = new List();
  //   for (String city in _cities) {
  //     items.add(new DropdownMenuItem(
  //         value: city,
  //         child: new Text(
  //           city,
  //           style: TextStyle(color: Colors.blue, fontSize: 20.0),
  //         )));
  //   }
  //   return items;
  // }

  // List<DropdownMenuItem<String>> _dropDownMenuItems;
  // String _currentCity;

  @override
  Widget buildFloatingButton() {
    return new FloatingActionButton(
        child: new Icon(Icons.check),
        onPressed: () => {
              //TODO not implemented
            });
  }

  @override
  buildBody() {
    // void changedDropDownItem(String selectedCity) {
    //   setState(() {
    //     _currentCity = selectedCity;
    //   });
    // }

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
                  ele.fullName,
                  style: TextStyle(color: Colors.blue, fontSize: 20.0),
                ),
              ));
            });
            return Page(dropDownMenuItems: lstDrop,);
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class Page extends StatelessWidget {
  final List<DropdownMenuItem<String>> dropDownMenuItems;

  Page({Key key, this.dropDownMenuItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Đại lý: ",
                  style: new TextStyle(fontSize: 20.0),
                ),
                new Container(
                  padding: new EdgeInsets.all(16.0),
                ),
                new DropdownButton(
                  value: "dropDownMenuItems[0].value",
                  items: dropDownMenuItems,
                  // onChanged: changedDropDownItem,
                ),
              ],
            ),
          ),
          new Divider(),
          new Expanded(
            child: ListView(
              children: <Widget>[
                new ListTile(
                  title: Text('签名'),
                  trailing: new Container(
                    width: 150.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Expanded(
                          flex: 3,
                          child: new TextField(
                            textAlign: TextAlign.end,
                            style: new TextStyle(
                                color: Colors.red, fontSize: 20.0),
                            decoration: new InputDecoration.collapsed(
                                hintText: 'userAddr'),
                          ),
                        ),
                        new Expanded(
                          child: new IconButton(
                            icon: new Icon(Icons.chevron_right),
                            color: Colors.black26,
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
