#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams,games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    
    WINNER_ID=$($PSQL "SELECT team_id from teams where name ='$WINNER'")
    
    if [[ -z $WINNER_ID ]]
    then
      echo $($PSQL "INSERT into teams(name) VALUES ('$WINNER') ")
      WINNER_ID=$($PSQL "SELECT team_id from teams where name ='$WINNER'")
    fi  

    OPPONENT_ID=$($PSQL "SELECT team_id from teams where name ='$OPPONENT'")
    
    if [[ -z $OPPONENT_ID ]]
    then
      echo $($PSQL "INSERT INTO teams(name) values ('$OPPONENT')")
      OPPONENT_ID=$($PSQL "SELECT team_id from teams where name ='$OPPONENT'")
    fi

    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")  
  fi
done

# INSERT into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values