// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../Pages/client/service_select.dart';
import '../Auth/client_database.dart';

class BottomPill extends StatelessWidget {
  const BottomPill({
    Key? key,
    required this.pinPillPosition,
    required this.workshopInfo,
    required this.rate,
  }) : super(key: key);

  final double pinPillPosition;
  final Map<String, dynamic> workshopInfo;
  final double rate;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      /// Pin Tap Animation speed
      duration: const Duration(milliseconds: 250),

      /// Comes for a transition
      curve: Curves.easeInOut,

      /// Location on the device screen
      left: 0,
      right: 0,

      /// Transition from the bottom
      bottom: pinPillPosition,
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 5, left: 14, right: 14),
        padding: const EdgeInsets.all(15),

        /// Unnecessary details
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: Offset.zero)
            ]),
        child: Column(
          children: [
            newDes(),

            // /// upper lower pill
            // upperLowerPill(),
            //
            // /// lower lower pill
            // lowerLowerPill(),

            ///Book button pill
            bookButtonPill(context)
          ],
        ),
      ),
    );
  }

  Row newDes() {
    return Row(children: [
      Stack(
        /// "Rendered" area is only the stack?
        clipBehavior: Clip.none,
        children: [
          /// Picture part shape
          ClipOval(
              child: Image.network(
            workshopInfo['logo'],
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/Logo.png',
                width: 80,
                height: 80,
              );
            },
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          )),
        ],
      ),
      const SizedBox(
        width: 10,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workshopInfo['workshopName'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < 5; i++)
                if (i < rate.round())
                  const Icon(
                    Icons.star,
                    color: Colors.green,
                    size: 20,
                  )
                else
                  const Icon(
                    Icons.star_border,
                    color: Colors.green,
                    size: 20,
                  ),
              const SizedBox(width: 5),
              FittedBox(
                fit: BoxFit.fitHeight,
                child: Text('based on ${workshopInfo['numberOfRates']} rates',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  /// upper lower pill
  Container upperLowerPill() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          /// Logo Code Part
          Stack(
            /// "Rendered" area is only the stack?
            clipBehavior: Clip.none,
            children: [
              /// Picture part shape
              ClipOval(
                  child: Image.network(
                workshopInfo['logo'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              )),
            ],
          ),

          /// Area next to Logo part
          const SizedBox(width: 20),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// First Line text
              Text(workshopInfo['workshopName'],
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
            ],
          ))
        ],
      ),
    );
  }
  //
  // /// lower lower pill
  // Container lowerLowerPill() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         SizedBox(height: 20),
  //         Row(
  //           children: [
  //             /// Circular image code (star)
  //             Container(
  //               width: 50,
  //               height: 50,
  //               padding: EdgeInsets.all(5),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(50),
  //                 border: Border.all(color: Colors.green, width: 4),
  //               ),
  //               child: const Icon(
  //                 Icons.star,
  //                 color: Colors.yellow,
  //                 size: 30,
  //               ),
  //             ),
  //
  //             /// Text code
  //             const SizedBox(width: 20),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: const [
  //                 /// First Line
  //                 Text("no way jose",
  //                     style: TextStyle(fontWeight: FontWeight.bold)),
  //
  //                 /// Second Line
  //                 Text("Recommended for ford vehicles..")
  //               ],
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  ///Book button pill
  Column bookButtonPill(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          bool isBooked = await checkFutureAppointment();
                          if (isBooked) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'You have already booked an appointment')));
                          } else {
                            /// Navigate to the bookPage() function
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ServiceSelection(
                                      workshopInfo: workshopInfo,
                                    )));
                          }
                        },

                        /// Button Style
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(11.0),
                          minimumSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                        ),

                        /// Text on Button
                        child: const Text("Book",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  )),
            ),
          ],
        )
      ],
    );
  }
}
