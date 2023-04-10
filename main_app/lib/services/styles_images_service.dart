class AssetsStylesImagesService {
  List<String>? _images;

  AssetsStylesImagesService() {
    _images = _findImages();
  }

  List<String> _findImages() {
    return List.generate(26, (index) => 'assets/styles/style$index.jpg');
  }

  List<String> getImages() => _images!;
}
