import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../components/roundedButton.dart';
import '../../constants.dart';
import '../workshopTechnician/schedule_data.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  _Services createState() => _Services();
}

class _Services extends State<Services> {
  List<Service> mainSer = mainServices;
  List<MultiSelectItem> servicesItems = [];
  final _multiSelectKey = GlobalKey<FormFieldState>(); ///Leave it
  //////////////////
  var selectedSubIndexes = subServices;
  /////////////////////////////
  int selectedMainServiceID = 0;
  List<Service> mainsfromDB = [
    Service(id: 0, name: "Check up", check: true),
    // Service(id: 1, name: "Oil Change", check: true),
    Service(id: 2, name: "Air Filter change", check: true),
    Service(id: 4, name: "Wipers change", check: true),
  ];
  List subsFromDB = [
    {'id': 0, 'value': true, 'subs': {'first': {true: 1}, 'second': {false: 2}}},
    // {'id': 1, 'value': false, 'subs': {'looking': {false: 3}, 'Checking': {false: 4}}},
    {'id': 2, 'value': true, 'subs': {'Oil part1': {false: 5}, 'oil face': {false: 6}, 'testing': {true: 7}, 'note really': {false: 8}, 'x face': {false: 6}, 'd face': {false: 6}, 'a face': {false: 6}, 'y face': {false: 6}, 'q face': {false: 6}}},
    // {'id': 3, 'value': false, 'subs': {'company1': {false: 9}, 'company2': {false: 10}}},
    {'id': 4, 'value': true, 'subs': {'company1': {true: 11}}},
    // {'id': 5, 'value': false, 'subs': {'tt': {false: 12}, 'ff': {false: 12}}},
  ];
  List finalSend = [];
  //////////////////////////////
  // List<bool> isMainServiceOn = [];
  // List isSubServiceOn = [];
  ////////////////////////////////
  List mainKeys = [];
  List<Map<int, String>> mainKeysIndexed = [];
  String selectedKey = '';
  ///////////////////////////////
  List controllers = [];
  List keys = [];
  //////////////////////////////////
  bool isServiceOn = false;
  bool isThereser = false;
  ////////////////////////////////
  List selectedMainServicesFromDB = [];

  @override
  void initState() {
    super.initState();
    processFromDB();
    getKeysAndControllers();
  }

  void processFromDB() {
    setState(() {
      servicesItems.clear();
      // isMainServiceOn.clear();
      // isSubServiceOn.clear();
      mainKeys.clear();
      mainKeysIndexed.clear();
      controllers.clear();
      keys.clear();
      // hala8.clear();
      selectedMainServicesFromDB.clear();
      finalSend.clear();

      for (int i=0; i < selectedSubIndexes.length; i++) {
        for (int j=0; j < subsFromDB.length; j++) {
          if (subsFromDB[j]['id']== selectedSubIndexes[i]['id']) {
            selectedSubIndexes[i]['value'] = subsFromDB[j]['value'];
            selectedSubIndexes[i]['subs'] = subsFromDB[j]['subs'];
          }
        }
      }

      List fromDB = [];
      fromDB.clear();
      for (int i=0; i < mainsfromDB.length; i++) {
        fromDB.add(mainsfromDB[i].id);
      }
      for (int i=0; i < mainSer.length; i++) {
        if (fromDB.isEmpty) {
          isThereser = false;
        }
        else {
          isThereser = true;
          if (fromDB.contains(mainSer[i].id)) {
            selectedMainServicesFromDB.add(mainSer[i]);
          }
        }

      }

      servicesItems = mainSer.map((c) => MultiSelectItem(c, c.name)).toList();
    });
  }

  void getKeysAndControllers() {
    setState(() {
      for (int i=0; i < selectedSubIndexes.length; i++) {
        var x = selectedSubIndexes[i]['subs'].values;
        late var xx = [];
        xx.clear();
        for (var t in x) {
          xx.add(t.values.toList()[0]);
        }
        int y = selectedSubIndexes[i]['subs'].keys.toList().length;
        List temp1 = [];
        List temp2 = [];
        temp1.clear();
        temp2.clear();
        for (int j=0; j < xx.length; j++) {
          TextEditingController temp = TextEditingController();
          var t = '${xx[j]}';
          temp.text = t;
          temp1.add(temp);
        }
        for (int j=0; j < y; j++) {
          String temp = selectedSubIndexes[i]['subs'].keys.toList()[j];
          temp2.add(ValueKey(temp));
        }
        controllers.add(temp1);
        keys.add(temp2);
      }
      for (int i=0; i < mainSer.length; i++) {
        mainKeys.add(mainSer[i].name);
      }
      for (int i=0; i < mainsfromDB.length; i++) {
        mainKeysIndexed.add({mainsfromDB[i].id: mainsfromDB[i].name});
        print("FROM DB: ${mainKeysIndexed}");
      }
      // print(selectedSubIndexes[2]['subs'][keys[2][1].value].keys.toList()[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MultiSelectBottomSheetField(
                key: _multiSelectKey,
                items: servicesItems,
                initialValue: selectedMainServicesFromDB,
                initialChildSize: 0.7,
                maxChildSize: 0.95,
                title: const Text("Services"),
                buttonText: const Text("Select Services"),
                searchable: true,
                // separateSelectedItems: true,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
                onConfirm: (values) {
                  setState(() {
                    if (values.isEmpty) {
                      // selectedSubIndexes.clear();
                      isServiceOn = false;
                      isThereser = false;
                    }
                     else if (values.isNotEmpty){
                      isThereser = true;

                      List temp2 = [];
                      temp2.clear();
                      for (var serv in values) {
                        serv as Service;
                        temp2.add(serv.id);
                      }


                      late var tshyek = [];
                      tshyek.clear();
                      for (int i=0; i < mainKeysIndexed.length; i++) {
                        print('THIS IS TO CHECK INSIDE: ${mainKeysIndexed[i]}');
                        var ke = mainKeysIndexed[i].keys.first;
                        tshyek.add(ke);
                      }

                      for (int i =0; i < selectedSubIndexes.length; i++) {
                        if (temp2.contains(selectedSubIndexes[i]['id'])) {
                          int index = temp2.firstWhere((element) => element == selectedSubIndexes[i]['id']);
                          selectedSubIndexes[index]['value'] = true;
                          // mainKeysIndexed[i][index] =
                          Map<int, String> saving = {selectedSubIndexes[i]['id']: mainKeys[i]};
                          if (!tshyek.contains(selectedSubIndexes[i]['id'])) {
                            mainKeysIndexed.add(saving);
                            print("THIS IS INDEXED: $mainKeysIndexed");
                          }
                        }
                        else {
                          if (tshyek.contains(selectedSubIndexes[i]['id'])) {
                            /// Handle Mains
                            selectedSubIndexes[i]['value'] = false;
                            // mainKeysIndexed.remove({selectedSubIndexes[i]['id']: mainKeys[i]});
                            mainKeysIndexed.removeWhere((element) => element.keys.first == selectedSubIndexes[i]['id']);
                            /// Handle Subs
                            var k = selectedSubIndexes[i]['subs'].keys.toList();
                            for (int j=0; j < k.length; j++) {
                              // print(controllers[i][j].text);
                              Map<bool,int> n = {false: int.parse(controllers[i][j].text)};
                              selectedSubIndexes[i]['subs'][k[j]] = n;
                              if (selectedKey == mainKeys[i]) {
                                isServiceOn = false;
                              }
                            }
                          }
                          }
                      }

                      // if (hala8.length < values.length || hala8.length == values.length) {
                      //   for (var serv in values) {
                      //     var n = serv as Service;
                      //     List vaa = [];
                      //     for (int i=0; i < values.length; i++) {
                      //       var t = values[i] as Service;
                      //       vaa.add(t.id);
                      //     }
                      //     List checking = [];
                      //     checking = hala8.keys.toList();
                      //     for (int i=0; i < checking.length; i++) {
                      //       if (!vaa.contains(checking[i])) {
                      //         hala8.remove(checking[i]);
                      //       }
                      //     }
                      //     if (!checking.contains(n.id)) {
                      //       var temp = {n.id: {n.name: {false: {'' : 0}}}};
                      //       hala8.addAll(temp);
                      //     }
                      //   }
                      //
                      //   /// Assign Keys of Value (SubService name)
                      //   selectedKeys.clear();
                      //   for (int i=0; i < values.length; i++) {
                      //     var temp = values[i] as Service;
                      //     selectedKeys.add(ValueKey(temp.name));
                      //   }
                      // }
                      // else if (hala8.length > values.length) {
                      //   List vaa = [];
                      //   for (int i=0; i < values.length; i++) {
                      //     var t = values[i] as Service;
                      //     vaa.add(t.id);
                      //   }
                      //   List checkking = [];
                      //   checkking = hala8.keys.toList();
                      //   for (int i=0; i < checkking.length; i++) {
                      //     if (!vaa.contains(checkking[i])) {
                      //       hala8.remove(checkking[i]);
                      //     }
                      //   }
                      // }
                    }
                  });
                  _multiSelectKey.currentState?.validate();

                  // for (int i=0; i < selectedSubIndexes.length; i++) {
                  //   if (selectedSubIndexes[i]['value']){
                  //     // print('Selected Items N.$i: ${selectedSubIndexes[i]}');
                  //   }
                  // }

                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (item) {
                    setState(() {
                      item as Service;
                      if (selectedMainServiceID == item.id&& isServiceOn ==true) {
                        isServiceOn = false;
                        selectedKey = '';
                      }
                      else{
                        selectedMainServiceID = item.id;
                        isServiceOn = true;

                        // for (int i=0; i < selectedSubIndexes.length; i++) {
                        //   for (int j=0; j < selectedSubIndexes[i]['subs'].keys.length; j++){
                        //     var temp = selectedSubIndexes[i]['subs'].values;
                        //     var temp2 = temp.keys.toList();
                        //     // isSubServiceOn[selectedMainServiceID][j] = temp2.first;
                        //   }
                        // }

                        selectedKey = item.name;
                      }

                    });
                    _multiSelectKey.currentState?.validate();
                  },
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                  itemCount: selectedSubIndexes[selectedMainServiceID]['subs'].keys.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Visibility (
                      key: ValueKey(selectedKey),
                      visible: isServiceOn,
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          // const Spacer(),
                          Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  CheckboxListTile(
                                    key: keys[selectedMainServiceID][index],
                                    controlAffinity: ListTileControlAffinity.leading,
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    value: selectedSubIndexes[selectedMainServiceID]["subs"][keys[selectedMainServiceID][index].value].keys.first,
                                    title: Text(
                                      selectedSubIndexes[selectedMainServiceID]["subs"].keys.toList()[index],
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        var price = selectedSubIndexes[selectedMainServiceID]['subs'][keys[selectedMainServiceID][index].value].values.toList()[0];
                                        Map<bool, int> n = {value as bool: price};
                                        selectedSubIndexes[selectedMainServiceID]["subs"][keys[selectedMainServiceID][index].value] = n;
                                        // isSubServiceOn[index] = !isSubServiceOn[index];
                                        var temp = '${selectedSubIndexes[selectedMainServiceID]['subs'][keys[selectedMainServiceID][index].value].values.first}';
                                        controllers[selectedMainServiceID][index].text = temp;
                                      });
                                    },
                                  ),
                                ],
                              )
                          ),
                          Visibility(
                            visible:  selectedSubIndexes[selectedMainServiceID]['subs'][keys[selectedMainServiceID][index].value].keys.toList()[0],
                            child: Expanded(
                              child: TextFormField(
                                controller: controllers[selectedMainServiceID][index],
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]+"))],
                                maxLength: 5,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Enter Price (SAR)',
                                ),
                                onChanged: (price) {
                                  setState(() {
                                    // var temp = value as Service;
                                    // print(price);
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: isThereser,
            child: RoundedButton(
              title: 'Submit',
              colour: kDarkColor,
              onPressed: () {
                setState(() {
                  print('HEHE');
                  checkAll();
                });
              },
            ),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void checkAll() {
    finalSend.clear();
    handlePrices();
    for (int i=0; i < selectedSubIndexes.length; i++) {
      if (selectedSubIndexes[i]['value']) {
        finalSend.add(selectedSubIndexes[i]);
        print(selectedSubIndexes[i]);
      }
    }
    for (int i=0; i < mainKeysIndexed.length; i++) {
      print(mainKeysIndexed[i]);
    }
    // print(finalSend);
  }

  void handlePrices() {
    setState(() {
      for (int i=0; i < selectedSubIndexes.length; i++) {
        if (selectedSubIndexes[i]['value']) {
          for (int j=0; j < selectedSubIndexes[i]['subs'].length; j++) {
            var tempsubKeys = selectedSubIndexes[i]['subs'][keys[i][j].value].keys.toList();
            Map<bool, int> n = {tempsubKeys[0]: int.parse(controllers[i][j].text)};
            selectedSubIndexes[i]['subs'][keys[i][j].value] = n;
            // print(selectedSubIndexes);
          }
        }
      }
    });
  }

// void _displayTextInputDialog(BuildContext context, String service) async {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Select Price'),
//           content: TextField(
//             onChanged: (value) {
//               setState(() {
//                 _priceController.text= value;
//                 // _priceController.text = '';
//               });
//             },
//             controller: _priceController,
//             decoration: const InputDecoration(hintText: "Enter Price"),
//           ),
//           actions: <Widget>[
//             RoundedButton(
//               title: 'Submit',
//               colour: Colors.pink,
//               onPressed: () {
//                 setState(() {
//                   tempSelectedServices2 = [];
//                   selectedServices[service] = _priceController.text;
//                   // print(selectedServices);
//
//                   for (var all in tempSelectedServices) {
//                     var temp2 = all.name.split('-');
//                     // print(temp2[0]);
//                     var ser = temp2[0].trim();
//                     var pri = temp2[1].trim();
//                     if (ser == service) {
//                       Service tempSer = Service(
//                         id: all.id,
//                         name: '$ser - ${_priceController.text}',);
//                       tempSelectedServices2.add(tempSer);
//                       // print(tempSer.name);
//                     }
//                     else {
//                       Service tempSer = Service(
//                           id: all.id,
//                           name: '$ser - $pri');
//                       tempSelectedServices2.add(tempSer);
//                       // print(tempSer.name);
//                     }
//                   }
//                   tempSelectedServices = tempSelectedServices2;
//                   tempSelectedServicesItems = tempSelectedServices.map((c) => MultiSelectItem(c, c.name)).toList();
//                   // print('${tempSelectedServices[0].name}as');
//
//
//                   _priceController.text = '';
//                   Navigator.pop(context);
//                 });
//               },
//             ),
//
//           ],
//         );
//       });
// }

}
