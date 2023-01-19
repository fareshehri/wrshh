import 'package:flutter/material.dart';

class AppointmentsCard extends StatelessWidget {
  final String? itemPictureURL;
  final String? itemTitle;
  final String? itemSubtitle;
  final Function? itemOnTap;
  final double? itemHeight;

  const AppointmentsCard({
    this.itemPictureURL,
    required this.itemTitle,
    this.itemSubtitle,
    this.itemOnTap,
    this.itemHeight
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: itemHeight,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, right: 16),
              child: FittedBox(
                fit: BoxFit.fill,
                // TODO: add image from database
                child: Image.asset(
                  'assets/images/Logo.png',
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(itemTitle!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      itemSubtitle!,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            FittedBox(
                alignment: Alignment.centerRight,
                fit: BoxFit.fitWidth,
                child:
                    ElevatedButton(
                      // TODO: add onTap function
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => SingleChildScrollView(
                                child: Container(
                                    padding: EdgeInsets.only(
                                        top: 16,
                                        left: 16,
                                        right: 16,
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                                    child: Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey, width: 2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text('Hello'),
                                      ),
                                    ))));
                      },
                      child: Text('Show Details'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                    // SizedBox(height: 10),
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   child: Text('Cancel'),
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.pink,
                    //     onPrimary: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(32.0),
                    //     ),
                    //   ),
                    // ),

                ),
          ],
        ),
      ),
    );
  }
}
