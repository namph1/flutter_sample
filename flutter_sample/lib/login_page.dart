import 'package:flutter/material.dart';
import 'package:flutter_sample/home_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_sample/utils/key.dart';
import 'package:flutter_sample/model/login_model.dart';
import 'package:web_socket_channel/io.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text: 'namph');
  final passController = TextEditingController(text: '123456a@A');

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      controller: emailController,
    );

    final password = TextField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      controller: passController,
    );

    Future<bool> saveUserInfo(LoginModel userInfo) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', userInfo.key);
      pref.setString('email', userInfo.email);
      pref.setString('name', userInfo.user);
      pref.setString("code", userInfo.code);
      return true;
    }

    void _onLogin() {
      var ojb = new LoginModel(
        action: KeyUtils.loginaction,
        email: emailController.text,
        user: emailController.text,
        pass: passController.text,
        key: '',
      );
      var channel =
          IOWebSocketChannel.connect("ws://" + KeyUtils.url + ":5001");
      channel.sink.add(json.encode(ojb.toMap()));

      channel.stream.listen((content) {
        List<LoginModel> users = UserList.fromJson(json.decode(content)).users;
        if (users.length == 1) {
          var user = users[0];
          saveUserInfo(user).then((bool commited) {
            channel.sink.close();
            // Navigator.of(context).pushNamed(HomePage.tag);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                        user: user.user,
                        email: user.email,
                      ),
                ));
          });
        }
      });
    }

    final loginButton = new GestureDetector(
      onTap: _onLogin,
      child: new Container(
        width: 100.0,
        height: 40.0,
        alignment: FractionalOffset.center,
        decoration: new BoxDecoration(
          color: const Color.fromRGBO(51, 204, 255, 1.0),
          borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
        ),
        child: new Text(
          "Đăng nhập",
          style: new TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Quên mật khẩu?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel,
          ],
        ),
      ),
    );
  }
}
