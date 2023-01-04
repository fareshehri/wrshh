import 'package:flutter/material.dart';
import '../../Services/Auth/auth.dart';

class Capacity extends StatefulWidget {
  const Capacity({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Capacity();
  }
}

class _Capacity extends State<Capacity> {

  static const dark = Color(0xFF333A47);
  static const double leftPadding = 9;
  var bbcolor= [Colors.transparent,Colors.transparent,Colors.transparent,Colors.transparent];

  late int capacity;
  late List<DropdownMenuItem<int>> _items;
  bool gotPath = false;

  Future call() async {
    capacity = await AuthService().getCapacity();
    setState(() {
      gotPath = true;
    });
  }

  @override
  void initState() {
    super.initState();
    call();
    _items = [
      const DropdownMenuItem(
        value: 0,
        child: Text('0'),
      ),
    ];
    _items.addAll(List.generate(20, (index) {
      return DropdownMenuItem(
        value: index + 1,
        child: Text('${index + 1}'),
      );
    }));
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
        backgroundColor: Colors.white,

        appBar: AppBar(
          title: const Text("Capacity"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.lightBlue[300], size: 24
          ),
        ),

        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              /// Selected Range & Default button
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: leftPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current Capacity: $capacity',
                      style: const TextStyle(fontSize: 20, color: dark),
                    ),
                  ],
                ),
              ),

              /// TimeRange Wheel
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: leftPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton(
                        value: capacity,
                        items: _items,
                        onChanged: (value) {
                          setState(() {
                            capacity = value as int;
                          });
                        }
                    )
                  ],
                ),
              ),

              /// Done Button
              const SizedBox(height: 500, width: 20),
              Padding(
                padding: const EdgeInsets.only(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          AuthService().updateCapacity(capacity);
                        });

                        Navigator.pop(context);
                      },

                      /// Button Style
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(left: 13.0, right: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)
                        ),
                      ),
                      child: const Text("Done", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
