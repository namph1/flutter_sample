import 'package:flutter/material.dart';
import 'package:flutter_sample/page/first_fragment.dart';
import 'package:flutter_sample/page/second_fragment.dart';
import 'package:flutter_sample/page/third_fragment.dart';
import 'package:flutter_sample/utils/share_pref_utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  final WebSocketChannel channel;

  HomePage({Key key, @required this.channel}) : super(key: key);

  final drawerItems = [
    new DrawerItem("Trang chủ", Icons.home),
    new DrawerItem("Fragment 2", Icons.local_pizza),
    new DrawerItem("Fragment 3", Icons.info)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState(channel: channel);
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  var username = "", email = "";
  final WebSocketChannel channel;

  HomePageState({Key keys, @required this.channel});

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

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new FirstFragment(
          channel: channel,
        );
      case 1:
        return new SecondFragment();
      case 2:
        return new ThirdFragment();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(username),
              accountEmail: new Text(email),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: AssetImage("assets/alucard.jpg"),
                backgroundColor: Colors.white,
              ),
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
