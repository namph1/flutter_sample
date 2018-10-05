class TonKhoModel {
  final String matp;
  final String tentp;
  final String gio;
  final int tonkho;
  final int doixuat;
  final int saudoixuat;

  TonKhoModel(
      {this.matp,
      this.tentp,
      this.gio,
      this.tonkho,
      this.doixuat,
      this.saudoixuat});

  factory TonKhoModel.fromJson(Map<String, dynamic> json) {
    return TonKhoModel(
      matp: json["Mã TP"],
      tentp: json["Tên TP"],
      gio: json["Bao Bì"],
      tonkho: json["Tồn Kho"],
      doixuat: json["Đợi Xuất"],
      saudoixuat: json["Dư Sau Đợi Xuất"],
    );
  }
}
