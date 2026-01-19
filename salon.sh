#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~ SALON APPOINTMENT BOOKING ~~\n"

function displayServices() {
  $PSQL "select * from services" | while IFS='|' read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  echo -e "\nPlease enter a service id:"

  read SERVICE_ID_SELECTED
}


displayServices

SERVICE_NAME=$( $PSQL "select name from services where service_id=$SERVICE_ID_SELECTED" )

if [[ -z $SERVICE_NAME ]]
then
  echo -e "\nNot found! Please enter a VALID service id.\n"
  displayServices
else
  #echo $SERVICE_NAME

  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$( $PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE' " )

  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nPlease enter your name:"
    read CUSTOMER_NAME  

    $PSQL "insert into customers (phone,name) values ('$CUSTOMER_PHONE','$CUSTOMER_NAME')"
    CUSTOMER_ID=$( $PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE' " )

  fi

  echo -e "\nPlease enter service time:"
  read SERVICE_TIME

  $PSQL "insert into appointments (customer_id,service_id,time) values ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')"

  CUSTOMER_NAME=$( $PSQL "select name from customers where customer_id=$CUSTOMER_ID" )
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."




fi




