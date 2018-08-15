class LoginModel {
  final String user;
  final String pass;
  final String email;
  final String action;
  final String key;

  LoginModel({this.user, this.pass, this.email, this.action, this.key});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return new LoginModel(
        user: json['TEN_NHAN_VIEN'].toString(),
        key: json["token"],
        email: json["e_mail"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "user": user,
      "pass": pass,
      "email": email,
      "action": action,
      "key": key,
    };
  }
}

class UserList {
  final List<LoginModel> users;
  UserList({this.users});

  factory UserList.fromJson(List<dynamic> parsedJson) {
    List<LoginModel> users = new List<LoginModel>();
    users = parsedJson.map((i) => LoginModel.fromJson(i)).toList();

    return new UserList(users: users);
  }
}
