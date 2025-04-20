import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_viewer/controller/constants/constants.dart';
import 'package:pdf_viewer/view/screens/pdf_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Setting up orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      home: const PDFViewerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
