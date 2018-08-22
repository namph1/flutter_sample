import 'package:flutter/material.dart';
import 'package:flutter_sample/page/first_fragment.dart';
import 'package:flutter_sample/page/second_fragment.dart';
import 'package:flutter_sample/page/third_fragment.dart';
import 'package:flutter_sample/page/dathang_page.dart';
import 'package:flutter_sample/utils/share_pref_utils.dart';
import 'package:menu_swipe_helpers/menu_swipe_helpers.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String username = "", email = "";

  @override
  void initState() {
    SharePreUtils shareUtils = new SharePreUtils();
    shareUtils.getPref("name").then(intiUserName);
    shareUtils.getPref("email").then(intiEmail);
    super.initState();
  }

  void intiUserName(String _username) {
    setState(() {
      this.username = _username;
    });
  }

  void intiEmail(String _email) {
    setState(() {
      this.email = _email;
    });
  }

  static Widget _userAccountDrawer(BuildContext context) =>
      new UserAccountsDrawerHeader(
        accountName: new Text(""),
        accountEmail: new Text("yann@fidelisa.com"),
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
      title: "Đặt hàng",
      iconData: Icons.event_note,
      widgetBuilder: (BuildContext context) => new DatHang_Page());

  var _drawerBuilder = new DrawerHelper(
    drawerContents: [_firstPage, _secondPage, _thirdPage, _fourPage],
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
