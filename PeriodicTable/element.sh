#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

GET_DATA(){
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")

  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$1")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")

  echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # search atomic number
  if [[ $1 =~ ^[0-9]+$ && ! -z $($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1") ]]
  then
    QUERY=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    GET_DATA $QUERY
  elif [[ ! -z $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'") ]]
  then
    QUERY=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    GET_DATA $QUERY
  elif [[ ! -z $($PSQL "SELECT atomic_number FROM elements WHERE name='$1'") ]]
  then
    QUERY=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
    GET_DATA $QUERY
  else
    echo "I could not find that element in the database."
  fi

fi

