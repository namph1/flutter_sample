import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_sample/model/khoan_model.dart';
import 'package:flutter_sample/utils/key.dart';
import 'package:flutter/foundation.dart';

class SecondFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(child: new KhoanPage());
  }
}

Future<List<Khoan>> getKhoan(http.Client client) async {
  final response = await client.get('http://' + KeyUtils.url + ':5000/khoan');
  return compute(parseKhoan, response.body);
}

List<Khoan> parseKhoan(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Khoan>((jsons) => Khoan.fromJson(jsons)).toList();
}

class KhoanPage extends StatefulWidget {
  @override
  _KhoanPageState createState() => _KhoanPageState();
}

class _KhoanPageState extends State<KhoanPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Khoan>>(
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
                    '${khoans[position].sotan}',
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
