// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_test_2/main.dart';
import 'package:flutter_test_2/src/data/datasources/picsum_photos_datasource.dart';
import 'package:flutter_test_2/src/data/repositories/photo_repository_impl.dart';
import 'package:flutter_test_2/src/domain/usecases/get_photos_usecase.dart';

void main() {
  testWidgets('Photo app smoke test', (WidgetTester tester) async {
    // Create dependencies
    final datasource = PicsumPhotosDataSource();
    final repository = PhotoRepositoryImpl(datasource);
    final usecase = GetPhotosUseCase(repository);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(usecase: usecase));

    // Verify that our app loads with the correct title
    expect(find.text('Picsum Photos - MVVM + Provider'), findsOneWidget);

    // Wait for the loading to complete (if photos are loaded)
    await tester.pumpAndSettle();

    // The app should now show either photos or a loading indicator
    final hasLoading = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
    final hasGrid = find.byType(GridView).evaluate().isNotEmpty;
    expect(hasLoading || hasGrid, isTrue);
  });
}
