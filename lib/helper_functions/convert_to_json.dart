import 'dart:convert';

/// This function converts the user's personal details to a JSON string.
/// The JSON string is then sent to the API to register a new user.
/// This function is used when a user is signing up.
String convertPersonalDetailsToJson (
  fname,
  lname,
  emailAddress,
  userPassword,
  gender,
  dateOfBirth,
  mobileNumber
  ) {
    
    return jsonEncode(<String, dynamic>{
      'fname': fname,
      'lname': lname,
      'email_address': emailAddress,
      'user_password': userPassword,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'mobile_number': mobileNumber
    }
    );
}

/// This function converts the user's personal details to a JSON string.
/// The JSON string is then sent to the API to register a new user.
/// This function is used when an admin is adding a user.
String convertNewFanDetailsToJson (
  fname,
  lname,
  emailAddress,
  userPassword,
  gender,
  dateOfBirth,
  mobileNumber,
  teamName,
  isAdmin,
  ) {
    
    return jsonEncode(<String, dynamic>{
      'fname': fname,
      'lname': lname,
      'email_address': emailAddress,
      'user_password': userPassword,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'mobile_number': mobileNumber,
      'team_name': teamName,
      'is_admin': isAdmin,
    }
    );
}

/// This function converts the user's personal details to a JSON string.
/// The JSON string is then sent to the API to register a new user.
/// This function is used when an admin is editing a user.
String convertEditedFanDetailsToJson (
  userId,
  fname,
  lname,
  dateOfBirth,
  mobileNumber,
  teamName,
  isAdmin,
  isActive
  ) {
    
    return jsonEncode(<String, dynamic>{
      'user_id': userId,
      'fname': fname,
      'lname': lname,
      'date_of_birth': dateOfBirth,
      'mobile_number': mobileNumber,
      'team_name': teamName,
      'is_admin': isAdmin,
      'is_active': isActive
    }
    );
}

/// This function converts the players details to a JSON string.
/// The JSON string is then sent to the API to register a new player.
/// This function is used when an admin is adding a player.
/// It doesn't include the player's id.
String convertNewPlayerDetailsToJson (
  fname,
  lname,
  gender,
  dateOfBirth,
  positionName,
  teamName,
  height,
  weight,
  yearGroup,
  isRetired
) {
  return jsonEncode(<String, dynamic>{
      'fname': fname,
      'lname': lname,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'position_name': positionName,
      'team_name': teamName,
      'height': height,
      'weight': weight,
      'year_group': yearGroup,
      'is_retired': isRetired,
    }
    );
}


/// This function converts the player's personal details to a JSON string.
/// The JSON string is then sent to the API to edit a player's profile.
String convertEditedPlayerDetailsToJson (
  playerId,
  fname,
  lname,
  gender,
  dateOfBirth,
  positionName,
  teamName,
  height,
  weight,
  yearGroup,
  isRetired
  ) {
    
    return jsonEncode(<String, dynamic>{
      'player_id': playerId,
      'fname': fname,
      'lname': lname,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'position_name': positionName,
      'team_name': teamName,
      'height': height,
      'weight': weight,
      'year_group': yearGroup,
      'is_retired': isRetired,
    }
    );
}


/// This function converts the players details to a JSON string.
/// The JSON string is then sent to the API to register a new player.
/// This function is used when an admin is adding a player.
/// It doesn't include the player's id.
String convertNewCoachDetailsToJson (
  fname,
  lname,
  gender,
  dateOfBirth,
  teamName,
  yearGroup,
  isRetired
) {
  return jsonEncode(<String, dynamic>{
      'fname': fname,
      'lname': lname,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'team_name': teamName,
      'year_group': yearGroup,
      'is_retired': isRetired,
    }
    );
}

/// This function converts the coach's details to a JSON string.
/// The JSON string is then sent to the API to register an edited coach.
/// This function is used when an admin is adding a coach.
/// It includes the coach's id.
String convertEditedCoachDetailsToJson (
  coachId,
  fname,
  lname,
  gender,
  dateOfBirth,
  teamName,
  yearGroup,
  isRetired
) 
  {
    return jsonEncode(<String, dynamic>{
      'coach_id': coachId,
      'fname': fname,
      'lname': lname,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'team_name': teamName,
      'year_group': yearGroup,
      'is_retired': isRetired,
      }
    );
  }

/// This function converts a team's details to a JSON string.
/// The JSON string is then sent to the API to either add a new team or edit an existing team.
/// This function is used when an admin is adding or editing a team.
String convertTeamDetailsToJson (
  teamName,
  teamNameAbbrev,
) {
  return jsonEncode(<String, dynamic>{
      'team_name': teamName,
      'team_name_abbrev': teamNameAbbrev,
    }
  );
}

/// This function converts a user's sign in details to a JSON string.
String convertSignInDetailsToJson (
  emailAddress,
  userPassword,
) {
  return jsonEncode(<String, dynamic>{
      'email_address': emailAddress,
      'user_password': userPassword,
    }
  );
}

/// This function converts a season's details to a JSON string.
/// The JSON string is then sent to the API to either add a new season or edit an existing season.
/// This function is used when an admin is adding or editing a season.
/// It doesn't include the season's id.
String convertSeasonDetailsToJson (
  seasonName,
  seasonStartDate,
  seasonEndDate,
) {
  return jsonEncode(<String, dynamic>{
      'season_name': seasonName,
      'start_date': seasonStartDate,
      'end_date': seasonEndDate,
    }
  );
}

/// This function converts an edited season to a JSON string.
/// The JSON string is then sent to the API to either add edit an existing season.
String convertEditedSeasonDetailsToJson (
  seasonId,
  seasonName,
  seasonStartDate,
  seasonEndDate,
) {
  return jsonEncode(<String, dynamic>{
      'season_id': seasonId,
      'season_name': seasonName,
      'start_date': seasonStartDate,
      'end_date': seasonEndDate,
    }
  );
}

/// This function creates a json string that is used for everything related to 
/// competitions happening in a season. The only parameters are the season id, competition id and gender.
String seasonCompJson (
  competitionId,
  competitionName,
  seasonId,
  gender
) {
  return jsonEncode(<String, dynamic>{
      'competition_id': competitionId,
      'competition_name': competitionName,
      'season_id': seasonId,
      'gender': gender,
    }
  );
}

/// This function creates a json string of a gameweek's details.
/// The json string is then sent to the API to either add a new gameweek or edit an existing gameweek.
/// The parameters are gameweek number, gameweek date and season id.
String createGameweekJson (
  seasonId,
  gameweekNumber,
  gameweekDate
) {
  return jsonEncode(<String, dynamic>{
      'season_id': seasonId,
      'gameweek_number': gameweekNumber,
      'gameweek_date': gameweekDate,
    }
  );
}

/// This function creates a json string of a gameweek's details.
/// The json string is then sent to the API to edit an existing gameweek.
String editGameweekJson (
  gameweekId,
  seasonId,
  gameweekNumber,
  gameweekDate
) {
  return jsonEncode(<String, dynamic>{
      'gameweek_id': gameweekId,
      'season_id': seasonId,
      'gameweek_number': gameweekNumber,
      'gameweek_date': gameweekDate,
    }
  );
}

/// This function creates a json string of a game's details.
/// The json string is then sent to the API to add a new game.
String createGameJson (
  gameweekId,
  competitionId,
  homeId,
  awayId,
  startTime
) {
  return jsonEncode(<String, dynamic>{
      'gameweek_id': gameweekId,
      'competition_id': competitionId,
      'home_id': homeId,
      'away_id': awayId,
      'start_time': startTime,
    }
  );
}

/// This function creates a json string of a cup game's details.
/// The json string is then sent to the API to add a new cup game.
String createCupGameJson (
  gameweekId,
  competitionId,
  homeId,
  awayId,
  startTime,
  stageId
) {
  return jsonEncode(<String, dynamic>{
      'gameweek_id': gameweekId,
      'competition_id': competitionId,
      'home_id': homeId,
      'away_id': awayId,
      'start_time': startTime,
      'stage_id': stageId,
    }
  );
}

/// This function creates a json string of a game's details.
/// The json string is then sent to the API to edit an existing game.
String editGameJson (
  gameId,
  competitionId,
  homeId,
  awayId,
  startTime
) {
  return jsonEncode(<String, dynamic>{
      'game_id': gameId,
      'competition_id': competitionId,
      'home_id': homeId,
      'away_id': awayId,
      'start_time': startTime,
    }
  );
}

/// This function creates a json string of a starting xi's details.
/// The json string is then sent to the API to either add a new starting xi to a game.
String createStartingXIJson (
  gameId,
  teamId
) {
  return jsonEncode(<String, dynamic>{
      'game_id': gameId,
      'team_id': teamId
    }
  );
}

/// This function creates a json to add a player to a starting xi or remove a player from a starting xi.
String startingXIPlayerJson (
  startingXIId,
  playerId,
  positionId
) {
  return jsonEncode(<String, dynamic>{
      'xi_id': startingXIId,
      'player_id': playerId,
      'position_id': positionId,
    }
  );
}

/// This function creates a goal json to add a goal to a game.
String createGoalJson (
  gameId,
  goalScorerId,
  assistProviderId,
  minuteScored,
  teamId,

) {
  return jsonEncode(<String, dynamic>{
      'game_id': gameId,
      'player_id': goalScorerId,
      'minute_scored': minuteScored,
      'assist_provider_id': assistProviderId,
      'team_id': teamId,
    }
  );
}


/// This function creates a news item json.
String createNewsItemJson (
  title,
  subtitle,
  content,
  timePublished,
  coverPic,
) {
  return jsonEncode(<String, dynamic>{
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'time_published': timePublished,
      'cover_pic': coverPic,
    }
  );
}

String editNewsItemJson (
  newsItemId,
  title,
  subtitle,
  content,
  coverPic
) {
  return jsonEncode(<String, dynamic>{
      'news_item_id': newsItemId,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'cover_pic': coverPic
    }
  );
}

/// This function returns a JSON for adding a table to a season competition.
String createStandingsJson (
  standingsName,
  competitionId,
  seasonId,
) {
  return jsonEncode(<String, dynamic>{
      'standings_name': standingsName,
      'competition_id': competitionId,
      'season_id': seasonId    
    }
  );
}

/// This function returns a JSON for adding a team to a table.
String standingsTeamJson (
  standingsId,
  teamId,
) {
  return jsonEncode(<String, dynamic>{
      'standings_id': standingsId,
      'team_id': teamId,
    }
  );
}

/// This function returns a JSON for updating a team's details in a table. The only parameters are the team id and standings id.
String updateStandingsTeamJson (
  teamId,
  competitionId,
  seasonId
) {
  return jsonEncode(<String, dynamic>{
      'team_id': teamId,
      'competition_id': competitionId,
      'season_id': seasonId
    }
  );
}


/// This function returns a JSON for transferring a player between clubs.
String transferPlayerJson (
  transferredPlayedId,
  prevTeamId,
  newTeamId,
  transferDate,
  transferType
) {
  return jsonEncode(<String, dynamic>{
      'transferred_player_id': transferredPlayedId,
      'prev_team_id': prevTeamId,
      'new_team_id': newTeamId,
      'transfer_date': transferDate,
      'transfer_type': transferType
    }
  );
}


