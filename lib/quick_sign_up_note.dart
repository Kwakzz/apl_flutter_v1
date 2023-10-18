import 'package:apl/create_user.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helper_classes/custom_appbar.dart';



/// This widget displays a message to the user before they sign up. It tells them to enter their details correctly to make life easier for the admin.
/// They can exit this screen by clicking on the "Okay" button.
class QuickSignUpNote extends StatelessWidget {
  const QuickSignUpNote({
    super.key, 
  });


  @override
  Widget build(BuildContext context) {
   
    return Scaffold(

      appBar: CustomAppbar(
        pageName: "Quick sign up note",
        icon: const Icon(Icons.arrow_back),
        prevContext: context,
      ),

      // Center column
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Message
            Container(
              // place at center of screen
              alignment: Alignment.center,
              // put margin between welcome text and the text below
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: Text(
                "Please enter your full name when signing up. Your first name and other names will go in the first name field. Your last name will go in the last name field. You would be making life easier for the admin if you do this.",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
            ),

            // Okay button
            Button(
              text: "Got it", 
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateUser(
                      pageName: 'Personal details'                  
                    ),
                  )
                );
              }
            )
          ],

        )

      ),

      // Background colour is dark blue.
      backgroundColor: const Color.fromARGB(255, 0, 53, 91)
    );
  }
}
