import 'package:flutter/material.dart';

import '../../Services/Auth/workshopAdmin_database.dart';
import '../../components/buildCards.dart';
import 'add_workshop.dart';

class ManageWorkshops extends StatefulWidget {
  const ManageWorkshops({Key? key}) : super(key: key);

  @override
  State<ManageWorkshops> createState() => _ManageWorkshopsState();
}

class _ManageWorkshopsState extends State<ManageWorkshops> {
  Map workshops = {};
  bool gotPath = false;
  List<Widget> workshopsList = [];

  @override
  initState() {
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    var workshopsDB = await getUserWorkshopsFromDB();

    setState(() {
      workshops = workshopsDB;
      workshopsList = buildWorkshopsCards(workshops);
      gotPath = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!gotPath) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(MaterialPageRoute(
                    builder: (BuildContext context) => const AddWorkshop()));
              },
              child: const Text('Add New Workshop')),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView(
              children: workshopsList,
            ),
          )
        ],
      );
    }
  }
}
