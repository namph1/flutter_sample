class DaiLy{
  final String code;
  final String name;
  final String address;
  final String fullName;

  DaiLy({this.code, this.name, this.address, this.fullName});

  factory DaiLy.fromJson(Map<String, dynamic> json){
    return DaiLy(
      code: json["MKH"],
      name: json["TEN_KHACH_HANG"],
      address: json["DIA_CHI"],
      fullName: json["TenKH"],
    );
  }
}