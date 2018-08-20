import 'package:web_socket_channel/io.dart';

class MyChannel {
  IOWebSocketChannel channel;
  String result;

  MyChannel({this.channel, this.result});

  String get _result => this.result;

  void listen() {
    channel.stream.listen((message) {
      result = message;
    });
  }
}
