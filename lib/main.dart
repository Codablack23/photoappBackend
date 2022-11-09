import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photoapp_backend/form.dart';
import 'package:photoapp_backend/firebase_options.dart';
import 'package:photoapp_backend/helpers.dart';

Future<void> main() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Helpers.debugPrint("connected");
  } catch (e) {
    Helpers.debugPrint(e);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Upload App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Admin Upload'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Center(
          child: Text(widget.title),
        ),
      ),
      backgroundColor: Colors.grey[850],
      body: Container(
        padding: const EdgeInsets.all(10),
        child: const UploadForm(),
      ),
    );
  }
}
