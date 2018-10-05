import 'package:flutter/material.dart';
import 'package:flutter_sample/page/trangchu/first_fragment.dart';
import 'package:flutter_sample/page/khoan/second_fragment.dart';
import 'package:flutter_sample/page/dathang/third_fragment.dart';
import 'package:flutter_sample/page/donhang/dathang_page.dart';
import 'package:flutter_sample/page/congno/congno_page.dart';
import 'package:flutter_sample/page/bieudo.dart';
import 'package:flutter_sample/page/thanhpham/tonkho/tonkho_page.dart';
import 'package:menu_swipe_helpers/menu_swipe_helpers.dart';

var name, emails;

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  final String user, email;

  HomePage({Key key, this.user, this.email}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    name = this.user;
    emails = this.email;
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  static Widget _userAccountDrawer(BuildContext context) =>
      new UserAccountsDrawerHeader(
        accountName: new Text(name),
        accountEmail: new Text(emails),
        currentAccountPicture: new CircleAvatar(
          backgroundImage: AssetImage("assets/alucard.jpg"),
          backgroundColor: Colors.white,
        ),
        margin: EdgeInsets.zero,
      );

  static final _firstPage = new DrawerDefinition(
      title: "Trang chủ",
      iconData: Icons.home,
      widgetBuilder: (BuildContext context) => new FirstFragment());

  static final _secondPage = new DrawerDefinition(
    title: "Khoán sản lượng",
    iconData: Icons.store,
    widgetBuilder: (BuildContext context) => new SecondFragment(),
  );

  static final _thirdPage = new DrawerDefinition(
      title: "Đặt hàng",
      iconData: Icons.email,
      widgetBuilder: (BuildContext context) => new ThirdFragment());
  static final _fourPage = new DrawerDefinition(
      title: "Đơn hàng",
      iconData: Icons.event_note,
      widgetBuilder: (BuildContext context) => new DatHangScreen());

  static final _khoTP = new DrawerDefinition(
      title: "Kho Thành phẩm",
      iconData: Icons.atm,
      widgetBuilder: (BuildContext context) => new TonKhoPage());

  static final _congNo = new DrawerDefinition(
      title: "Công nợ",
      iconData: Icons.euro_symbol,
      widgetBuilder: (BuildContext context) => new CongNoScreen());

  var _drawerBuilder = new DrawerHelper(
    drawerContents: [_firstPage, _secondPage, _thirdPage, _fourPage, _khoTP, _congNo],
    userAccountsDrawerHeader: _userAccountDrawer,
  );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new DrawerProvider(
        drawer: _drawerBuilder,
        child: new FirstFragment(),
      ),
    );
  }
}
