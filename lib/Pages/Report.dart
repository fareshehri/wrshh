// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
final DateFormat formatter = DateFormat('yyyy-MM-dd');

class ReportPage extends StatefulWidget {
  final String vin;
  final String Wid;
  const ReportPage({Key? key,required this.vin, required this.Wid}) : super(key: key);

  @override
  State<ReportPage> createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {
  String selectedDate = formatter.format(DateTime.now());
  //DateTime selectedDate = DateTime.now();
  final myController = TextEditingController(text:formatter.format(DateTime.now()));

  
  bool gotPath = true;

  
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    
    

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = formatter.format(picked);
        myController.text=selectedDate.toString();

      });
    }
    }
    var vin = widget.vin;//vin number
    var wid = widget.vin;//workshop id
    if (!gotPath){
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(),
      ),
    );
  }

//when values are stored
  else{
        return Scaffold(
     appBar: AppBar(title: Text('Report'),centerTitle: true,backgroundColor: Colors.transparent,foregroundColor: Colors.black,elevation: 0,iconTheme:IconThemeData(color: Colors.lightBlue[300],size: 24),)
     ,
     body: Container(margin: EdgeInsets.fromLTRB(25,50,25,50),
       child: ListView(children: [
        Container(
          child: Form(child: Column(children: <Widget>[
              TextFormField(readOnly: true,initialValue: vin,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(floatingLabelAlignment: FloatingLabelAlignment.center,label: Text('Vin Number'),border: OutlineInputBorder(),contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2)),),
              const SizedBox(height: 20,),

              //TextFormField(controller: myController,readOnly: true,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(floatingLabelAlignment: FloatingLabelAlignment.center,label: Text('Date'),border: OutlineInputBorder(),icon:IconButton(icon:Icon(Icons.calendar_month_outlined,),onPressed:() => _selectDate(context) , ),contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2)),),
              TextFormField(onTap: () => _selectDate(context),controller: myController,readOnly: true,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(floatingLabelAlignment: FloatingLabelAlignment.center,label: Text('Date'),border: OutlineInputBorder(),suffixIcon:Icon(Icons.calendar_month_outlined,),contentPadding: EdgeInsets.zero),),
             
              const SizedBox(height: 20,),


              const Text('Details'),
              TextFormField(readOnly: true,initialValue: vin,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(border: OutlineInputBorder(),hintText: vin,contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2)),),
              const SizedBox(height: 20,),

              const Text('Upload'),
              TextFormField(readOnly: true,initialValue: vin,textAlign: TextAlign.center,textAlignVertical: TextAlignVertical.center,decoration: InputDecoration(border: OutlineInputBorder(),hintText: vin,contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 2)),),
              const SizedBox(height: 20,),
            
                    ])
          ),
        )
       ])
     )
        );
  }
  }
}