import 'package:flutter/material.dart';
import 'package:invoicer/screens/invoices_screen.dart';
import 'package:invoicer/services/notification_service.dart';

Future<void> main() async {
  await NotificationService().setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoicer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: '/',
      routes: {'/': (context) => const Invoices()},
    );
  }
}
