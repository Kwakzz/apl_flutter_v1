import 'package:apl/create_user.dart';
import 'package:apl/forgot_password.dart';
import 'package:apl/helper_functions/convert_to_json.dart';
import 'package:apl/homepage.dart';
import 'package:apl/requests/user/sign_in_req.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helper_classes/custom_dialog_box.dart';
import 'helper_classes/form_label.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'helper_classes/custom_appbar.dart';
import 'helper_classes/sign_in_field.dart';

class SignIn extends StatefulWidget {

  const SignIn({super.key, required this.pageName});
  final String pageName;
  

  @override
  State<SignIn> createState() => _SignInState();

}

class _SignInState extends State<SignIn> {
  String pageName = 'Sign In';
  final _formKey = GlobalKey<FormState>();

  String signInDetailsJson = '';

  // controllers for the text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  
  @override
  Widget build(BuildContext context) {

   
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold (

        // app bar with back button and page name 
        appBar: CustomAppbar(
          pageName: pageName,
          icon: const Icon(Icons.arrow_back),
          prevContext: context,
        ),

        // sign in form.
        // It contains the following fields:
        // - Email address
        // - Password
   
        body: Form(
          key: _formKey,
          child: ListView(

            children: [

              // Skip to app without signing in
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(15),
                
                child: GestureDetector( 
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Skip to app without signing in",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 0, 53, 91),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.arrow_forward,
                        color:  Color.fromARGB(255, 0, 53, 91),
                        size: 14,
                      ),
                    ],
                  )
                ),
              ),

              // Email address field
              const SignInFormLabel(labelText: 'Email Address'),
              SignInTextField(
                labelText: 'Email Address',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),

              // Password field
              const SignInFormLabel(labelText: 'Password'),
              SignInPasswordField(
                labelText: 'Password',
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),

              // Forgot password
              Container(
                margin: const EdgeInsets.only(right: 20, top: 20),
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassword(
                          pageName: 'Forgot your password?',
                        ),
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(
                            pageName: 'Forgot your password?',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: const Color.fromARGB(200, 0, 0, 0),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ),
              ),

              // Sign in button
              SignInButton(
                text: 'Sign In',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    signInDetailsJson = convertSignInDetailsToJson(
                      _emailController.text, 
                      _passwordController.text
                    );

                    AuthProvider authProvider = AuthProvider();
    
                    Map<String, dynamic> response = await authProvider.login(signInDetailsJson);

                    if (!mounted) return;

                    if (response['status']) {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    } 
                    else {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return ErrorDialogueBox(
                            content: response['message'],
                          );
                        }
                      );
                    }
                    
              
                  }
                },
              ),

              // Don't have an account?
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an APL account?",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: const Color.fromARGB(200, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const CreateUser(pageName: 'Personal Details',),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 0, 53, 91),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),





            ],
          ) 
        ),

        backgroundColor: Colors.white,
      )
    );
  }
}
