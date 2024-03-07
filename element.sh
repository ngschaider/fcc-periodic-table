PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
	echo "Please provide an element as an argument."
	exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
	DATA=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, name, symbol, type 
				FROM elements 
				JOIN properties USING(atomic_number) 
				JOIN types USING(type_id) 
				WHERE elements.atomic_number=$1")
else
	DATA=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, name, symbol, type 
				FROM elements 
				JOIN properties USING(atomic_number) 
				JOIN types USING(type_id) 
				WHERE elements.name='$1' OR elements.symbol='$1'")
fi

if [[ -z $DATA ]]
then
	echo "I could not find that element in the database."
	exit
fi

echo $DATA | while IFS=\| read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT NAME SYMBOL TYPE
do
	echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). \
It's a $TYPE, with a mass of $ATOMIC_MASS amu. \
$NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done