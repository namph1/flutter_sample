class CongNoModel {
  final String madt;
  final String hoten;
  final String diachi;
  final int sono;

  CongNoModel({this.madt, this.hoten, this.diachi, this.sono});

  factory CongNoModel.fromJson(Map<String, dynamic> json) {
    return CongNoModel(
      madt: json["Mã KH"],
      hoten: json["Tên KH"],
      diachi: json["Địa Chỉ"],
      sono: json["Dư Nợ"],
    );
  }
}
