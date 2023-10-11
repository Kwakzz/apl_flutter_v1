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
    
    // only save player_id if it is not null
    if (user.playerId != null) {
      prefs.setInt("player_id", user.playerId!);
    }

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
    int playerId;
    try {
      playerId = prefs.getInt("player_id")!;
    } catch (e) {
      playerId = 0;
    }

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
      teamId: teamId,
      playerId: playerId
    );

  }

  Future<Map<String, dynamic>> removeUser() async {

    // return true if user is removed
    // return false if user is not removed
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isRemoved = await prefs.clear();
    return {
      "isRemoved": isRemoved,
      "message": "You've been logged out successfully"
    };

  }

  

  // Future<String?> getToken(args) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString("token")!;
  //   return token;
  // }
}