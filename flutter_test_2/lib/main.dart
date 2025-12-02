import 'package:flutter/material.dart';
import 'package:flutter_test_2/src/presentation/views/themes/general_theme.dart';
import 'package:provider/provider.dart';
import 'src/data/datasources/picsum_photos_datasource.dart';
import 'src/data/repositories/photo_repository_impl.dart';
import 'src/domain/usecases/get_photos_usecase.dart';
import 'src/presentation/viewmodels/photo_viewmodel.dart';
import 'src/presentation/routes/app_routes.dart';

void main() {
  final datasource = PicsumPhotosDataSource();
  final repository = PhotoRepositoryImpl(datasource);
  final usecase = GetPhotosUseCase(repository);

  runApp(MyApp(usecase: usecase));
}

class MyApp extends StatelessWidget {
  final GetPhotosUseCase usecase;

  const MyApp({super.key, required this.usecase});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PhotoViewModel(usecase),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: "/",
        theme: GeneralTheme.generalThemeLight,
      ),
    );
  }
}
