import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:music_player_app/src/pages/musicPlayer.dart';
import 'package:music_player_app/src/utils/BaDumTss.dart';
import 'package:music_player_app/src/utils/localdata.dart';
import 'package:path_provider/path_provider.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUp();
  Directory directory = await getApplicationDocumentsDirectory();
  await getIt<LocalData>().init(directory.path);
  runApp(MyApp());
}

final getIt = GetIt.instance;

void setUp() {
  getIt.registerSingleton<LocalData>(LocalData());
  getIt.registerFactory(() => BaDumTss());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink
      ),
      home: MusicPlayerScreen()
    );
  }
}