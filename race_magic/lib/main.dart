import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:race_magic/widget/race_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<FirebaseApp> _initializeFirebase() => Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error initializing Firebase');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return RaceListPage();
            }
            return const CircularProgressIndicator();
          },
        ));
  }
}
