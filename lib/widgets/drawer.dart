import 'package:flutter/material.dart';
import 'package:invoicer/screens/companies_screen.dart';

import '../screens/invoices_screen.dart';
import '../screens/payment_details_screen.dart';
import '../screens/personal_details_screen.dart';
import '../screens/statistics_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 5, top: 15),
              child: Text(
                'Invoicer',
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const InvoicesScreen()),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Personal Details'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const PersonalDetailsScreen()),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.wallet),
            title: const Text('Payment Details'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const PaymentDetailsScreen()),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('Companies'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => CompaniesScreen(
                            showDrawer: true,
                          )),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Statistics'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const StatisticsScreen()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
