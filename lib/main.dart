import 'package:desafiolistacontatos/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  //configurando o Hive
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}
