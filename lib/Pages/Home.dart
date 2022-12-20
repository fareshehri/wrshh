// ignore_for_file: file_names

import 'package:wrshh/Services/Maps/googleMapsPart.dart';
import 'package:wrshh/main.dart';
import 'package:wrshh/Pages/Account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

Size displaySize(BuildContext context) {
  debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {



//vin
final _formKey = GlobalKey<FormState>();
//styles
  var tc=[Colors.red[400],Colors.green[400],Colors.blue[400],Colors.orange[400]];
  var buttoncolor= [Colors.red[300],Colors.green[300],Colors.blue[300],Colors.orange[300]];
  //var bbcolor= [Colors.orange[300],Colors.blue[300],Colors.green[300],Colors.red[300]];
  var bbcolor= [Colors.transparent,Colors.transparent,Colors.transparent,Colors.transparent];

  var titlename=['Home','Maintainance','Bookings'];

  static const TextStyle optionStyle =TextStyle(fontSize: 25, fontWeight: FontWeight.w400);
  int _selectedIndex = 0;

//date picker
DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Sizer(
    builder: (context, orientation, deviceType) {
    return Scaffold(
      drawer: Drawer(child: ListView(children: [
      ListTile(hoverColor:tc[_selectedIndex] ,leading: const Icon(Icons.manage_accounts),title: const Text('Account'),onTap: () {setState(() {Navigator.of(context,rootNavigator: true,).push(MaterialPageRoute(builder: (BuildContext context) => const Account(),));});},)
      ,
      ListTile(hoverColor:tc[_selectedIndex] ,leading: const Icon(Icons.exit_to_app),title: const Text('Logout'),)//onTap: () {logOut();setState(() {Navigator.of(context,rootNavigator: true,).pushReplacement(_Wrapper());});},)
      
      ],
      )),
      //AB:
      //appBar: AppBar(title: Text('Home'),centerTitle: true,backgroundColor:bbcolor[_selectedIndex],) ,
      appBar: AppBar(systemOverlayStyle: SystemUiOverlayStyle(systemNavigationBarColor: buttoncolor[_selectedIndex]),actionsIconTheme:IconThemeData(color:buttoncolor[_selectedIndex],size: 24 ) ,title:Text(titlename[_selectedIndex],style: optionStyle,),centerTitle: true,backgroundColor: Colors.transparent,foregroundColor: Colors.black,elevation: 0,iconTheme:IconThemeData(color: Colors.lightBlue[300],size: 24),),
      

      body: Center(child: FutureBuilder(initialData: _selectedIndex,builder: (context, snapshot) {
        if(_selectedIndex ==0){
              //Main PAGE after listview try padding: EdgeInsets.all(8)
              return SizedBox(
                height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top -kToolbarHeight,
                width: MediaQuery.of(context).size.width*0.9,
                child: ListView(padding: const EdgeInsets.all(8),children: [                
                SizedBox(child: Image.asset('images/wallpaper3.jpg',fit: BoxFit.contain,)),
                // const SizedBox(height: 1,),
                // SizedBox(child: Image.asset('images/wallpaper2.jpg',fit: BoxFit.contain,)),
                
                Form(key: _formKey,child: Column(children: <Widget>[
                  TextFormField(decoration: const InputDecoration(contentPadding: EdgeInsets.zero),inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(17)],validator: (value) {if (value == null || value.isEmpty ) {return 'Please enter VIN Number';}return null;},),
                  ElevatedButton.icon(onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),);}},
                        icon: const Icon(Icons.search_rounded,), label: const Text('Search'),)
        
                ],
      ),
      )]),)              ;
}

            if(_selectedIndex ==1){
            return const googleMaps();
            }

              else{
              //Account Page?
              return ListView(children: [
                SizedBox(height: 50,),
                Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.lightGreen,
                          child: Padding (
                padding: EdgeInsets.all(16),
                  child: Row (
                  children: [
                    Column (
                      children: [
                        Text("Fast Food",style: TextStyle(fontSize: 30, color: Colors.blue)),
                        SizedBox(height: 10),
                        Text("Description ....", style: TextStyle(fontStyle: FontStyle.italic))
                      ],
                    )
                    ,
                    SizedBox(width: 70),
                    Image.asset (
                        "images/Logo.png",
                    ),
                    
                    
                  ],
                ),
                    
                  )),
              ]);}

      
      
        
      },
      )),
      
      bottomNavigationBar: BottomNavigationBar(elevation: 0,backgroundColor: bbcolor[_selectedIndex],items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home',backgroundColor: Colors.orange,),
      BottomNavigationBarItem(icon: Icon(Icons.add_circle),label: 'Maintainance',backgroundColor: Colors.green,),
      BottomNavigationBarItem(icon: Icon(Icons.calendar_month),label: 'Bookings',backgroundColor: Colors.blue,),],
      
      //CI: This will see the button clicked index ex(Home will set index to 0) important on changing the content
      currentIndex: _selectedIndex,
      selectedItemColor: buttoncolor[_selectedIndex],
      onTap:(int index) {setState(() {_selectedIndex = index;});
  },
      ),
      

      );
    
  }
    );
  }
}


// ignore: non_constant_identifier_names
// Route _Wrapper() {
// return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => const Wrapper(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0);
//       const end = Offset.zero;
//       const curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }