import 'package:flutter/material.dart';
import 'package:menu_swipe_helpers/menu_swipe_helpers.dart';
import 'package:flutter_sample/utils/key.dart';
import 'package:flutter_sample/model/tonkho_model.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class TonKhoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ContenPage(),
    );
  }
}

Future<List<TonKhoModel>> getKhoan(http.Client client) async {
  // SharedPreferences pref = await SharedPreferences.getInstance();
  final response =
      await client.get('http://' + KeyUtils.url + ':5000/gettonkho');
  return compute(parseKhoan, response.body);
}

List<TonKhoModel> parseKhoan(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<TonKhoModel>((jsons) => TonKhoModel.fromJson(jsons))
      .toList();
}

class ContenPage extends StatefulWidget {
  @override
  _ContenPageState createState() => _ContenPageState();
}

class _ContenPageState extends State<ContenPage> with DrawerStateMixin {
  @override
  Widget buildAppBar() {
    return new AppBar(
      title: new Text("Tồn kho"),
    );
  }

  @override
  Widget buildBody() {
    return Container(
      child: FutureBuilder<List<TonKhoModel>>(
        future: getKhoan(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? TonKhoWidget(lstTonkho: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

//----------------
class TonKhoWidget extends StatelessWidget {
  final List<TonKhoModel> lstTonkho;
  TonKhoWidget({Key key, this.lstTonkho}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("###,###", "en_US");
    return Container(
      child: ListView.builder(
        itemCount: lstTonkho.length,
        itemBuilder: (context, position) {
          return Card(
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromRGBO(230, 230, 230, 0.9)),
              child: ListTile(
                leading: Container(
                  // padding: EdgeInsets.only(right: 100.0),
                  child: new Column(
                    children: <Widget>[
                      Text(
                        '${lstTonkho[position].tentp}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text('${lstTonkho[position].gio}'),
                      // Text('${lstTonkho[position].matp}'),
                    ],
                  ),
                ),
                // title: Container(
                //   child:
                //       Text('Tồn kho: ${f.format(lstTonkho[position].tonkho)}'),
                // ),
                subtitle: Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Tồn kho: ${f.format(lstTonkho[position].tonkho)}',
                        style:
                            TextStyle(fontSize: 15.0, color: Colors.redAccent),
                      ),
                      Text(
                          'Đợi xuất: ${f.format(lstTonkho[position].doixuat)}'),
                      Text(
                        'Sau đợi xuất: ${f.format(lstTonkho[position].saudoixuat)}',
                        style:
                            TextStyle(fontSize: 15.0, color: Colors.blueAccent),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
