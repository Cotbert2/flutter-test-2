import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/photo_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PhotoViewModel>(context, listen: false).loadPhotos()
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PhotoViewModel>(context);

    if (vm.loading) {
      return const Scaffold(
        body: SizedBox.shrink(),
      );
    }

    if (vm.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Picsum Photos - MVVM + Provider")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                vm.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => vm.loadPhotos(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Picsum Photos - MVVM + Provider"),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: Text(
                'Página ${vm.currentPage}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Pagination controls at the top
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: vm.canGoToPreviousPage && !vm.loading
                        ? () => vm.goToPreviousPage()
                        : null,
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    label: const Text('Anterior',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Text(
                      'Página ${vm.currentPage}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${vm.photos.length} fotos',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: !vm.loading
                        ? () => vm.goToNextPage()
                        : null,
                    label: const Text('Siguiente',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )
                    ),
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ),
              ],
            ),
          ),
          // Photo grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: vm.photos.length,
                itemBuilder: (_, index) {
                  final photo = vm.photos[index];

                  return Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              photo.downloadUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox.shrink();
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Por ${photo.author}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${photo.width} x ${photo.height}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/detalle",
                              arguments: photo,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                            ),
                            child: const Center(
                              child: Text(
                                'Ver detalles',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Bottom pagination controls
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
           
          ),
        ],
      ),
    );
  }
}
