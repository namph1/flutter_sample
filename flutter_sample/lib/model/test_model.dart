class PhotoList {
  final List<Photo> photos;

  PhotoList({
    this.photos,
  });
  factory PhotoList.fromJson(List<dynamic> parsedJson) {
    List<Photo> photos = new List<Photo>();
    photos = parsedJson.map((i) => Photo.fromJson(i)).toList();

    return new PhotoList(photos: photos);
  }
}

class Photo {
  final String Tong;
  final String Ngay;

  Photo({this.Tong, this.Ngay});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return new Photo(
      Tong: json['Tong'].toString(),
      Ngay: json['Ngay'],
    );
  }
}
