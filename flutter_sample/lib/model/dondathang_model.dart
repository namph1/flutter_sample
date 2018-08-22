class DonDatHang {
  final String so;
  final String madt;
  final String hoten;
  final String diachi;
  final int sokg;
  final int sotien;

  DonDatHang(
      {this.so, this.madt, this.hoten, this.diachi,this.sokg,this.sotien});

  factory DonDatHang.fromJson(Map<String, dynamic> json) {
    return DonDatHang(
      so: json["SO"],
      madt: json["MADT"],
      hoten: json["HOTEN"],
      diachi: json["DIACHI"],
      sokg: json["SoKg"],
      sotien: json["SOTIEN"],
    );
  }
}
