import 'package:flutter/material.dart';
import 'package:menu_swipe_helpers/menu_swipe_helpers.dart';

class ThirdFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: new SanPhamPage(),
    );
  }
}

class SanPhamPage extends StatefulWidget {
  @override
  _SanPhamPageState createState() => _SanPhamPageState();
}

class _SanPhamPageState extends State<SanPhamPage> with DrawerStateMixin {
  @override
  buildBody() {
    return new Container(
      color: Colors.white30,
      child: new GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: <String>[
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',
            'http://www.for-example.org/img/main/forexamplelogo.png',

          ].map((String url) {
            return new GridTile(
                child: new Image.network(url, fit: BoxFit.cover));
          }).toList()),
    );
  }
}
