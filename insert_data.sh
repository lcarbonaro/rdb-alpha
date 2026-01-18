#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Insert unique teams from games.csv
tail -n +2 games.csv | awk -F',' '{print $3; print $4}' | sort | uniq | while read TEAM; do
  $PSQL "INSERT INTO teams(name) VALUES('$TEAM')"
done

# insert games from games.csv
tail -n +2 games.csv | awk -F',' '{print $1","$2","$3","$4","$5","$6}' | while IFS=',' read YEAR ROUND WIN OPP WIN_GOALS OPP_GOALS; do
  # look up team id for winner  
  WIN_ID=$( $PSQL "select team_id from teams where name='$WIN'" )
  # look up team id for opponent
  OPP_ID=$( $PSQL "select team_id from teams where name='$OPP'" )
  # insert game record
  $PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WIN_ID,$OPP_ID,$WIN_GOALS,$OPP_GOALS)"  
done
