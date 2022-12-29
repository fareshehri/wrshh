import 'package:flutter/material.dart';

// const kSendButtonTextStyle = TextStyle(
//   color: kBorders,
//   fontWeight: FontWeight.bold,
//   fontSize: 18.0,
// );


const kActiveCardColor = Color(0xFFc6357e);
const kInactiveCardColor = Color(0xFFff357e);
const kBorders = Color(0xFF4d4d4d);

// const kMessageTextFieldDecoration = InputDecoration(
//   contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//   hintText: 'Type your message here...',
//   border: InputBorder.none,
// );
//
// const kMessageContainerDecoration = BoxDecoration(
//   border: Border(
//     top: BorderSide(color: kBorders, width: 2.0),
//   ),
// );

const kTextFieldDecoratopn = InputDecoration(
    hintText: 'Enter a value',
    hintStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kBorders, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kBorders, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),);
