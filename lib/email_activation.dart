import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/select_team.dart';
import 'package:flutter/material.dart';



/// This widget displays a message to the user that an email has been sent to
/// their email address. The user must click on the link in the email to activate
/// their account.
/// They can exit this screen by clicking on the "Okay" button.
class EmailActivation extends StatelessWidget {
  const EmailActivation({
    super.key, 
    required this.personalDetailsMap
  });


  // user's details from previous screen
  final Map <String, dynamic> personalDetailsMap;

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      
      // Center column
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Message
            Container(
              // put margin between welcome text and the text below
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: const AppText(
                text: "We have sent an email to your email address. Please click on the link in the email to activate your account. You can't sign in until you activate your account. If you don't sign in, you'll miss out on a personalized experience. The link will expire in 24 hours.",
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w300,
                align: TextAlign.center,
              )
            ),

            // Okay button
            SignUpButton(
              text: "Okay", 
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectTeam(
                    pageName: 'Select Team',
                    personalDetailsMap: personalDetailsMap)
                    ),
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
