import 'package:flutter/material.dart';
import 'package:wrshh/main.dart';
import 'package:wrshh/Pages/Account.dart';
import 'package:flutter/services.dart';

class Newcar extends StatefulWidget {
  const Newcar({Key? key}) : super(key: key);

  @override
  State<Newcar> createState() => _NewcarState();
}

class _NewcarState extends State<Newcar> {

  Map<String, List> cars ={
    'Chevrolet': ["Groove","Captiva","Caprice","Trax","Malibu","Silverado","Tahoe/Suburban","Blazer","Traverse","Camaro","Epica","Cruze","Aveo","Spark",],
    'Kia':["Rio","Cerato","K5","K8","Stinger","Optima","Quoris","Cadenza","Pegas","Sonet","Seltos","Carens","Sportage","Sorento","Telluride","Soul","Mohave","Niro","Carnival","K900",],
    "Peugeot":["208","508","2008","3008","5008"],
    "Hyundai":["Accent","Elantra","Sonata ","Azera","I40","Genesis","Centennial ","Kona","Creta","Tucson","SantaFe","Palisade","H1","Grand Santafe","Veloster","I10","I20","I30","Staria",],
    "Fiat":['500'],
    "Byd":["F3","F7","Qin Pro","S6","S7","Song Pro","Song Max","Tang"],
    "Renault":["Symbol","Megane","Fluence","Safrane","Talisman","Koleos","Capture","Duster","Dokker","Master"],
};

  final List<String> _manufacturers = [
    "Toyota","Honda","Bestune","Volkswagen","Changan","Alfa Romeo","GAC","Mazda","Geely","Rolls Royce","Ssang Yong","Baic","Nissan","Infiniti","Maxus","Subaru","Ferrari","Cadillac","Dongfeng","Audi","Isuzu","Jac","Genesis","Mercedes","Maserati","Lexus","Lamborghini","Jaguar","Mini","Exeed","Chery","BMW","Chrysler","Bugatti","Jeep","Lifan",
    "Foton","Dodge","Haval","Suzuki","MG","Ford","Bentley","Land Rover","Jetour","Volvo","Porsche","Lincoln","Aston Martin","Mitsubishi","Gmc","Hongqi","Other"];
  String? _currentSelectedManu='Chevrolet';
  int? _currentSelectedYear=2023;
  //car info
  final _formKey = GlobalKey<FormState>();
    

  @override
  Widget build(BuildContext context) {
  
  var seen = Set<String>();
  List<String> uniquelist = _manufacturers.where((manu) => seen.add(manu)).toList();

  List<int> year = [for (var i = 1960; i <= 2023; i++) i];
  

    
    return Scaffold(
     appBar: AppBar(title: Text('Add New Car'),centerTitle: true,backgroundColor: Colors.transparent,foregroundColor: Colors.black,elevation: 0,iconTheme:IconThemeData(color: Colors.lightBlue[300],size: 24),)
     ,
     
     body: Container(margin: EdgeInsets.fromLTRB(25,50,25,50),
       child: ListView(children: [

        Container(child: Form(key: _formKey,child: Column(children: <Widget>[
          //Manufacturer Selection 
          DropdownButton<String>(value: _currentSelectedManu,items: uniquelist.map((manu){
              return DropdownMenuItem( child: Text(manu),value: manu,);}).toList(),
            onChanged: (manu)=> setState(()=>_currentSelectedManu=manu)
          ),

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
                  TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.zero),inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(17)],validator: (value) {if (value == null || value.isEmpty ) {return 'Please enter VIN Number';}return null;},),
                  ElevatedButton.icon(onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
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