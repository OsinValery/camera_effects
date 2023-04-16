import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'style_selector_bloc.dart' show StyleSelectionBloc;
import 'style_selector_event.dart';
import 'style_selector_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import './views/asset_styles_list.dart' show StyleSelectionWidget;

class StyleSelectionPage extends StatelessWidget {
  const StyleSelectionPage({super.key});

  @override
  Widget build(context) {
    var args =
        ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
    return BlocProvider(
      create: (_) => StyleSelectionBloc(args['path'], args['useAssets']),
      child: const StyleSelectionView(),
    );
  }
}

class StyleSelectionView extends StatelessWidget {
  const StyleSelectionView({super.key});

  @override
  Widget build(context) {
    return BlocConsumer<StyleSelectionBloc, StyleSelectionStateBase>(
      listenWhen: (_, state) => state.runtimeType == StyleSelectionMessageState,
      buildWhen: (_, current) => current.runtimeType == StyleSelectionState,
      builder: (context, state) {
        return MainStyleSelectionView(curImagePath: state.curPath);
      },
      listener: (context, state) {
        state as StyleSelectionMessageState;
        if (state.type == 'notifyMainBloc') {
          Navigator.maybePop(context, {
            "path": state.arguments!['path'],
            "useAssets": state.arguments!['type']
          });
        }
      },
    );
  }
}

class MainStyleSelectionView extends StatelessWidget {
  const MainStyleSelectionView({
    super.key,
    required this.curImagePath,
  });

  final String curImagePath;

  void selectAnotherPicture(context) async {
    var picker = ImagePicker();
    var img = await picker.pickImage(
        source: ImageSource.gallery, requestFullMetadata: false);
    if (img != null) {
      StyleSelectionBloc bloc = BlocProvider.of<StyleSelectionBloc>(context);
      bloc.add(ChangeStyleEvent(img.path, 1));
    }
  }

  @override
  Widget build(context) {
    var btn = IconButton(
      onPressed: () => selectAnotherPicture(context),
      icon: const Icon(Icons.image),
    );
    return Scaffold(
      appBar: AppBar(title: const Text("select style"), actions: [btn]),
      body: StyleSelectionWidget(curImagePath: curImagePath),
    );
  }
}
