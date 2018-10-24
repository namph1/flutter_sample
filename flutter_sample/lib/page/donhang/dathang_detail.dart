import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_sample/utils/key.dart';
import 'package:flutter_sample/model/dondathang_model.dart';
import 'package:flutter_sample/model/donhang_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonHangDetail extends StatefulWidget {
  final String madt;
  final String idkey;
  final int type;

  DonHangDetail({this.madt, this.idkey, this.type});

  _DonHangDetailState createState() =>
      _DonHangDetailState(madt: madt, idkey: idkey, type: type);
}

Map<String, int> mapsp = new Map();

Future<List<DonHangDetailModel>> getDonHang(
    http.Client client, String idkey) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString("token");
  final response = await client.get('http://' +
      KeyUtils.url +
      ':5000/getchitietdonhang?idkey=' +
      idkey +
      '&token=' +
      token);
  return compute(parseDonHang, response.body);
}

List<DonHangDetailModel> parseDonHang(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<DonHangDetailModel>((jsons) => DonHangDetailModel.fromJson(jsons))
      .toList();
}

Future<List<DonHangModel>> getDsach(http.Client client, String madt) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString("token");
  final response = await client.get('http://' +
      KeyUtils.url +
      ':5000/dshanghoadaily?madt=' +
      madt +
      '&token=' +
      token);
  return compute(parseDanhsach, response.body);
}

List<DonHangModel> parseDanhsach(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<DonHangModel>((jsons) => DonHangModel.fromJson(jsons))
      .toList();
}

class _DonHangDetailState extends State<DonHangDetail> {
  final String madt;
  final String idkey;
  final int type;

  _DonHangDetailState({this.madt, this.idkey, this.type});

  int _curIndex = 0;

  Widget _buildAction() {
    if (_curIndex == 0 || type == 2) {
      return new Container();
    } else {
      return IconButton(
        icon: const Icon(Icons.check),
        color: Colors.orangeAccent,
        tooltip: 'Lưu thay đổi',
        onPressed: save,
      );
    }
  }

  Future<String> saveData(String address, int port, String mess) async {
    List<int> buffer = [];
    Socket socket;
    try {
      socket = await Socket.connect(address, port);
      var encoded = utf8.encode(mess);
      socket.add(encoded);

      await for (List<int> v in socket.asBroadcastStream()) {
        buffer.addAll(v);
        if (buffer.length >= 7) {
          break;
        }
      }
    } on Exception {} finally {
      socket.destroy();
    }

    return utf8.decode(buffer);
  }

  void save() async {
    var obj = new DonHangModelOri(
      action: KeyUtils.donhangaction,
      makh: madt,
      lstHangHoa: mapsp,
      key: '',
      idkey: idkey,
    );
    await saveData(
        KeyUtils.url, KeyUtils.portTcp, json.encode(obj.toMap()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Đơn hàng của: $madt'),
        automaticallyImplyLeading: true,
        primary: true,
        actions: <Widget>[_buildAction()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curIndex,
        onTap: (index) {
          _curIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz),
              title: Text("Hiện tại"),
              backgroundColor: Colors.white10),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              title: Text("Chỉnh sửa"),
              backgroundColor: Colors.white10),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_curIndex) {
      case 0:
        return new Container(
          child: FutureBuilder<List<DonHangDetailModel>>(
            future: getDonHang(http.Client(), idkey),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? _BuildDetailWidget(lstDetails: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
        );
        break;
      default:
        return new Container(
          child: FutureBuilder<List<DonHangModel>>(
            future: getDsach(http.Client(), madt),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? _BuildEditWidget(lstDetails: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
        );
        break;
    }
  }
}

class _BuildEditWidget extends StatelessWidget {
  final List<DonHangModel> lstDetails;
  _BuildEditWidget({this.lstDetails});

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: ListView.builder(
      itemCount: lstDetails.length,
      itemBuilder: ((BuildContext _context, int position) {
        return new Card(
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
                title: new Text('${lstDetails[position].tentp}'),
                subtitle: new Text('${lstDetails[position].baobi}'),
                trailing: new Container(
                  width: 100.0,
                  child: new TextField(
                    cursorColor: Colors.red,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    decoration: new InputDecoration.collapsed(
                        hintText: mapsp.containsKey(
                                    '${lstDetails[position].matp.toUpperCase()}') ==
                                true
                            ? mapsp['${lstDetails[position].matp}'].toString()
                            : '0'),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      var count = int.parse(text);
                      if (count >= 0) {
                        var key = '${lstDetails[position].matp}';
                        mapsp[key] = count;
                      }
                    },
                  ),
                )));
      }),
    ));
  }
}

class _BuildDetailWidget extends StatelessWidget {
  final List<DonHangDetailModel> lstDetails;

  _BuildDetailWidget({this.lstDetails});
  @override
  Widget build(BuildContext context) {
    mapsp.clear();
    lstDetails.forEach((ele) {
      mapsp[ele.matp.toUpperCase()] = ele.soluong;
    });

    return new Container(
      child: ListView.builder(
        itemCount: lstDetails.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
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
                      '${lstDetails[position].soluong}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.end,
                    )),
                title: Text(
                  '${lstDetails[position].tentp}',
                ),
                subtitle: Center(
                  child: Row(
                    children: <Widget>[
                      Text('${lstDetails[position].baobi}'),
                      // Icon(Icons.star, color: Colors.blueAccent),
                    ],
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('Tồn kho: ${lstDetails[position].tonkho}',
                        style: TextStyle(
                            color: lstDetails[position].tonkho <= 0
                                ? Colors.red
                                : Colors.black)),
                    Text(
                      'Dư Sau ĐH: ${lstDetails[position].dusaudh}',
                      style: TextStyle(
                          color: lstDetails[position].dusaudh <= 0
                              ? Colors.red
                              : Colors.black),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
