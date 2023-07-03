#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# function to print the formatted string
print_output(){
  if [[ -z "$1" ]]
  then
    echo -e "\nI could not find that element in the database."    
  else
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MP BP <<< "$1"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
  fi
}


# check whether an input has been provided
if [[ $# -eq 0 ]]
then
   echo "Please provide an element as an argument."
else
    ELEMENT=$1

    # common joint table stored in the variable for DRY purposes 
    JOINT_TABLE="SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius
                    FROM elements 
                    INNER JOIN properties USING(atomic_number)
                    INNER JOIN types USING(type_id)"

    # if-else structure is check whether the input is an integer. 
    if [[ $ELEMENT =~ ^[0-9]+$ ]]
    then
        RESULT=$($PSQL "$JOINT_TABLE
                        WHERE atomic_number = $ELEMENT")
        if [[ -z $RESULT ]]; then
            echo -e "\nI could not find that element in the database."
        else
            print_output $RESULT
        fi
    else 
        RESULT=$($PSQL "$JOINT_TABLE
                        WHERE symbol = '$ELEMENT' OR name = '$ELEMENT'")
        if [[ -z $RESULT ]]; then
                echo -e "\nI could not find that element in the database."
        else
            print_output $RESULT
        fi
    fi
fi
