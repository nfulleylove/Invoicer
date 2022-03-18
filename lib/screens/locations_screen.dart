import 'package:flutter/material.dart';
import 'package:invoicer/data/locations_sql_helper.dart';
import 'package:invoicer/widgets/drawer.dart';

import '../models/location_model.dart';

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  LocationsSqlHelper sqlHelper = LocationsSqlHelper();
  List<LocationModel> locations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Locations')),
        drawer: const AppDrawer(),
        floatingActionButton: FloatingActionButton(
            onPressed: addLocation, child: const Icon(Icons.add)),
        body: FutureBuilder(
            future: getLocations(),
            builder: (context, snapshot) {
              locations =
                  snapshot.hasData ? snapshot.data as List<LocationModel> : [];

              if (locations.isNotEmpty) {
                return ListView.separated(
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    var location = locations[index];
                    return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => deleteLocation(location),
                        confirmDismiss: confirmDeletion,
                        child: ListTile(title: Text(location.name)),
                        background: Container(
                          color: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: AlignmentDirectional.centerEnd,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              } else {
                return const Center(
                    child: Text("No locations have been added"));
              }
            }));
  }

  Future deleteLocation(LocationModel location) async {
    setState(() {
      sqlHelper.deleteLocation(location);
    });
  }

  Future addLocation() async {
    TextEditingController locationController = TextEditingController();

    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Location'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                    controller: locationController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(labelText: 'Location'))
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  sqlHelper.insertLocation(
                      LocationModel(0, locationController.text));
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<LocationModel>> getLocations() async {
    sqlHelper = LocationsSqlHelper();

    var _locations = await sqlHelper.getLocations();
    _locations.sort((a, b) => a.name.compareTo(b.name));

    return _locations;
  }

  Future<bool?> confirmDeletion(DismissDirection direction) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Location'),
          content: const Text('Are you sure you want to delete the location?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
