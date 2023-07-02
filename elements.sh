#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

echo -e "\nPlease provide an element as an argument."
read ELEMENT

print_output(){
  RESULT=$1
  
  echo -e "\nThe input is $1"

  if [[ -z "$1" ]]
  then
    echo -e "\nI could not find that element in the database."    
  else
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< "$1"
    
    echo -e "\nIn $1, atomic number is $ATOMIC_NUMBER"

    echo -e "\nThe element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
  fi
}

if [[ $ELEMENT =~ ^[0-9]+$ ]]
then
  RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $ELEMENT")
  echo $RESULT
  print_output $RESULT

else 
  RESULT=$($PSQL "SELECT * FROM elements WHERE symbol = '$ELEMENT' OR name = '$ELEMENT'")
  echo $RESULT
  print_output $RESULT
fi

