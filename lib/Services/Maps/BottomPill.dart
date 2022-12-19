import 'package:flutter/material.dart';
import 'bookPage.dart';

class BottomPill extends StatelessWidget {
  const BottomPill({
    Key? key,
    required this.pinPillPosition,
  }) : super(key: key);

  final double pinPillPosition;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      /// Pin Tap Animation speed
      duration: const Duration(milliseconds: 250),
      /// Comes for a transition
      curve: Curves.easeInOut,
      /// Location on the device screen
      left:0,
      right:0,
      /// Transition from the bottom
      bottom: pinPillPosition,
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom:5, left:14, right:14),
        padding: const EdgeInsets.all(15),
        /// Unnecessary details
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: Offset.zero
              )
            ]
        ),
        child: Column(
          children: [

            /// upper lower pill
            upperLowerPill(),

            /// lower lower pill
            lowerLowerPill(),

            ///Book button pill
            bookButtonPill(context)
          ],
        ),
      ),
    );
  }

  /// upper lower pill
  Container upperLowerPill() {
    return Container(
      color:Colors.white,
      child: Row(
        children: [
          /// Logo Code Part
          Stack(
            /// "Rendered" area is only the stack?
            clipBehavior: Clip.none,
            children: [
              /// Picture part shape
              ClipOval(
                  child: Image.asset('/wrshh/assets/images/FFFF.jpg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
              ),
            ],
          ),
          /// Area next to Logo part
          const SizedBox(width: 20),
          Expanded(
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// First Line text
                  Text('Something blah blah',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      )
                  ),
                  /// Second Line text
                  Text("indeed blah blah"),
                  /// Third Line text
                  Text("yes yes")
                ],
              )
          )
        ],
      ),
    );
  }

  /// lower lower pill
  Container lowerLowerPill() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              /// Circular image code (star)
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.green, width: 4),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 30,
                ),
              ),
              /// Text code
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  /// First Line
                  Text("no way jose",
                      style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  /// Second Line
                  Text("Recommended for ford vehicles..")
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  ///Book button pill
  Container bookButtonPill(BuildContext context) {
    return Container(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 130),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            /// Navigate to the bookPage() function
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => bookPage()));
                          },
                          /// Button Style
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(11.0),
                            minimumSize: const Size(100, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)
                            ),
                          ),
                          /// Text on Button
                          child: const Text("Book", style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold )),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          );
  }

}