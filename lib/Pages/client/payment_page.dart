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
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please enter the expiry date';
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
