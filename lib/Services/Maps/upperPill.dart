import 'package:flutter/material.dart';

class upperPill extends StatelessWidget {
  const upperPill({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      /// Location on the Device screen
      top:20,
      left:0,
      right:0,
      child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 10, bottom:10, left:20, right:20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              /// Small unnecessary details
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset.zero
                )
              ]
          ),
          child:Row(
              children: [
                Container(
                  width:40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Mohammed fallah',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            )
                        ),
                        Text('My Location',
                          style: TextStyle(
                              color: Colors.green
                          ),
                        )
                      ],
                    )
                ),
                const Icon(
                  Icons.location_pin,
                  color: Colors.blue,
                  size: 40,
                )
              ]
          )
      ),
    );
  }
}