#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=users -t --no-align -c"

echo -e "Enter your username: "
read USERNAME

QUERY_USER=$($PSQL "SELECT * FROM users WHERE username='$USERNAME'")

if [[ -z $QUERY_USER ]]
then
  # new user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER=$($PSQL "INSERT INTO users(username, games_played) VALUES('$USERNAME', 0)")
else
  # exisitng user
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
  BEST_SCORE=$($PSQL "SELECT best_score FROM users WHERE username='$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_SCORE guesses."
fi

RANDOM_NUM=$(( RANDOM % 1000 + 1 )) 
NUM_GUESSES=1


echo "Guess the secret number between 1 and 1000:"
read GUESS

while [[ $GUESS != $RANDOM_NUM ]]
do
  if [[ $GUESS =~ ^[0-9]+$ ]]
  then
    if [[ $GUESS > $RANDOM_NUM ]]
    then 
      echo "It's lower than that, guess again:"
    else
      echo "It's higher than that, guess again:"
    fi
    NUM_GUESSES=$((NUM_GUESSES + 1))
    read GUESS
  else
    echo "That is not an integer, guess again:"
    NUM_GUESSES=$((NUM_GUESSES + 1))
    read GUESS
  fi
done

# update db

GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
GAMES_PLAYED=$((GAMES_PLAYED + 1))

BEST_SCORE=$($PSQL "SELECT best_score FROM users WHERE username='$USERNAME'")
if [[ $NUM_GUESSES < $BEST_SCORE || -z $BEST_SCORE ]]
then 
  BEST_SCORE=$NUM_GUESSES
fi

UPDATE_USER_GAMES=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE username='$USERNAME'")
UPDATE_USER_SCORE=$($PSQL "UPDATE users SET best_score=$BEST_SCORE WHERE username='$USERNAME'")


echo You guessed it in  $NUM_GUESSES tries. The secret number was  $RANDOM_NUM. Nice job!

