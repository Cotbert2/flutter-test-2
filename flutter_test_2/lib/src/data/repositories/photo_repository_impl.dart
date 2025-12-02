import '../../domain/entities/photo.dart';
import '../datasources/picsum_photos_datasource.dart';

class PhotoRepositoryImpl {
  final PicsumPhotosDataSource datasource;

  PhotoRepositoryImpl(this.datasource);

  Future<List<Photo>> getPhotos({int limit = 30, int page = 1}) async {
    return datasource.fetchPhotos(limit, page);
  }
}
