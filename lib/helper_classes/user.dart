class User {
  int userId;
  String fname;
  String lname;
  String emailAddress;
  String mobileNumber;
  String gender;
  String dateOfBirth;
  // String token;
  // String renewalToken;
  int isAdmin;
  int teamId;
  int? playerId;

  User(
    {
      required this.userId, 
      required this.fname, 
      required this.lname,
      required this.emailAddress, 
      required this.mobileNumber, 
      required this.gender, 
      required this.dateOfBirth,
      // required this.token, 
      // required this.renewalToken,
      required this.isAdmin,
      required this.teamId,
      required this.playerId
    }
  );

  /// This method is used to convert the JSON returned from the API into a User object.
  /// The argument is a map of the user's details.
  /// The method returns a User object.
  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['user_id'],
        fname: responseData['fname'],
        lname: responseData['lname'],
        emailAddress: responseData['email_address'],
        mobileNumber: responseData['mobile_number'],
        gender: responseData['gender'],
        dateOfBirth: responseData['date_of_birth'],
        isAdmin: responseData['is_admin'],
        // token: responseData['access_token'],
        // renewalToken: responseData['renewal_token']
        teamId: responseData['team_id'],
        playerId: responseData['player_id']
    );
  }
}