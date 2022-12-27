
import 'package:flutter/material.dart';

class Services extends StatefulWidget {
   const Services({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Services();
  }

}

class _Services extends State<Services> {

  // static const dark = Color(0xFF333A47);
  // static const double leftPadding = 9;

  var bbcolor= [Colors.transparent,Colors.transparent,Colors.transparent,Colors.transparent];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:const Text("Capacity"),
        centerTitle: true,
        backgroundColor:Colors.transparent,
        foregroundColor:Colors.black,
        elevation: 0,
        iconTheme:IconThemeData(
            color: Colors.lightBlue[300],size: 24
        ),
      ),

      body: UpdateSch()
    );
  }
}

class UpdateSch extends StatefulWidget {
   const UpdateSch({Key? key}) : super(key: key);

  @override
  State<UpdateSch> createState() => UpdateScheduleSec();

}

class UpdateScheduleSec extends State<UpdateSch> {

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  List titles = ["Service 1",
    "Service 2",
    "Service 3",
    "Service 4",
    "Service 5",
  ];
  List subtitles = [
    "Check Up - Free",
    "Oil Change - 150SAR",
    "etc1",
    "etc2",
    "etc3",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: titles.length, itemBuilder: (context, index) {
      return Card(
          child: ListTile(
          title: Text(titles[index]),
            subtitle: Text(subtitles[index]),
            leading: const Icon(Icons.accessibility),
            onTap: () {},
          )
      );
    }
    );
  }
}

//   Future<String?> openDialog() => showDialog<String>(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text("Service Name, and Price"),
//       content: TextField(
//           autofocus: true,
//           decoration: const InputDecoration(hintText: 'Enter SERVICE NAME - PRICE'),
//           controller: controller
//       ),
//       actions: [
//         TextButton(
//           child: const Text('SUBMIT'),
//           onPressed: () {
//             Navigator.of(context).pop(controller.text);
//           },
//         ),
//         TextButton(
//           child: const Text("CANCEL"),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         )
//       ],
//     ),
//   );
// }