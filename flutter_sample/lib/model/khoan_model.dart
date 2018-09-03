class Khoan {
  final int id;
  final String makh;
  final String sotan;
  final String tenkh;
  final String diachi;
  final String nguoisua;

  Khoan(
      {this.id, this.makh, this.sotan, this.tenkh, this.diachi, this.nguoisua});

  factory Khoan.fromJson(Map<String, dynamic> json) {
    return Khoan(
      id: json['ID'],
      sotan: json['SoTan'],
      makh: json['MaKH'],
      tenkh: json['TenKH'],
      diachi: json['DiaChiTat'],
      nguoisua: json['NguoiSua'],
    );
  }
}

class DMKhoan {
  final int id;
  final String ten;

  DMKhoan({this.id, this.ten});
  factory DMKhoan.fromJson(Map<String, dynamic> json) {
    return DMKhoan(
      id: json["ID"],
      ten: json["Ten"],
    );
  }
}
