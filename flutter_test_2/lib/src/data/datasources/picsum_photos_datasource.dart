import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/photo_model.dart';

class PicsumPhotosDataSource {
  final String baseUrl = "https://picsum.photos/v2/list";
  final String idBaseUrl = "https://picsum.photos/id";

  Future<List<PhotoModel>> fetchPhotos(int limit, int page) async {
    final url = Uri.parse("$baseUrl?page=$page&limit=$limit");

    final resp = await http.get(url);

    if (resp.statusCode != 200) {
      throw Exception("Error al obtener las fotos");
    }

    final List<dynamic> data = jsonDecode(resp.body);

    return data.map((e) => PhotoModel.fromJson(e)).toList();
  }

  Future<PhotoModel> fetchPhotoById(int id) async {
    final url = Uri.parse("https://picsum.photos/id/$id/info");

    final resp = await http.get(url);

    if (resp.statusCode == 404) {
      throw Exception("No se encontró una imagen con el ID $id");
    }

    if (resp.statusCode != 200) {
      throw Exception("Error al obtener la imagen con ID $id");
    }

    final Map<String, dynamic> data = jsonDecode(resp.body);

    return PhotoModel.fromJson(data);
  }
}
