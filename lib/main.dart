import 'package:flutter/material.dart';
import 'home_screen.dart';

void main(){
  runApp(DictionaryApp());
}

class DictionaryApp extends StatelessWidget{
  const DictionaryApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dictionary App",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomeScreen(),
    );
  }
}