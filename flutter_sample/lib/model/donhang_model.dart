class DonHangModel {
  final String makh;
  final Map<String, String> lstHangHoa;
  final String action;
  final String key;

  DonHangModel({this.makh, this.lstHangHoa, this.action, this.key});

  Map<String, dynamic> toMap() {
    return {
      "makh": makh,
      "lstHangHoa": lstHangHoa,
      "action": action,
      "key": key,
    };
  }
}
