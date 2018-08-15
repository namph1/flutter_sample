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
  final String tong;
  final String ngay;

  Photo({this.tong, this.ngay});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return new Photo(
      tong: json['Tong'].toString(),
      ngay: json['Ngay'],
    );
  }
}
