import 'package:main_app/pages/main_page/main_action_bloc.dart';
import 'package:main_app/pages/main_page/main_action_event.dart';

import 'style_selector_bloc.dart' show StyleSelectionBloc;
import './views/mainstyle_selection_page.dart' show MainStyleSelectionView;
import 'style_selector_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StyleSelectionPage extends StatelessWidget {
  const StyleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
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
  Widget build(BuildContext context) {
    return BlocConsumer<StyleSelectionBloc, StyleSelectionStateBase>(
      listenWhen: (_, state) => state.runtimeType == StyleSelectionMessageState,
      buildWhen: (_, current) => current.runtimeType == StyleSelectionState,
      builder: (context, state) {
        return MainStyleSelectionView(
          useAssets: state.assetesOpened,
          curImagePath: state.curPath,
        );
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
