import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:main_app/services/styles_images_service.dart';
import '../style_selector_bloc.dart';
import '../style_selector_event.dart';

class NewStyleSelectionWidget extends StatelessWidget {
  const NewStyleSelectionWidget({super.key, required this.curImagePath});

  final String curImagePath;

  @override
  Widget build(BuildContext context) {
    var service = GetIt.instance<AssetsStylesImagesService>();
    var images = service.getImages();
    var widgetSize = MediaQuery.of(context).size.width / 1.3;
    return Column(
      children: [
        const SizedBox(height: 8),
        Expanded(
          flex: 10,
          child: Image.asset(curImagePath, width: widgetSize, fit: BoxFit.fill),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 23,
          child: GridView.builder(
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) =>
                ImageSelectionWidget(imgPath: images[index]),
          ),
        )
      ],
    );
  }
}

class ImageSelectionWidget extends StatelessWidget {
  const ImageSelectionWidget({super.key, required this.imgPath});

  final String imgPath;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<StyleSelectionBloc>().add(ChangeStyleEvent(imgPath)),
      child: Image.asset(imgPath),
    );
  }
}
