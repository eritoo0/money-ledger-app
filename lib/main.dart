import 'package:flutter/material.dart';
import 'package:moneytrans/addUser.dart';
import 'package:moneytrans/descriptionPage.dart';
import 'package:moneytrans/homePage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          color: Color(0xFF8EACCD),
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF8EACCD),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "Adduser": (context) => Adduser(),
        "DescriptionPage": (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return Descriptionpage(
            description: args['description'] as String,
            transactionDate: args['transactionDate'] as String,
          );
        },
      },
      home: const Homepage(),
    );
  }
}
