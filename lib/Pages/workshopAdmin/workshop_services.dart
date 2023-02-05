import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:wrshh/Pages/workshopAdmin/services_data.dart';
import 'package:wrshh/Services/Auth/workshop_admin_database.dart';
import '../../components/rounded_button.dart';
import '../../constants.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  StateServices createState() => StateServices();
}

class StateServices extends State<Services> {
  final _multiSelectKey = GlobalKey<FormFieldState>(); ///Global Key for Multi_Select Widget
  List<MultiSelectItem> servicesItems = []; /// List to display in Multi_Select Widget
  List<Service> mainSer = []; /// Main Services Static List
  List selectedSubIndexes = []; /// Sub Services Static List

  int selectedMainServiceID = 0; /// To assign corresponding list number to its data
  List<Service> mainsFromDB = []; /// List to Hold DB Main Services
  List subsFromDB = []; /// List to Hold DB Sub Services

  List<Service> mainKeysIndexed = []; /// List to carry Selected Main Services data (of Type Service)
  String selectedKey = ''; /// To check the selected Sub-Service name

  List mainsControllers =[]; /// List of Controllers for Main Services
  List controllers = []; /// List of Controllers for Sub Services

  List mainKeys = []; /// List to Carry Main Services ValueKey()
  List keys = []; /// List to Carry Sub Services ValueKey()

  bool isServiceOn = false; /// Bool to check if a Main Service(s) is selected

  List selectedMainServicesFromDB = []; /// List to get the Selected Main Services to be checked in Multi_select
  bool finalCheck = false; /// Bool to check if there is any modification to show Submit Button

  late LinkedHashMap<String,dynamic> services; /// to Store Retrieved Services from DB
  bool gotPath = false; /// To Handle DB Call Wait

  @override
  void initState() {
    super.initState();
    preProcessFromDB(); /// Call from DB Method
  }

  /// Call Services Map from DB
  Future<void> preProcessFromDB() async {
    services = await getServices();
    setState(() {
      mainSer = mainServices;
      selectedSubIndexes = subServices;

      /// Get Main Services
      for (int j=0; j < mainSer.length; j++) {
        List ser = services['service'].toList(); /// List of Services Names
        for (int i=0; i < ser.length; i++) {
          if (ser[i] == mainSer[j].name) { /// If the Corresponding 'name' exists in DB variable, add it to mainsFromDB
            Service temp = Service(id: mainSer[j].id, name: services['service'][i], check: true, price: services['price'][i]);
            mainsFromDB.add(temp);
          }
        }
      }

      /// Get Sub Services (Products)
      for (int i=0; i < subServices.length; i++) {
        var check = 0;
        var tempList = [];
        var subsValues = {};
        tempList.clear();
        for (int k=0; k < services['SubServices'].length; k++) {
          if (services['service'][k] == mainSer[i].name) {
            var gg = services['SubServices'][services['service'][k]].toList();
            for (int b=0; b < gg.length; b++) {
              tempList.add(gg[b]);
            }
          }
        }

        late Map subTemp;
        var subsTemp = subServices[i]['subs'].keys.toList();
        int priceChecker = 0;
        for (int j=0; j < subsTemp.length; j++) {
          if (tempList.contains(subsTemp[j])) {
            subsValues[subsTemp[j]] = {true: services['SubPrices'][mainSer[i].name][priceChecker++]};
            check = 1;
          }
          else if (!tempList.contains(subsTemp[j])){
            subsValues[subsTemp[j]] = {false : 0};
          }
        }
        if (check == 1) {
          subTemp = {
            'id': subServices[i]['id'],
            'value': true,
            'subs': subsValues
          };
          subsFromDB.add(subTemp);
        }
      }

      processFromDB(); /// Handle mainsFromDB and subsFromDB forms of data
      gotPath = true; /// The 'path' is retrieved from DB
    });
  }

  /// Create the Multi_Select List selected Items
  void processFromDB() {
    setState(() {
      /// Update the Sub Services Map to the subsFromDB Data
      for (int i=0; i < selectedSubIndexes.length; i++) {
        for (int j=0; j < subsFromDB.length; j++) {
          if (subsFromDB[j]['id']== selectedSubIndexes[i]['id']) {
            selectedSubIndexes[i]['value'] = subsFromDB[j]['value'];
            selectedSubIndexes[i]['subs'] = subsFromDB[j]['subs'];
          }
        }
      }
      List fromDB = []; /// Holds mainsFromDB Id's
      for (int i=0; i < mainsFromDB.length; i++) {
        fromDB.add(mainsFromDB[i].id);
      }
      for (int i=0; i < mainSer.length; i++) {
        if (fromDB.contains(mainSer[i].id)) { /// If the Static Main Service id exists in mainsFromDB, add to to the list
          selectedMainServicesFromDB.add(mainSer[i]); /// 'Checked' services in Multi_Select
        }
      }
      /// Populate Multi_select List
      servicesItems = mainSer.map((c) => MultiSelectItem(c, c.name)).toList();
      getKeysAndControllers();

    });
  }

  /// Assign All Keys and Controllers for Main and Sub Services
  void getKeysAndControllers() {
    setState(() {
      /// Assign Controllers and ValueKeys() for subServices
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

      /// Add Controllers and ValueKeys() for MainSer, with Updated DB Prices from mainsFromDB
      for (int i=0; i < selectedSubIndexes.length; i++) {
        if (selectedSubIndexes[i]['value']) {
          TextEditingController temp = TextEditingController();
          for (int j=0; j < mainsFromDB.length; j++) {
            if (selectedSubIndexes[i]['id'] == mainsFromDB[j].id) {
              temp.text = '${mainsFromDB[j].price}';
              mainsControllers.add(temp);
            }
          }
        }
        else {
          TextEditingController temp = TextEditingController();
          temp.text = '${0}';
          mainsControllers.add(temp);
        }
        mainKeys.add(mainSer[i].name);
      }

      /// Add  Selected Main Services to selectedMainServices Variable
      for (int i=0; i < mainsFromDB.length; i++) {
        Service temp = Service(
            id: mainsFromDB[i].id,
            name: mainsFromDB[i].name,
            check: mainsFromDB[i].check,
            price: mainsFromDB[i].price);
        mainKeysIndexed.add(temp);
        // print("FROM DB: ${temp.id} - ${temp.price}");
      }

      List tempMainKeys = [];
      for (int i=0; i < mainKeysIndexed.length; i++) {
        tempMainKeys.add(mainKeysIndexed[i].id);
      }
      /// Assign Updated Sub Services Prices to their Controllers
      for (int i=0; i < selectedSubIndexes.length; i++) {
        var temp = selectedSubIndexes[i]['subs'].keys.toList();
        for (int j=0; j < temp.length; j++) {
          if (tempMainKeys.contains(selectedSubIndexes[i]['id'])) {
            if (selectedSubIndexes[i]['id'] == mainKeysIndexed.firstWhere((element) => element.id == selectedSubIndexes[i]['id'])) {
              controllers[i][j].text = services['SubPrices'][mainSer[i].name][i].toString();
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!gotPath) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Main Services Selection
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
                        isServiceOn = false;
                        finalCheck = false;
                      }
                      else if (values.isNotEmpty){
                        /// Get onConfirm property (values) "Service" ID's
                        List valuesIDs = [];
                        for (var serv in values) {
                          serv as Service;
                          valuesIDs.add(serv.id);
                        }

                        /// Get mainKeysIndexed "Service" ID's
                        var savedMainsIDs = [];
                        for (int i=0; i < mainKeysIndexed.length; i++) {
                          var ke = mainKeysIndexed[i].id;
                          savedMainsIDs.add(ke);
                        }

                        /// Add / Delete selected Main(s) Service(s)
                        for (int i =0; i < selectedSubIndexes.length; i++) {
                          /// If Corresponding 'i' ID exists in the selected "values"
                          if (valuesIDs.contains(selectedSubIndexes[i]['id'])) {
                            /// Get the index of the Corresponding ID
                            int index = valuesIDs.firstWhere((element) => element == selectedSubIndexes[i]['id']);
                            /// Assign its Bool 'value' to true in Subs Map
                            selectedSubIndexes[index]['value'] = true;
                            /// Create a Service with the selected Main Services
                            Service saving = Service(id: selectedSubIndexes[i]['id'], name: mainKeys[i], check: true, price: int.parse(mainsControllers[i].text));
                            /// Check if mainKeysIndexed don't have the specified ID
                            if (!savedMainsIDs.contains(selectedSubIndexes[i]['id'])) {
                              mainKeysIndexed.add(saving);
                            }
                          }
                          else {
                            /// If Corresponding 'i' ID exists in mainKeysIndexed (to delete)
                            if (savedMainsIDs.contains(selectedSubIndexes[i]['id'])) {
                              /// Handle Mains
                              selectedSubIndexes[i]['value'] = false; /// Assign false to Subs Map
                              mainKeysIndexed.removeWhere((element) => element.id == selectedSubIndexes[i]['id']); /// Delete it

                              /// Handle Subs
                              var k = selectedSubIndexes[i]['subs'].keys.toList(); /// Get 'subs' Keys length to Iterate it
                              for (int j=0; j < k.length; j++) {
                                /// Create map with key 'false' and value of the corresponding 'i' price
                                Map<bool,int> n = {false: int.parse(controllers[i][j].text)};
                                /// Assign the new map to the Sub-service value
                                selectedSubIndexes[i]['subs'][k[j]] = n;
                                /// If the Service that is displayed at the moment is deleted, make the checkboxListTile invisible
                                if (selectedKey == mainKeys[i]) {
                                  isServiceOn = false;
                                }
                              }
                            }
                          }
                        }

                        /// Sort the mainKeysIndexed List by its ID's
                        for (int i=0; i < mainKeysIndexed.length; i++) {
                          for (int j= i+1; j < mainKeysIndexed.length; j++) {
                            if (mainKeysIndexed[i].id > mainKeysIndexed[j].id) {
                              var temp = mainKeysIndexed[i];
                              mainKeysIndexed[i] = mainKeysIndexed[j];
                              mainKeysIndexed[j] = temp;
                            }
                          }
                        }

                        Map<int ,List> checkTrue = {};
                        for (int i=0; i < selectedSubIndexes.length; i++) {
                          if (selectedSubIndexes[i]['value']) {
                            List ch = selectedSubIndexes[i]['subs'].keys.toList();
                            List f = [];
                            for (int j=0; j < ch.length; j++) {
                              f.add(selectedSubIndexes[i]['subs'][ch[j]].keys.toList()[0]);
                            }
                            checkTrue[i] = f;
                          }
                        }
                        for (int i=0; i < checkTrue.length; i++) {
                          var cou = checkTrue.keys.toList();
                          for (int j=0; j < cou.length; j++) {
                            if (checkTrue[cou[j]]!.contains(false)) {
                              finalCheck = false;
                            }
                            else {
                              finalCheck = true;
                            }
                          }
                        }
                      }
                    });
                    _multiSelectKey.currentState?.validate();

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
                          selectedKey = item.name;
                        }
                      });
                      _multiSelectKey.currentState?.validate();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                /// Selected Main Service Price
                Visibility(
                  visible:  isServiceOn,
                  child: Flexible(
                    fit: FlexFit.loose,
                    child:
                    TextFormField(
                      controller: mainsControllers[selectedMainServiceID],
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]+"))],
                      maxLength: 5,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          iconColor: Colors.green,
                          icon: Icon(Icons.attach_money),
                          labelText: 'Enter Service Price (SAR)',
                          focusedBorder: OutlineInputBorder()
                      ),
                      onChanged: (price) {
                        setState(() {
                          int mainTemp = mainKeysIndexed.indexWhere((element) => element.id == selectedMainServiceID);
                          mainKeysIndexed[mainTemp].price = int.parse(mainsControllers[selectedMainServiceID].text);

                          Map<int ,List> checkTrue = {};
                          int checker = 0;
                          for (int i=0; i < selectedSubIndexes.length; i++) {
                            if (selectedSubIndexes[i]['value']) {
                              List ch = selectedSubIndexes[i]['subs'].keys.toList();
                              List f = [];
                              for (int j=0; j < ch.length; j++) {
                                f.add(selectedSubIndexes[i]['subs'][ch[j]].keys.toList()[0]);
                              }
                              checkTrue[i] = f;
                            }
                          }
                          for (int i=0; i < checkTrue.length; i++) {
                            var cou = checkTrue.keys.toList();
                            for (int j=0; j < cou.length; j++) {
                              if (!checkTrue[cou[j]]!.contains(true)) {
                                finalCheck = false;
                                checker = 1;
                              }
                            }
                          }
                          if (checker == 0) {
                            finalCheck = true;
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                /// Selected Main Service Sub-services & prices
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
                              /// Sub-Services checkboxListTiles
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
                                            var temp = '${selectedSubIndexes[selectedMainServiceID]['subs'][keys[selectedMainServiceID][index].value].values.first}';
                                            controllers[selectedMainServiceID][index].text = temp;

                                            Map<int ,List> checkTrue = {};
                                            int checking = 0;
                                            for (int i=0; i < selectedSubIndexes.length; i++) {
                                              if (selectedSubIndexes[i]['value']) {
                                                List ch = selectedSubIndexes[i]['subs'].keys.toList();
                                                List f = [];
                                                for (int j=0; j < ch.length; j++) {
                                                  f.add(selectedSubIndexes[i]['subs'][ch[j]].keys.toList()[0]);
                                                }
                                                checkTrue[i] = f;
                                              }
                                            }
                                            for (int i=0; i < checkTrue.length; i++) {
                                              var cou = checkTrue.keys.toList();
                                              for (int j=0; j < cou.length; j++) {
                                                if (!checkTrue[cou[j]]!.contains(true)) {
                                                  finalCheck = false;
                                                  checking = 1;
                                                }
                                              }
                                            }
                                            if (checking == 0) {
                                              finalCheck = true;
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  )
                              ),
                              /// Sub-Services Prices
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
                                      enabledBorder: OutlineInputBorder(),
                                    ),
                                    onChanged: (price) {
                                      setState(() {
                                        Map<bool, int> n = {};
                                        n = {selectedSubIndexes[selectedMainServiceID]['subs'][keys[selectedMainServiceID][index].value].keys.toList()[0]:  int.parse(controllers[selectedMainServiceID][index].text)};
                                        selectedSubIndexes[selectedMainServiceID]['subs'][keys[selectedMainServiceID][index].value] = n;

                                        Map<int ,List> checkTrue = {};
                                        int checker = 0;
                                        for (int i=0; i < selectedSubIndexes.length; i++) {
                                          if (selectedSubIndexes[i]['value']) {
                                            List ch = selectedSubIndexes[i]['subs'].keys.toList();
                                            List f = [];
                                            for (int j=0; j < ch.length; j++) {
                                              f.add(selectedSubIndexes[i]['subs'][ch[j]].keys.toList()[0]);
                                            }
                                            checkTrue[i] = f;
                                          }
                                        }
                                        for (int i=0; i < checkTrue.length; i++) {
                                          var cou = checkTrue.keys.toList();
                                          for (int j=0; j < cou.length; j++) {
                                            if (!checkTrue[cou[j]]!.contains(true)) {
                                              finalCheck = false;
                                              checker = 1;
                                            }
                                          }
                                        }
                                        if (checker == 0) {
                                          finalCheck = true;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: finalCheck,
              child: RoundedButton(
                title: 'Submit',
                colour: kDarkColor,
                onPressed: () {
                  setState(() {
                    bool checker = checkPrices();
                    if (checker) {
                      checkAll();
                      showDialog(context: context, builder: (context) {
                        return const AlertDialog(
                            title: Text('Services Updated!'),
                            icon: Icon(Icons.done),
                            iconColor: Colors.green);
                      });
                    }
                    else {
                      showDialog(context: context, builder: (context) {
                        return const AlertDialog(
                            title: Text('Enter Correct Prices'),
                            icon: Icon(Icons.warning),
                            iconColor: Colors.red);
                      });
                    }
                  });
                },
              ),
            ),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }
  }

  /// Check if user Left prices Fields blank
  bool checkPrices() {
    bool subCheck = true;
    bool mainCheck = true;
    for (int i=0; i < mainsControllers.length; i++) {
      if (selectedSubIndexes[i]['value']) {
        if (mainsControllers[i].text == '') {
          mainCheck = false;
        }
      }
    }
    for (int i=0; i < selectedSubIndexes.length; i++) {
      if (selectedSubIndexes[i]['value']) {
        List tempKeys = selectedSubIndexes[i]['subs'].keys.toList();
        for (int j=0; j < tempKeys.length; j++) {
          if (selectedSubIndexes[i]['subs'][tempKeys[j]].keys.first) {
            if (controllers[i][j].text == '') {
              subCheck = false;
            }
          }
        }
      }
    }

   return subCheck && mainCheck;
  }

  /// Finalize services and sub-services and their prices assignments
  void checkAll() {
    handlePrices();
    List finalSend = []; /// List to carry The Selected Main Services and their subs (of Type Map)
    /// Get all Selected Sub-services data
    for (int i=0; i < selectedSubIndexes.length; i++) {
      if (selectedSubIndexes[i]['value']) {
        finalSend.add(selectedSubIndexes[i]);
      }
    }

    /// Update Selected Main Services Prices
    List temp = [];
    for (int i=0; i < mainKeysIndexed.length; i++) {
      temp.add(mainKeysIndexed[i].name);
    }

    for (int i=0; i < mainsControllers.length; i++) {
      if (temp.contains(mainSer[i].name)) {
        mainKeysIndexed[mainKeysIndexed.indexWhere((element) => element.name == mainSer[i].name)].price = int.parse(mainsControllers[i].text);
      }

    }

    /// All of the rest is to Separate Main and Sub Services and their prices for DB Type
    var finalSubsNames = {};
    var finalSubsPrices = {};
    List tNames = [];
    List tPrices = [];
    for (int i=0; i < finalSend.length; i++) {
      var temp = finalSend[i]['subs'].keys.toList();
      tNames = [];
      tPrices = [];
      for (int j=0; j < temp.length; j++) {
        if (finalSend[i]['subs'][temp[j]].keys.first) {
          tNames.add(temp[j]);
          tPrices.add(finalSend[i]['subs'][temp[j]].values.first);
        }
      }
      finalSubsNames[mainKeysIndexed[i].name] = tNames;
      finalSubsPrices[mainKeysIndexed[i].name] = tPrices;
    }

    List finalM = [];
    List finalP = [];
    for (int i=0; i < mainKeysIndexed.length; i++) {
      finalM.add(mainKeysIndexed[i].name);
      finalP.add(mainKeysIndexed[i].price);
    }
    services['SubServices'] = finalSubsNames;
    services['SubPrices'] = finalSubsPrices;
    services['service'] = finalM;
    services['price'] = finalP;

    updateServices(services);
  }

  /// Assign Every sub-service its corresponding controller value if true, else 0
  void handlePrices() {
    setState(() {
      /// Handle Main Services
      List temp = [];
      for (int i=0; i < mainKeysIndexed.length; i++) {
        temp.add(mainKeysIndexed[i].id);
      }
      for (int i=0; i < mainSer.length; i++) {
        if (!temp.contains(mainSer[i].id)) {
          mainsControllers[i].text = 0.toString();
        }
        else if (temp.contains(mainSer[i].id)) {
          int tempIndex = mainKeysIndexed.indexWhere((element) => element.id == mainSer[i].id);
          mainKeysIndexed[tempIndex].price = int.parse(mainsControllers[i].text);
        }
      }

      /// Handle Sub-Services
      for (int i=0; i < selectedSubIndexes.length; i++) {
        /// if The 'i' sub-service is true, assign its selected sub-services prices from their controllers
        if (selectedSubIndexes[i]['value']) {
          for (int j=0; j < selectedSubIndexes[i]['subs'].length; j++) {
            var tempSubKeys = selectedSubIndexes[i]['subs'][keys[i][j].value].keys.toList();
            Map<bool, int> n = {};
            if (tempSubKeys[0]) {
              n = {tempSubKeys[0]: int.parse(controllers[i][j].text)};
            }
            else {
              n = {tempSubKeys[0]: 0};
            }
            selectedSubIndexes[i]['subs'][keys[i][j].value] = n;
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