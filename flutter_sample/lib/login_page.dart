import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_sample/home_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_sample/utils/key.dart';
import 'package:flutter_sample/model/login_model.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  final WebSocketChannel channel;

  LoginPage({Key key, @required this.channel}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

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
      // initialValue: 'some password',
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
      return pref.commit();
    }

    void _onLogin() {
      var ojb = new LoginModel(
        action: KeyUtils.loginaction,
        email: emailController.text,
        user: emailController.text,
        pass: passController.text,
        key: '',
      );
      widget.channel.sink.add(json.encode(ojb.toMap()));

      widget.channel.stream.listen((content) {
        print(content);
        List<LoginModel> users = UserList.fromJson(json.decode(content)).users;
        if (users.length == 1) {
          var user = users[0];
          saveUserInfo(user).then((bool commited) {
            print(commited);
            Navigator.of(context).pushNamed(HomePage.tag);
          });
        }
      });
    }

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: _onLogin,
          color: Colors.lightBlueAccent,
          child: Text('Đăng nhập', style: TextStyle(color: Colors.white)),
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
