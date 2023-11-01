import 'package:apl/create_user.dart';
import 'package:apl/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      // Center column
      body: Center(

        // Column contains:
        // 1. APL log
        // 2. Welcome text
        // 3. Get started button
        // 4. Sign in button
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // APL Logo
            Image.asset(
              'assets/logo/apl_logo.png',
              width: 180,
              height: 180,
            ),

            // Welcome text
            Container(
              // put margin between welcome text and the text below
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Welcome!',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              )
            ),

            // We know you're eager to jump in
            Container(
              // put margin between this text and the get started button below
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                "We know you’re eager to jump right in,\nbut let’s answer a few questions first.\nYou’ll be done before you know it.",
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
            ),

            // Get started button
            Container (
              // put margin between this button and the text below
              margin: const EdgeInsets.only(bottom: 70),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to the personal details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => 
                    const CreateUser(
                      pageName: "Personal Details",
                    )),
                  );
                },
                // Get started button colour is blue
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 40, 56, 198),
                  // Get started button size
                  minimumSize: const Size(120, 40),
                  elevation: 0,
                ),
                // forward icon
                icon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 14,
                ),
                // Get started button text
                label: Text(
                  'Get Started',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ),

            // Already have an account?
            Container(
              // put margin between this text and the sign in button below
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Already have an account?",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              )
            ),

            // Sign in button
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to the Sign in screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn(pageName: "Sign In",)),
                );
              },
              // Sign in button colour is white
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                // Get started button size
                minimumSize: const Size(120, 40),
                elevation: 0  
              ),

              // forward icon
              icon: const Icon(
                Icons.login_rounded,
                color: Color.fromARGB(255, 40, 56, 198),
                size: 14,
              ),
              // Sign in button text
              label: Text(
                'Sign in',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 40, 56, 198),
                  fontWeight: FontWeight.w400,
                ),
              )
            ),
          

          ],

        )

      ),

      // Background colour is dark blue.
      backgroundColor: const Color.fromARGB(255, 0, 53, 91)
    );
  }
}
