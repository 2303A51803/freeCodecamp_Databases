#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")

if [[ -n $USER_ID ]]; then
  USER_STATS=$($PSQL "SELECT games_played, best_game FROM users WHERE user_id = $USER_ID;")
  IFS='|' read -r GAMES_PLAYED BEST_GAME <<< "$USER_STATS"
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
else
  $PSQL "INSERT INTO users(username) VALUES('$USERNAME');" > /dev/null
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
fi

SECRET_NUMBER=$((RANDOM % 1000 + 1))
NUMBER_OF_GUESSES=0
echo "Guess the secret number between 1 and 1000:"

while true; do
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))
  if (( GUESS > SECRET_NUMBER )); then
    echo "It's lower than that, guess again:"
  elif (( GUESS < SECRET_NUMBER )); then
    echo "It's higher than that, guess again:"
  else
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    break
  fi
done

if [[ -n $USER_ID ]]; then
  $PSQL "UPDATE users SET games_played = games_played + 1, best_game = CASE WHEN best_game IS NULL OR $NUMBER_OF_GUESSES < best_game THEN $NUMBER_OF_GUESSES ELSE best_game END WHERE user_id = $USER_ID;" > /dev/null
  $PSQL "INSERT INTO games(user_id, guesses, secret_number) VALUES($USER_ID, $NUMBER_OF_GUESSES, $SECRET_NUMBER);" > /dev/null
fi