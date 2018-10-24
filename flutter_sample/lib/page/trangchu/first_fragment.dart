import 'package:flutter/material.dart';
import 'package:flutter_sample/utils/share_pref_utils.dart';
import 'package:flutter_sample/utils/key.dart';
import 'package:flutter_sample/model/sanluongchung_model.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:menu_swipe_helpers/menu_swipe_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with DrawerStateMixin {
  var  users = "";
  var ngayHD = 0,
      ngayDN = 0,
      ngayHN = 0,
      thangHD = 0,
      thangDN = 0,
      thangHN = 0,
      ngay = '';
  var f = new NumberFormat("###,###", "en_US");
  @override
  void initState() {
    SharePreUtils sharePreUtils = new SharePreUtils();
    // sharePreUtils.getPref("token").then(initToken);
    sharePreUtils.getPref("name").then(initUser);
    super.initState();
    ngayHD = 500000000;
    this.getHome();
  }

  getHome() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    final response = await http.get('http://' + KeyUtils.url + ':5000/home?token='+ token);

    if (response.statusCode == 200) {
      SanLuongChungList sanluongs =
          SanLuongChungList.fromJson(json.decode(response.body));
      setState(() {
        ngayHD = sanluongs.sanluongs[0].sanluong;
        ngayDN = sanluongs.sanluongs[1].sanluong;
        ngayHN = sanluongs.sanluongs[2].sanluong;
        thangHD = sanluongs.sanluongs[3].sanluong;
        thangDN = sanluongs.sanluongs[4].sanluong;
        thangHN = sanluongs.sanluongs[5].sanluong;
        ngay = sanluongs.sanluongs[0].ngay.toString().substring(0, 10);
      });
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  // void initToken(String _token) {
  //   setState(() {
  //     this.token = _token;
  //   });
  // }

  void initUser(String _user) {
    setState(() {
      this.users = _user;
    });
  }

  @override
  Widget buildAppBar() {
    return new AppBar(
      title: new Text("Trang chủ"),
    );
  }

  @override
  Widget buildBody() {
    Widget buildListTile(String title, int sanluong) {
      return new ListTile(
          leading: new Icon(
            Icons.calendar_view_day,
            color: Colors.blue,
            size: 26.0,
          ),
          title: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(title),
              ),
              new Expanded(
                child: new Text(
                  f.format(sanluong),
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              new Text("Tấn"),
            ],
          ));
    }

    Widget _buildCard(String titleCard, dynamic sl1, dynamic sl2, dynamic sl3) {
      return new Card(
        color: Colors.white70,
        child: new Column(
          children: <Widget>[
            new ListTile(
              leading: new Icon(
                Icons.date_range,
                color: Colors.blue,
                size: 26.0,
              ),
              title: new Text(titleCard),
            ),
            new Divider(
              color: Colors.blue,
              indent: 16.0,
            ),
            buildListTile("Hải Dương", sl1),
            buildListTile("Hà Nam", sl2),
            buildListTile("Đồng Nai", sl3)
          ],
        ),
      );
    }

    Widget _buildBox(String titleCard, dynamic sl1, dynamic sl2, dynamic sl3) {
      return new Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //   image: AssetImage("image/bg_purple_card.png"),
        //   fit: BoxFit.fill,
        // )),
        child: new SizedBox(
          child: _buildCard(titleCard, sl1, sl2, sl3),
          height: 260.0,
        ),
      );
    }

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildBox("Sản lượng ngày " + ngay.toString(), ngayHD, ngayHN, ngayDN),
        _buildBox(
            "Sản lượng tháng " +
                (ngay.isNotEmpty ? ngay.substring(0, 7) : ngay),
            thangHD,
            thangHN,
            thangDN)
      ],
    );

    // return new Container(
    //   height: 600.0,
    //     child: new Column(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     new Expanded(
    //       child: CardWidget(
    //         titleLocation: "Hải Dương",
    //         slNgay: ngayHD,
    //         slThang: thangHD,
    //       ),
    //     ),
    //     new Expanded(
    //       child: CardWidget(
    //         titleLocation: "Hải Dương",
    //         slNgay: ngayHD,
    //         slThang: thangHD,
    //       ),
    //     ),
    //   ],
    // ));

    // return new Container(
    //   margin: EdgeInsets.only(top: 10.0),
    //   child: CardWidget(
    //     titleLocation: "Hải Dương",
    //     slNgay: ngayHD,
    //     slThang: thangHD,
    //   ),
    // );
  }
}

class CardWidget extends StatelessWidget {
  final String titleLocation;
  final dynamic slNgay;
  final dynamic slThang;

  CardWidget({this.titleLocation, this.slNgay, this.slThang});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("image/bg_purple_card.png"),
        fit: BoxFit.fitWidth,
      )),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0, right: 16.0),
                    child: Text(
                      'BALANCE',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      '\$ $slNgay',
                      style: TextStyle(
                          color: Colors.white,
//                        fontSize: 10.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  titleLocation,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'VALID\nTHRU',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        slThang.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                child: Text(
                  slNgay.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
