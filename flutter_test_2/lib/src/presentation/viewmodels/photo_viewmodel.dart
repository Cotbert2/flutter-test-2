import 'package:flutter/material.dart';

import '../../domain/entities/photo.dart';
import '../../domain/usecases/get_photos_usecase.dart';

class PhotoViewModel extends ChangeNotifier {
  final GetPhotosUseCase getPhotos;

  PhotoViewModel(this.getPhotos);

  List<Photo> photos = [];
  bool loading = false;
  String? errorMessage;

  Future<void> loadPhotos() async {
    loading = true;
    notifyListeners();

    try {
      photos = await getPhotos();
    } catch (e) {
      errorMessage = "Error al cargar las fotos";
    }

    loading = false;
    notifyListeners();
  }
}
