import 'package:flutter/material.dart';
import 'package:invoicer/screens/companies_screen.dart';
import 'package:invoicer/screens/locations_screen.dart';
import 'package:invoicer/screens/personal_details_screen.dart';
import 'screens/create_invoice_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoicer',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CreateInvoice(),
        '/locations': (context) => const Locations(),
        '/personal_details': (context) => const PersonalDetails(),
        '/companies': (context) => const CompaniesScreen()
      },
    );
  }
}
