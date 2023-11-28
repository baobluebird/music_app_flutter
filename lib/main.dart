import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_ui/page/login.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myBox');

  runApp(const MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      home: LoginScreen()));
}
