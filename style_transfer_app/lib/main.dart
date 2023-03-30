// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:tflite_style_transfer/tflite_style_transfer.dart';
import 'default_bloc.dart' show DefaultBloc;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Style Transfer',
      theme: ThemeData(useMaterial3: false),
      home: const TestIdeaWidget(),
    );
  }
}

class TestIdeaBloc extends DefaultBloc {
  TestIdeaBloc(BuildContext context) : super(context);

  String? selectedImagePath;
  String? styleImagePath;
  String? totalImagePath;
  final styleTransfer = TFLiteStyleTransfer();

  Map<String, dynamic> get curState {
    return {
      'style': styleImagePath,
      'src': selectedImagePath,
      'total': totalImagePath,
    };
  }

  @override
  void workEvent(Map<String, dynamic> data) async {
    String type = data['type'];
    switch (type) {
      case 'resetStyle':
        styleImagePath = null;
        break;
      case 'init':
        break;
      case 'selectStyle':
        styleImagePath = data['file'];
        break;
      case 'loadImage':
        var res = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.image,
        );
        if (res != null) {
          selectedImagePath = res.files[0].path;
        }
        break;
      case 'work':
        if (styleImagePath == null || selectedImagePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('select style and image')));
        } else {
          var result = await styleTransfer.runStyleTransfer(
            styleImagePath: styleImagePath!,
            imagePath: selectedImagePath!,
            styleFromAssets: true,
          );
          totalImagePath = result;
        }
        break;
      default:
        debugPrint('unknown data: $data');
        break;
    }
    notificationSink.add(curState);
  }
}

class TestIdeaWidget extends StatefulWidget {
  const TestIdeaWidget({super.key});

  @override
  State<TestIdeaWidget> createState() => _TestIdeaWidgetState();
}

class _TestIdeaWidgetState extends State<TestIdeaWidget> {
  late TestIdeaBloc bloc;

  @override
  void initState() {
    bloc = TestIdeaBloc(context);
    super.initState();
  }

  static final styleImages =
      List.generate(26, (index) => 'assets/styles/style$index.jpg');

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cancelIcon = const Icon(Icons.do_not_disturb_alt_outlined, size: 48);
    var selected = const Positioned(
      right: 0,
      child: Icon(Icons.check_circle, size: 32, color: Colors.green),
    );
    return StreamBuilder(
        initialData: bloc.curState,
        stream: bloc.notificationStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var data = snapshot.data as Map<String, dynamic>?;
          if (data == null) {
            bloc.eventsSink.add({'type': 'init'});
            return Container();
          }
          return Scaffold(
            appBar: AppBar(title: const Text('styleTransferApp')),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (data['src'] != null)
                        Image.file(File(data['src']), width: 200, height: 200)
                      else
                        Container(color: Colors.blue, width: 200, height: 200),
                      if (data['total'] != null)
                        Image.file(File(data['total']), width: 200, height: 200)
                      else
                        Container(color: Colors.green, width: 200, height: 200),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => bloc.eventsSink.add({'type': 'loadImage'}),
                    child: const Text('select image'),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: IconButton(
                                onPressed: () =>
                                    bloc.eventsSink.add({'type': 'resetStyle'}),
                                icon: cancelIcon,
                              ),
                            )
                          ] +
                          List.generate(styleImages.length, (index) {
                            var style = styleImages[index];
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  child: InkWell(
                                    onTap: () => bloc.eventsSink.add(
                                        {'type': 'selectStyle', 'file': style}),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        child: Image.asset(
                                          style,
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (data['style'] == style) selected,
                              ],
                            );
                          }),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => bloc.eventsSink.add({'type': "work"}),
                    child: const Text('Start'),
                  )
                ],
              ),
            ),
          );
        });
  }
}
