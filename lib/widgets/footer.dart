import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
            // color: Theme.of(context).colorScheme.primary,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            // color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget> [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child:  Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: IconButton(
                                  icon: const Icon(FontAwesomeIcons.instagram,size: 20.0,),
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: IconButton(
                                  icon: const Icon(FontAwesomeIcons.facebook,size: 20.0,),
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  onPressed: () {},
                                ),
                              ),
                            )
                          ),
                          SizedBox(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child:Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  icon: const Icon(FontAwesomeIcons.pinterest,size: 20.0,),
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  onPressed: () {},
                                ),
                              ),
                            )
                          ),
                          SizedBox(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child:Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  icon: const Icon(FontAwesomeIcons.paypal,size: 20.0,),
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  onPressed: () {},
                                ),
                              ),
                            )
                          ),
                        ]
                      ),),
                      const Text('Copyright ©2025, All Rights Reserved.',style: TextStyle(fontWeight:FontWeight.w300, fontSize: 12.0, color:  Color.fromARGB(255, 252, 142, 208)),),
                      const Text('Made ️by Tien Tran',style: TextStyle(fontWeight:FontWeight.w300, fontSize: 12.0,color:  Color.fromARGB(255, 252, 142, 208)),),
                    ]
                  ),    
                )
              ]
            )
          ),
    );
  }

}



