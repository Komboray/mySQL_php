import 'package:flutter/material.dart';
import 'package:php/2nd%20option/image.dart';
import 'package:php/upload_image.dart';

import 'home.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //by runnning either of these two homes, you get a variety of which type of data you want to send.
      //the UpIMg(), class takes you to the type of sending data that is not in byte data
      home:  const UpIMg(),
      
      //this one allows the data to be in byte data
//       home: const Innit(),
      debugShowCheckedModeBanner: false,
    );
  }
}

