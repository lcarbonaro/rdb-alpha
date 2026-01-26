#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  #echo "You passed in $1"

  # 1. Check if input is numeric or string
  if [[ "$1" =~ ^[0-9]+$ ]] 
  then     
    EXISTS_NUM=$( $PSQL "select exists(select 1 from elements where atomic_number=$1)")
  else
    EXISTS_STR=$( $PSQL "select exists(select 1 from elements where symbol='$1' or name='$1')")
  fi
  
  if [[ "$EXISTS_NUM" = "t" || "$EXISTS_STR" = "t" ]]
  then
    #echo "Record found!"    

    if [[ "$EXISTS_NUM" = "t"  ]]
    then
      AN=$( $PSQL "select atomic_number from elements where atomic_number=$1" )
    else
      AN=$( $PSQL "select atomic_number from elements where symbol='$1' or name='$1'" )
    fi

    $PSQL "select atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$AN" | while IFS='|' read NUM NAM SYM TYP MAS MELT BOIL
    do 
      echo "The element with atomic number $NUM is $NAM ($SYM). It's a $TYP, with a mass of $MAS amu. $NAM has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
    
  else
    echo "I could not find that element in the database."
  fi

fi