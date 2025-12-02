import '../../domain/entities/pokemon.dart';

class PhotoModel extends Photo {
  PhotoModel({
    required String id,
    required String author,
    required int width,
    required int height,
    required String url,
    required String downloadUrl,
  }) : super(
    id: id,
    author: author,
    width: width,
    height: height,
    url: url,
    downloadUrl: downloadUrl,
  );

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json["id"],
      author: json["author"],
      width: json["width"],
      height: json["height"],
      url: json["url"],
      downloadUrl: json["download_url"],
    );
  }
}
