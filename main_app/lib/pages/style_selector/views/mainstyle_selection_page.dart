import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_app/pages/style_selector/style_selector_bloc.dart';
import 'package:main_app/pages/style_selector/style_selector_event.dart';

import './asset_styles_list.dart' show NewStyleSelectionWidget;

class MainStyleSelectionView extends StatelessWidget {
  const MainStyleSelectionView({
    super.key,
    required this.useAssets,
    required this.curImagePath,
  });

  final bool useAssets;
  final String curImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change style image')),
      body: useAssets
          ? NewStyleSelectionWidget(curImagePath: curImagePath)
          : const Text('assets from files'),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: useAssets ? 0 : 1,
        items: const [
          BottomNavigationBarItem(label: 'assets', icon: Icon(Icons.image)),
          BottomNavigationBarItem(label: 'pictures', icon: Icon(Icons.image))
        ],
        onTap: (value) =>
            context.read<StyleSelectionBloc>().add(ChangeStyleTypeEvent(value)),
      ),
    );
  }
}
