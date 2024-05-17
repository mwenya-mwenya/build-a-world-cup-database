#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#PSQL login variable

#Trancates all tables
echo $($PSQL "TRUNCATE teams,games")
#Loops through CSV file
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
  #Checks and skips title of CSV
  if [[ $YEAR != year ]]; then
    #Inserts winner team from CSV to teams table
    INSERT_TEAMS_WINNERS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER') ON CONFLICT (name) DO NOTHING")
    #Inserts opponent team from CSV to teams table
    INSERT_TEAMS_OPPONENTS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ON CONFLICT (name) DO NOTHING")
    #Logs in the terminal what winner team has been updated in the teams table
    if [[ $INSERT_TEAMS_WINNERS == 'INSERT 0 1' ]]; then
      echo Inserted into teams $WINNER
    fi
    #Logs in the terminal what opponent team has been updated in the teams table
    if [[ $INSERT_TEAMS_OPPONENTS == 'INSERT 0 1' ]]; then
      echo Inserted into teams $OPPONENT
    fi
    #get team id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    #insert game results
    INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_TEAM_ID,$OPPONENT_TEAM_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    if [[ $INSERT_GAMES == 'INSERT 0 1' ]]; then
    echo Inserted in teams Year: $YEAR Round: $ROUND Winner: $WINNER Opponent: $OPPONENT Winner goals: $WINNER_GOALS Opponent goals: $OPPONENT_GOALS
    fi
  fi
  
done
