save(X) :- game(1), atom_concat(X, '.pl', Z), tell(Z), write(':- dynamic(health/2).\n\
:- dynamic(enemy/1).\n\
:- dynamic(damage/2).\n\
:- dynamic(moveChance/2).\n\
:- dynamic(location/3).\n\
:- dynamic(mapSize/2).\n\
:- dynamic(object/1).\n\
:- dynamic(allName/2).\n\
:- dynamic(consumable/1).\n\
:- dynamic(weapon/1).\n\
:- dynamic(heal/4).\n\
:- dynamic(durability/2).\n\
:- dynamic(thirst/1).\n\
:- dynamic(hunger/1).\n\
:- dynamic(game/1).\n\
:- dynamic(inventory/1).\n\
:- dynamic(prev/1).\n\
:- dynamic(equipment/1).\n\
:- dynamic(interact/2).\n\
:- dynamic(lake/1).\n\
:- dynamic(tree/1).\n'), listing(enemy), listing(location), listing(durability),
	listing(heal), listing(allName), listing(damage), listing(moveChance), listing(durability), listing(hunger),
	listing(thirst), listing(inventory), listing(lake), listing(game), listing(equipment), listing(interact), 
	listing(consumable), listing(mapSize), listing(weapon), listing(prev), listing(health), listing(lake), listing(tree), told.