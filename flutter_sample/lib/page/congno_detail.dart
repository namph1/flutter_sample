import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter_sample/utils/key.dart';
import 'package:intl/intl.dart';

class CongNoDetailWidget extends StatefulWidget {
  final String madt;

  CongNoDetailWidget(this.madt);

  _CongNoDetailWidgetState createState() => _CongNoDetailWidgetState(madt);
}

class _CongNoDetailWidgetState extends State<CongNoDetailWidget> {
  final String madt;
  String _datetime = 'Chọn tháng';
  int year = 2018;
  int month = 9;
  int date = 3;

  _CongNoDetailWidgetState(this.madt);

  String convertType(String type) {
    String result = type;
    switch (type) {
      case 'SoDK':
        {
          result = 'Dư đầu';
        }
        break;
      case 'BAN':
        {
          result = 'Hóa đơn';
        }
        break;
      case 'PTTM':
        {
          result = 'Tiền mặt';
        }
        break;
      case 'PTCK':
        {
          result = 'Chuyển khoản';
        }
        break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("###,###", "en_US");
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Chi tiết công nợ: $madt'),
      ),
      body: new Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlatButton(
                onPressed: _showDatePicker,
                child: new Icon(Icons.calendar_today),
              ),
              new Text(
                'Tháng $_datetime',
                style: new TextStyle(color: Colors.red, fontSize: 20.0),
              ),
            ],
          ),
          new Divider(),
          new Expanded(
              child: ListView.builder(
            itemCount: list.length,
            itemBuilder: ((BuildContext _context, int position) {
              return new ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  leading: new CircleAvatar(
                    child: new Text(list[position]['Ngày']
                        .toString()
                        .split("T")[0]
                        .split("-")[2]),
                  ),
                  title: new Text((list[position]['Diễn Giải']), style: TextStyle(color: Colors.blue, fontSize: 18.0),),
                  subtitle: new Text(list[position]['Số CT']),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: <Widget>[
                      new Text(
                        (list[position]['Diễn Giải']) == 'KM Tháng trước còn lại:' ?
                        f.format(list[position]['Tiền KM']).toString() :
                        f.format(list[position]['Số Tiền']).toString(),
                       style: TextStyle(color: Colors.orange, fontSize: 20.0),),
                      new Text(list[position]['Loại'] == 'BAN' ? 'Tiền KM: '+f.format(list[position]['Tiền KM']).toString() : ''),
                        
                        
                        // 'Tiền KM: '+f.format(list[position]['Tiền KM']).toString()),
                    ],
                  ));
            }),
          ))
        ],
      ),
    );
  }

  List list = new List();

  void fetchData(String madt, String month) {
    getData(madt, month).then((res) {
      setState(() {
        list.clear();
        list.addAll(res);
      });
    });
  }

  Future<List> getData(String madt, String month) async {
    var url = 'http://' +
        KeyUtils.url +
        ':5000/getdetailfromto?madt=' +
        madt +
        '&month=' +
        month;
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

  void settingDatetime(int year, int month, int date) {
    setState(() {
      this.year = year;
      this.month = month;
      this.date = date;
      _datetime = '$month-$year';
    });
    fetchData(madt, _datetime);
  }

  void _showDatePicker() {
    // final bool showTitleActions = false;
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minYear: 2012,
      maxYear: 2050,
      initialYear: 2018,
      initialMonth: 9,
      locale: 'en',
      dateFormat: 'mm-yyyy',
      onChanged: (year, month, date) {
        // print('onChanged date: $year-$month-$date');
      },
      onConfirm: (year, month, date) {
        settingDatetime(year, month, date);
      },
    );
  }
}
