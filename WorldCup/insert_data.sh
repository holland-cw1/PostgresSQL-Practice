#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # add all the teams
    QUERY_WINNER=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
    if [[ -z $QUERY_WINNER ]] 
    then 
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
    fi
    QUERY_OPPONENT=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
    if [[ -z $QUERY_OPPONENT ]]
    then 
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    fi

    # add to games
    QUERY_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    QUERY_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $QUERY_WINNER, $QUERY_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi
done

