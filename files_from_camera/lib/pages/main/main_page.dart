import 'package:files_from_camera/pages/main/main_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io' show File;
import 'dart:math' show pi;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainPageBloc bloc;

  @override
  void initState() {
    bloc = MainPageBloc(context);
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main')),
      body: SafeArea(
        child: StreamBuilder(
            stream: bloc.notificationStream,
            builder: (context, data_) {
              if (data_.data == null) {
                bloc.eventsSink.add({'type': 'init'});
                return Container();
              }

              var data = data_.data as Map<String, dynamic>;
              Widget result = data['start'] && data['result'] != null
                  ? Transform.rotate(
                      angle: 0,
                      child:
                          data['preloaded'] ?? Image.file(File(data['result'])),
                    )
                  : data['current'] == null
                      ? Container(color: Colors.blue)
                      : Image.file(File(data['current']));

              Widget btn = data['start']
                  ? ElevatedButton(
                      onPressed: () => bloc.eventsSink.add({'type': 'stop'}),
                      child: const Text('stop'),
                    )
                  : ElevatedButton(
                      onPressed: () => bloc.eventsSink.add({'type': 'start'}),
                      child: const Text('start'),
                    );

              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CameraPreview(data['controller']),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  bloc.eventsSink.add({'type': 'inc'}),
                              child: const Text('+'),
                            ),
                            Text(data['style'].toString()),
                            ElevatedButton(
                              onPressed: () =>
                                  bloc.eventsSink.add({'type': 'dec'}),
                              child: const Text('-'),
                            ),
                          ],
                        )
                      ],
                    )),
                    Expanded(child: result),
                    btn,
                  ],
                ),
              );
            }),
      ),
    );
  }
}
