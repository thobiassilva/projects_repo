import 'package:flutter/material.dart';
import 'package:projects_repo/controller.dart';

class FoldersPage extends StatefulWidget {
  const FoldersPage({super.key});

  @override
  State<FoldersPage> createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  final Controller _controller = Controller();

  @override
  void initState() {
    super.initState();
    _controller.loadPathsFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Projects Repository'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _controller.foldersState,
        builder: (context, directories, child) {
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: directories.length,
            itemBuilder: (context, index) {
              final directory = directories[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      const Expanded(
                        child: Icon(
                          Icons.folder,
                          size: 64,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          directory.path.split('\\').last,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.addPath,
        tooltip: 'Adicionar caminho',
        child: const Icon(Icons.add),
      ),
    );
  }
}
