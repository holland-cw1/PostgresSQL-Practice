#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only --no-align -c"

MAIN_MENU(){

  echo -e "\n=====Main Menu=====\n"
  echo -e "1) Nail Polish\n2) Perm\n3) Manicure\n"

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in 
    1) SCHEDULER 1 ;;
    2) SCHEDULER 2 ;;
    3) SCHEDULER 3 ;;
    *) MAIN_MENU ;;
  esac
}

SCHEDULER(){
  SERVICE_ID_SELECTED=$1
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE  

  CUSTOMER_QUERY=$($PSQL "SELECT * FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_QUERY ]]
  then
    # Doesn't exist
    echo -e "\nPlease enter your name:"
    read CUSTOMER_NAME
    CUSTOMER_INSERT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nPlease enter your requested time:"
  read SERVICE_TIME

  APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo "I have put you down for a $SERVICE at $SERVICE_TIME, $NAME."


  
}

MAIN_MENU 