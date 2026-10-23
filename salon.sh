#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -tAq"

echo "~~~~~ MY SALON ~~~~~"
echo
echo "Welcome to My Salon, how can I help you?"
echo

print_services() {
  $PSQL -c "SELECT service_id || ') ' || name FROM services ORDER BY service_id;"
}

sql_escape() {
  printf "%s" "$1" | sed "s/'/''/g"
}

print_services
read SERVICE_ID_SELECTED

while true; do
  if [[ "$SERVICE_ID_SELECTED" =~ ^[0-9]+$ ]]; then
    SERVICE_NAME=$($PSQL \
      -c "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
  else
    SERVICE_NAME=""
  fi

  if [[ -n "$SERVICE_NAME" ]]; then
    break
  fi

  echo
  echo "I could not find that service. What would you like today?"
  print_services
  read SERVICE_ID_SELECTED
done

echo
echo "What's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_PHONE_SQL=$(sql_escape "$CUSTOMER_PHONE")
CUSTOMER_ID=$($PSQL \
  -c "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE_SQL';")

if [[ -z "$CUSTOMER_ID" ]]; then
  echo
  echo "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  CUSTOMER_NAME_SQL=$(sql_escape "$CUSTOMER_NAME")
  CUSTOMER_ID=$($PSQL \
    -c "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE_SQL', '$CUSTOMER_NAME_SQL') RETURNING customer_id;")
else
  CUSTOMER_NAME=$($PSQL \
    -c "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID;")
fi

echo
echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

SERVICE_TIME_SQL=$(sql_escape "$SERVICE_TIME")
$PSQL \
  -c "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME_SQL');" >/dev/null

echo
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
