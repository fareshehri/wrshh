import 'package:flutter/material.dart';

const kDarkColor = Color(0xFFc6357e);
const kLightColor = Color(0xFFff357e);
const kBorderColor = Color(0xFF4d4d4d);

const kTextFieldDecoratopn = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  labelStyle: TextStyle(color: Colors.black87,),
  floatingLabelAlignment: FloatingLabelAlignment.center,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kBorderColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kDarkColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
  ),
);
