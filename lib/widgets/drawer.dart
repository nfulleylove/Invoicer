import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
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
            leading: const Icon(Icons.create),
            title: const Text('Create an Invoice'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Personal Details'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/personal_details');
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('Companies'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/companies');
            },
          ),
          ListTile(
            leading: const Icon(Icons.room),
            title: const Text('Locations'),
            onTap: () {
              Navigator.pop(context);

              Navigator.pushReplacementNamed(context, '/locations');
            },
          ),
        ],
      ),
    );
  }
}
