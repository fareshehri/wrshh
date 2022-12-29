import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wrshh/main.dart';
import 'package:wrshh/Pages/Account.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Newcar extends StatefulWidget {
  const Newcar({Key? key}) : super(key: key);


  @override
  State<Newcar> createState() => _NewcarState();
  
}


final _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;


var name=getUsername().toString();
var carsvin=getUserVin().toString();

Future<dynamic> getUserVin() async {
  final User user = await _auth.currentUser!;
    final client = await _firestore.collection('clients').doc(user!.email).get();
    if(client.exists){
        return carsvin= client['vin'];
        //email= client['email'];
        // name= client['name'];
        // carsvin= client['vin'];
  }
}
Future<void> getUsername() async {
  final User user = await _auth.currentUser!;
    final client = await _firestore.collection('clients').doc(user!.email).get();
    if(client.exists){
        return name= client['name'];
        //email= client['email'];
        // name= client['name'];
        // carsvin= client['vin'];
  }
}



class _NewcarState extends State<Newcar> {

  var _selectedB = 'Chevrolet';
  var _selectedC = 'Groove';
  var _vin;
  var _currentSelectedYear;
  var viscar = true;
  var visin = false;
 var cars ={
    "Toyota":["Yaris","Corolla","Camry","Avalon","Aurion","Supra","86","Yaris Sport","Prius","Raize","Rush","Corolla Cross","RAV4","FJ Cruiser","Fortuner","Highlander","Prado","Land Cruiser Wagon","C-HR","Land Cruiser pickup","Sequoia","Innova","Avanza","Previa","Granvia","Liteace","Hiace","Hilux","Land Cruiser 70","Dyna","Coaster",],    "Nissan":['ni'],
    "Mazda":['3','6','CX3','CX5','CX9'],
    "Honda":['City','Civic','Accord','HRV','CRV','Pilot','Odyssey'],
    "Chevrolet": ["Groove","Captiva","Caprice","Trax","Malibu","Silverado","Tahoe/Suburban","Blazer","Traverse","Camaro","Epica","Cruze","Aveo","Spark",],
    "Dodge":['Charger','Challenger','Durango','Neon','RAM 1500','RAM 2500'],
    "Ford":["Taurus","Figo","Focus","Fusion","Mustang","TERRITORY","Edge","Explorer","Expedition","Bronco","Ecosport","Escape","Flex","Ranger ","Ranger Raptor ","F150","F150 Raptor","Transit",],
    "Gmc":['Yukon/Yukon XL','Sierra','Terrain','Acadia'],
    "Kia":["Rio","Cerato","K5","K8","Stinger","Optima","Quoris","Cadenza","Pegas","Sonet","Seltos","Carens","Sportage","Sorento","Telluride","Soul","Mohave","Niro","Carnival","K900",],
    "Hyundai":["Accent","Elantra","Sonata ","Azera","I40","Genesis","Centennial ","Kona","Creta","Tucson","SantaFe","Palisade","H1","Grand Santafe","Veloster","I10","I20","I30","Staria",],
    "Changan":['CS35','CS75','CS95','UNI-T','UNI-K','UNI-V'],
    "Geely":['CoolRay','Binray','Emgrand','Tugla'],
    "Chery":['Arrizo 5','Arrizo 6','Tiggo 3','Tiggo 4','Tiggo 7','Tiggo 8'],
    "Haval":['H3','H6','H9'],
    "MG":['5','6','GT','ZS','RX'],
    "Fiat":['500'],
    "Byd":["F3","F7","Qin Pro","S6","S7","Song Pro","Song Max","Tang"],
    "Bestune":['T33','T77','T99','B70'],
    "GAC":['GA4','GA6','GA8','GS3','GS4','GS5','GS8','GN6','GN8'],
    "Renault":["Symbol","Megane","Fluence","Safrane","Talisman","Koleos","Capture","Duster","Dokker","Master"],
    "Peugeot":["208","508","2008","3008","5008"],
    "Suzuki":['Dzire','Baleno','Ciaz','Swift','Ertiga','Vitara','Jimny','APV','Carry'],
    "Mitsubishi":['Attrage','Space Star','Xpander','ASX','Eclipse Cross','Outlander','MONTERO'],
    "Genesis":['G70','G80','G90','GV70','GV80'],
    "Audi":['A3','A4','A5','A6','A7','A8','RS4','RS5','RS6','RS7','TT','Q2','Q3','Q5','Q7','Q8'],
    "Mercedes":['A','E','C','CLA','CLS','S','SLK','SLC','GLE','GLA','GLK','GLC','ML','V'],
    "BMW":['1','2','3','4','5','6','7','I8','Z4','X1','X2','X3','X4','X5','X6','X7'],
    "Lexus":['IS','ES','LS','RC','LC','UX','GX','RX','NX','LX'],
    "Volkswagen":['Jetta','Passat','CC','Areton','T-Roc','Beatle','Golf','Tiguan','Teramont','Touareg'],
    "Alfa Romeo":['GIULIA','Stelvio'],
    "Other":['Other']


};

  //   "Rolls Royce","Maserati","Ssang Yong","Baic","Infiniti","Maxus","Subaru","Ferrari","Cadillac","Dongfeng","Isuzu","Jac","Lamborghini","Jaguar","Mini","Exeed","Chrysler","Bugatti","Jeep","Lifan",
  //   "Foton","Bentley","Land Rover","Jetour","Volvo","Porsche","Lincoln","Aston Martin","Hongqi",

  //car info
  final _formKey = GlobalKey<FormState>();
    

  @override
  Widget build(BuildContext context) {
    
    

  var _selectbrand = cars.keys;
  var _selectcar = cars[_selectedB];
  
  int? _currentSelectedYear=2023;
  List<int> year = [for (var i = 1960; i <= 2023; i++) i];
      
    return Scaffold(
     appBar: AppBar(title: Text('Add New Car'),centerTitle: true,backgroundColor: Colors.transparent,foregroundColor: Colors.black,elevation: 0,iconTheme:IconThemeData(color: Colors.lightBlue[300],size: 24),)
     ,
     
     body: Container(margin: EdgeInsets.fromLTRB(25,50,25,50),
       child: ListView(children: [
        Container(
          child: Column(children: [
            Text('Hello $name You have $carsvin Registered')
          ],),
        ),

        Container(
          child: Form(key: _formKey,child: Column(children: <Widget>[
          
          //select brand
          DropdownButton(value: _selectedB,items: _selectbrand.map((map) => DropdownMenuItem(child: Text(map),value: map),).toList(), 
          onChanged: (val) {setState(() {
            _selectedB=val.toString();
            _selectedC=cars[_selectedB]!.first;
            //if(_selectedC!=null){_selectedC = null;}
            if(_selectedB=="Other"){viscar=false;visin=true; _selectedB=val.toString();}
            else{
            viscar=true;
            visin=false;}
          });}
          ),
          
          //select car
          Visibility(
            visible: viscar,
            child: DropdownButton(value: _selectedC,items: _selectcar!.map((map) => DropdownMenuItem(child: Text(map),value: map),).toList(), 
            onChanged: (val) {setState(() {
              _selectedC=val.toString();
              //if(_selectedB!=null){_selectedC = val.toString();}
              }
              );
              }
            ),
          ),

          Visibility(visible: visin,
          child: Container(
            child: Column(children: [
                SizedBox(height:30 ,),
                Text("Manufacturer"),
                TextField(onChanged: (value) => _selectedB=value,),
                SizedBox(height:30 ,),
                Text("Car"),
                TextField(onChanged: (value) => _selectedC=value,)
              ],),
          )),

          SizedBox(height: 50,),
          //Year Of Make Selection 
          DropdownButton<int>(value: _currentSelectedYear,items: year.map((item){
              return DropdownMenuItem<int>(child: Text(item.toString()),value: item,);}).toList(),
            onChanged: (item)=> setState(()=>_currentSelectedYear=item as int)
          ),
                  /////////////////////////////////////////
                  ////////////////////////////////////
                  ////////////////
                  ///////
                  ////
                  SizedBox(height: 50,),
                  Text('Vin'),
                  TextFormField(onChanged: (value) => _vin=value,decoration: InputDecoration(contentPadding: EdgeInsets.zero),inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(17)],validator: (value) {if (value == null || value.isEmpty ) {return 'Please enter VIN Number';}return null;},),
                  ElevatedButton.icon(onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      print(_selectedB);
                      print(_selectedC);
                      print(_currentSelectedYear);
                      print(_vin);
                      print('===================');
                      print(name);
                      print(carsvin);
                      Map<String,String> saved={
                        'carManufacturer': _selectedB,
                        'carModel': _selectedC,
                        'carYear': _currentSelectedYear.toString(),
                      };
                      FirebaseFirestore.instance.collection('vin').doc(_vin).set(saved);

                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),);}},
                        icon: Icon(Icons.save), label: Text('Save'),)
        
                ],
      ),
      ),)
       ]
     ))
     );
    
    
  }
  }
