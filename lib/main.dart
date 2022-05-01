import 'package:flutter/material.dart';
import 'musicPlayerScreen.dart';
import 'package:hive/hive.dart';
import 'package:get_it/get_it.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //for binding all the widgets
  setUp();
  //this will create a single instance throughout the app
  Directory dir = await getApplicationDocumentsDirectory();
  //getting the directory where the app stores its data
  Hive.init(dir.path);
  await Hive.openBox<String>('myBox');
  Box box = Hive.box<String>('myBox');
  if(box.get('playedOnce') == null){
    box.put('playedOnce', 'false');
  }
  runApp(const MyApp());
}

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;
class BaTum{
  final AudioPlayer _audio = AudioPlayer();
  AudioPlayer get audio => _audio;
}
void setUp(){
  getIt.registerFactory(() =>  BaTum());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MusicPlayerScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreamMe Music Player'),
        centerTitle: true,
      ),
      body: const Center(
      ),
    );
  }
}
