import '../entities/photo.dart';
import '../../data/repositories/photo_repository_impl.dart';

class GetPhotosUseCase {
  final PhotoRepositoryImpl repository;

  GetPhotosUseCase(this.repository);

  Future<List<Photo>> call() {
    return repository.getPhotos(limit: 30, page: 1);
  }
}
