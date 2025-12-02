import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/photo_model.dart';

class PicsumPhotosDataSource {
  final String baseUrl = "https://picsum.photos/v2/list";

  Future<List<PhotoModel>> fetchPhotos(int limit, int page) async {
    final url = Uri.parse("$baseUrl?page=$page&limit=$limit");

    final resp = await http.get(url);

    if (resp.statusCode != 200) {
      throw Exception("Error al obtener las fotos");
    }

    final List<dynamic> data = jsonDecode(resp.body);

    return data.map((e) => PhotoModel.fromJson(e)).toList();
  }
}
