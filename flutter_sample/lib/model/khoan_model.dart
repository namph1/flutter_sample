class Khoan {
  final int id;
  final String makh;
  final String sotan;
  final String tenkh;
  final String diachi;
  final String nguoisua;
  final int tong;
  final int sothuathieu;

  Khoan(
      {this.id, this.makh, this.sotan, this.tenkh, 
      this.diachi, this.nguoisua, this.tong, this.sothuathieu});

  factory Khoan.fromJson(Map<String, dynamic> json) {
    return Khoan(
      id: json['ID'],
      sotan: json['MucKhoan'],
      makh: json['MaDT'],
      tenkh: json['TEN_KHACH_HANG'],
      diachi: json['DiaChiTat'],
      nguoisua: json['NguoiSua'],
      tong: json['Tong'],
      sothuathieu: json['SoThuaThieu'],
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
