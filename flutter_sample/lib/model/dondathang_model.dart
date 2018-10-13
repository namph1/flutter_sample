class DonDatHang {
  final String so;
  final String madt;
  final String hoten;
  final String diachi;
  final int sokg;
  final int sotien;
  final String idkey;
  final String trangthai;
  final String nguoinhan;

  DonDatHang(
      {this.so,
      this.madt,
      this.hoten,
      this.diachi,
      this.sokg,
      this.sotien,
      this.idkey,
      this.trangthai,
      this.nguoinhan});

  factory DonDatHang.fromJson(Map<String, dynamic> json) {
    return DonDatHang(
      so: json["SO"],
      madt: json["MADT"],
      hoten: json["HOTEN"],
      diachi: json["DIACHI"],
      sokg: json["SoKg"],
      sotien: json["SOTIEN"],
      idkey: json["IDKEY"],
      trangthai: json["TrangThai"],
      nguoinhan: json["NguoiNhan"],
    );
  }
}

class DonHangDetailModel {
  final String idkey;
  final String matp;
  final String tentp;
  final int soluong;
  final String baobi;
  final int tonkho;
  final int dusaudh;

  DonHangDetailModel(
      {this.idkey,
      this.matp,
      this.tentp,
      this.soluong,
      this.baobi,
      this.tonkho,
      this.dusaudh});

  factory DonHangDetailModel.fromJson(Map<String, dynamic> json) {
    return DonHangDetailModel(
      matp: json["Mã TP"],
      tentp: json["Tên TP"],
      soluong: json["SL ĐĐH"],
      baobi: json["Bao Bì"],
      tonkho: json["Tồn Kho"],
      dusaudh: json["Dư Sau ĐH"],
    );
  }
}

class DonHangModel {
  final String matp;
  final String tentp;
  final int soluong;
  final String baobi;

  DonHangModel({
    this.matp,
    this.tentp,
    this.soluong,
    this.baobi,
  });

  factory DonHangModel.fromJson(Map<String, dynamic> json) {
    return DonHangModel(
      matp: json["MATP"],
      tentp: json["TENTP"],
      baobi: json["TenFull"].toString().split("(")[1].replaceAll(")", ""),
    );
  }
}
