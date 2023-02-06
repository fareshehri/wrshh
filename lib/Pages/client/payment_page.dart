// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  late String _cardNumber;
  late String _expiryDate;
  late String _cvv;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Card Number",
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        maxLength: 16,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please enter your card number';
                          }
                          return null;
                        },
                        onSaved: (value) => _cardNumber = value!,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Expiry Date",
                          prefixIcon: Icon(Icons.date_range),
                        ),
                        maxLength: 5,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please enter the expiry date';
                          } else if (value.length >= 3) {
                            try{
                              if (int.parse(value.substring(0, 2)) > 12 ||
                                  int.parse(value.substring(0, 2)) < 1) {
                                return 'Please enter a valid month';
                              }
                            } catch (e){
                              return 'Please enter a valid month';
                            }
                           if (value.substring(2, 3) != "/"){
                             return 'Please enter the expiry date in the format MM/YY';
                           }
                           if (value.length == 5){
                             try{
                               if (int.parse(value.substring(3, 5)) < 10){
                                 return 'Please enter a valid year';
                               }
                              } catch (e){
                                return 'Please enter a valid year';

                             }
                           }
                          }
                          return null;
                        },
                        onSaved: (value) => _expiryDate = value!,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "CVV",
                          prefixIcon: Icon(Icons.security),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please enter the CVV number';
                          }
                          return null;
                        },
                        onSaved: (value) => _cvv = value!,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    // Process the payment here
                  }
                },
                child: const Text("Pay"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
