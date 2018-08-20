import 'package:flutter/material.dart';
import 'my_channel.dart';

class Provider extends InheritedWidget {
  final MyChannel myChannel;
  final Widget child;

  Provider({this.myChannel, this.child}) : super(child: child);

  static Provider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(Provider);

  @override
  bool updateShouldNotify(Provider oldWidget) {
    return myChannel != oldWidget.myChannel;
  }
}
