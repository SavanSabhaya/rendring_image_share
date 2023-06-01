import 'dart:io';

import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import 'package:share_plus/share_plus.dart';

final GlobalKey globalKey = GlobalKey();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 68, 183, 58)),
        useMaterial3: true,
      ),
      home: const Main('Flutter Demo Home Page'),
    );
  }
}

class Main extends StatefulWidget {
  final String title;
  const Main(this.title, {Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
          key: globalKey,
          child: Center(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(image: DecorationImage(image: NetworkImage('https://picsum.photos/200/300'), fit: BoxFit.contain)),
                child: Center(
                  child: Text(
                    'sample Text',
                    style: TextStyle(color: Color(0xFFB0FF07)),
                  ),
                )),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          awesomeTopSnackbar(context, 'Testing snackbar');
          // shareImage();
        },
      ),
    );
  }
}

Future<Uint8List?> captureWidget() async {
  final RenderRepaintBoundary? boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

  final ui.Image image = await boundary!.toImage();

  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  final Uint8List? pngBytes = byteData?.buffer.asUint8List();

  return pngBytes;
}

Future<void> shareImage() async {
  try {
    Uint8List? imageBytes = await captureWidget();
    final tempDir = await getTemporaryDirectory();
    final files = <XFile>[];
    final file = await File('${tempDir.path}/widget.png').create();
    await file.writeAsBytes(imageBytes!);
    files.add(XFile(file.path, name: 'Sharing Widget as Image'));

    await Share.shareXFiles(files, text: 'Sharing Widget as Image');
  } catch (e) {
    print('Error sharing widget as image: $e');
  }
}
