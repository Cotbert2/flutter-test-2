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
  bool isSearchMode = false;
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

  Future<void> searchPhotoById(int id) async {
    loading = true;
    errorMessage = null;
    isSearchMode = true;
    notifyListeners();

    try {
      final photo = await getPhotos.getPhotoById(id);
      photos = [photo];
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      photos = [];
    }

    loading = false;
    notifyListeners();
  }

  void clearSearch() {
    isSearchMode = false;
    currentPage = 1;
    loadPhotos();
  }

  Future<void> goToPreviousPage() async {
    if (currentPage > 1 && !isSearchMode) {
      currentPage--;
      await loadPhotos();
    }
  }

  Future<void> goToNextPage() async {
    if (!isSearchMode) {
      currentPage++;
      await loadPhotos();
    }
  }

  void goToPage(int page) {
    if (page > 0 && page != currentPage && !isSearchMode) {
      currentPage = page;
      loadPhotos();
    }
  }

  bool get canGoToPreviousPage => currentPage > 1 && !isSearchMode;
}
