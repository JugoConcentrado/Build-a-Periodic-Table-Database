#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only --no-align -c"

RETURN_STRING() {
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  GET_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$GET_TYPE_ID")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
# get atomic number
  if ! [[ $1  =~ ^[0-9]+$ ]]
  then
    string=$1
    STRING_LENGTH=${#string}
    if [[ $STRING_LENGTH -gt 2 ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
    else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    fi
  else
    ATOMIC_NUMBER=$1
  fi
  MAX_NUMBER=$($PSQL "SELECT MAX(atomic_number) FROM elements")
  if [[ -z "$ATOMIC_NUMBER" ]] || [[ $ATOMIC_NUMBER -gt $MAX_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    RETURN_STRING
  fi
fi
