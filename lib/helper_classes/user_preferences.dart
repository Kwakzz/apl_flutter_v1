import 'package:apl/helper_classes/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("user_id", user.userId);
    prefs.setString("fname", user.fname);
    prefs.setString("lname", user.lname);
    prefs.setString("email_address", user.emailAddress);
    prefs.setString("mobile_number", user.mobileNumber);
    prefs.setString("date_of_birth", user.dateOfBirth);
    prefs.setString("gender", user.gender);
    prefs.setInt("is_admin", user.isAdmin);
    prefs.setInt("team_id", user.teamId);
    // prefs.setString("token", user.token);
    // prefs.setString("renewalToken", user.renewalToken);

  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("user_id")!;
    String fname = prefs.getString("fname")!;
    String lname = prefs.getString("lname")!;
    String emailAddress = prefs.getString("email_address")!;
    String mobileNumber = prefs.getString("mobile_number")!;
    String dateOfBirth = prefs.getString("date_of_birth")!;
    int isAdmin = prefs.getInt("is_admin")!;
    // String token = prefs.getString("token")!;
    // String renewalToken = prefs.getString("renewalToken")!;
    String gender = prefs.getString("gender")!;
    int teamId = prefs.getInt("team_id")!;

    return User(
      userId: userId,
      fname: fname,
      lname: lname,
      emailAddress: emailAddress,
      mobileNumber: mobileNumber,
      gender: gender,
      isAdmin: isAdmin,
      dateOfBirth: dateOfBirth,
      // token: token,
      // renewalToken: renewalToken
      teamId: teamId
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("user_id");
    prefs.remove("fname");
    prefs.remove("lname");
    prefs.remove("email_address");
    prefs.remove("mobile_number");
    prefs.remove("date_of_birth");
    prefs.remove("gender");
    prefs.remove("is_admin");
    prefs.remove("team_id");
    // prefs.remove("type");
    // prefs.remove("token");
    // prefs.remove("renewalToken");
  }

  

  // Future<String?> getToken(args) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString("token")!;
  //   return token;
  // }
}