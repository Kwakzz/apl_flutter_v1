import 'package:flutter/material.dart';
import 'package:apl/helper_classes/text.dart';

class SignUpButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const SignUpButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 10),
      padding: const EdgeInsets.only(left: 60, right: 60),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(0, 40),
          backgroundColor: const Color.fromARGB(255, 40, 56, 198),
        ),
        child: AppText(
          color: Colors.white,
          text: text,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        )
      ),
    );
  }
}


class Button extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const Button({
    super.key, 
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(

          elevation: 0,
          minimumSize: const Size(0, 40),
          backgroundColor: const Color.fromARGB(255, 40, 56, 198),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
} 


class SignInButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const SignInButton({
    super.key, 
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 53, 91),
        ),
        child: AppText(
          text: text,
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
} 

class GenericFormButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const GenericFormButton({
    super.key, 
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.only(left: 70, right: 70, top: 10, bottom: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 53, 91),
        ),
        child: AppText(
          text: text,
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
} 

class SignInWithGoogleButton extends StatelessWidget {

  const SignInWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 40, 56, 198),
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/other/google_logo.png',
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 10),
            const Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              )
            ),
          ],
        ),
      )
    );
  }
}



class SmallAddButton extends StatelessWidget {

  const SmallAddButton(
    {
      super.key,
      required this.onPressed,
      required this.text,
    }
  );

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10, right: 10),
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.add,
          size: 12,
          color: Colors.black,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white, 
          backgroundColor: Colors.white,
          minimumSize: const Size(90, 40),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),            
          ),
          side: const BorderSide(
            color: Color.fromARGB(255, 136, 136, 136),
            width: 0.1,
          )
        ),
        label: AppText(
          text: text,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        onPressed: onPressed
      )
    );
  }
}



class AddButton extends StatelessWidget {

  const AddButton(
    {
      super.key,
      required this.onPressed,
      required this.text,
    }
  );

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.add,
          color: Colors.black,
          size: 12,
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, 
          backgroundColor: Colors.white,
          minimumSize: const Size(60, 45),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )
        ),
        label: AppText(
          text: text,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black
        ),
        onPressed: onPressed
      )
    );
  }
}





class UploadImageButton extends StatelessWidget {

  const UploadImageButton(
    {
      super.key,
      required this.onPressed,
    }
  );

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
      alignment: Alignment.centerLeft,
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.upload,
          color: Colors.black,
          size: 12,
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, 
          backgroundColor: Colors.white,
          minimumSize: const Size(60, 45),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )
        ),
        label: const AppText(
          text: "Upload Cover Image",
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black
        ),
        onPressed: onPressed
      )
    );
  }

}











