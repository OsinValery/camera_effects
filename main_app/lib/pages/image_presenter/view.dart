import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './image_presenter_bloc.dart';
import './image_presenter_state.dart';
import './image_presenter_event.dart';

class ImagePresenterView extends StatelessWidget {
  const ImagePresenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImagePresenterBloc(),
      child: const ImagePresenterWidget(),
    );
  }
}

class ImagePresenterWidget extends StatelessWidget {
  const ImagePresenterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImagePresenterBloc, ImagePresenterState>(
      builder: (context, state) {
        return state.presentDark
            ? const DarkImageView()
            : const LightImageView();
      },
      listener: (context, state) {},
      listenWhen: (previous, current) => current.shouldListen,
      buildWhen: (previous, current) => !current.shouldListen,
    );
  }
}

class DarkImageView extends StatelessWidget {
  const DarkImageView({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () =>
          context.read<ImagePresenterBloc>().add(InvertBackgroundEvent()),
      child: Center(
        child: Container(
          color: Colors.white,
          width: size.width,
          height: size.width,
        ),
      ),
    );
  }
}

class LightImageView extends StatelessWidget {
  const LightImageView({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('last image')),
      body: GestureDetector(
        onTap: () =>
            context.read<ImagePresenterBloc>().add(InvertBackgroundEvent()),
        child: Center(
          child: Container(
            color: Colors.white,
            width: size.width,
            height: size.width,
          ),
        ),
      ),
    );
  }
}
