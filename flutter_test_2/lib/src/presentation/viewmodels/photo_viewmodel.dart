import 'package:flutter/material.dart';

import '../../domain/entities/photo.dart';
import '../../domain/usecases/get_photos_usecase.dart';

class PhotoViewModel extends ChangeNotifier {
  final GetPhotosUseCase getPhotos;

  PhotoViewModel(this.getPhotos);

  List<Photo> photos = [];
  bool loading = false;
  String? errorMessage;
  int currentPage = 1;
  static const int photosPerPage = 30;

  Future<void> loadPhotos() async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      photos = await getPhotos(page: currentPage);
      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar las fotos";
    }

    loading = false;
    notifyListeners();
  }

  Future<void> goToPreviousPage() async {
    if (currentPage > 1) {
      currentPage--;
      await loadPhotos();
    }
  }

  Future<void> goToNextPage() async {
    currentPage++;
    await loadPhotos();
  }

  void goToPage(int page) {
    if (page > 0 && page != currentPage) {
      currentPage = page;
      loadPhotos();
    }
  }

  bool get canGoToPreviousPage => currentPage > 1;
}
