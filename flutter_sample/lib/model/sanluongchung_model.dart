class SanLuong {
  final String action;
  final String key;
  final String user;
  final int sanluong;
  final String ngay;

  SanLuong({this.action, this.key, this.user, this.sanluong, this.ngay});
  Map<String, dynamic> toMap() {
    return {
      "user": user,
      "action": action,
      "key": key,
    };
  }

  factory SanLuong.fromJson(Map<String, dynamic> json) {
    return new SanLuong(sanluong: json['Tong'], ngay: json["Ngay"]);
  }
}

class SanLuongChungList {
  List<SanLuong> sanluongs;

  SanLuongChungList({this.sanluongs});

  factory SanLuongChungList.fromJson(List<dynamic> parsedJson) {
    List<SanLuong> sanluong = new List<SanLuong>();
    sanluong = parsedJson.map((i) => SanLuong.fromJson(i)).toList();
    
    return new SanLuongChungList(sanluongs: sanluong);
  }
}