class DonHangModelOri {
  final String makh;
  final Map<String, int> lstHangHoa;
  final String action;
  final String key;
  final String idkey;

  DonHangModelOri({this.makh, this.lstHangHoa, this.action, this.key, this.idkey});

  Map<String, dynamic> toMap() {
    return {
      "makh": makh,
      "lstHangHoa": lstHangHoa,
      "action": action,
      "key": key,
      "idkey": idkey,
    };
  }
}
