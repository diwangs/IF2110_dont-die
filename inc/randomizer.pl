cloneZombie(X, Y) :- health(X, Z), assertz(health(Y, Z)), assertz(enemy(Y)), damage(X, A), assertz(damage(Y, A)),
	moveChance(X, B), assertz(moveChance(Y, B)), allName(X, C), assertz(allName(Y, C)).

randomLocation(N, X, Y) :- randomize, random(1, X, A), randomize, random(1, Y, O), \+ location(_, A, O), assertz(location(N, A, O)), !.
randomLocation(N, X, Y) :- randomLocation(N, X, Y).

randomEnemy(_, 0, _, _) :- !.
randomEnemy(Zombie, Count, X, Y) :- Name = Zombie + Count, cloneZombie(Zombie, Name), randomLocation(Name, X, Y) , C is (Count-1), 
	randomEnemy(Zombie, C, X, Y).

randomRadar(0, _ ,_) :- !.
randomRadar(Count, X, Y) :- Name = radar +Count, randomLocation(Name, X, Y), assertz(allName(Name, 'Radar')), C is Count-1, randomRadar(C, X, Y).

randomLake(_, 0, _, _) :- !.
randomLake(Lake, Count, X, Y) :- Name = Lake + Count, assertz(lake(Name)), randomLocation(Name, X, Y), 
	assertz(allName(Name, 'Lake')), C is (Count-1), randomLake(Lake, C, X, Y).

randomTree(_, 0, _, _) :- !.
randomTree(Tree, Count, X, Y) :- Name = Tree + Count, assertz(tree(Name)), randomLocation(Name, X, Y), 
	assertz(allName(Name, 'Tree')), C is (Count-1), randomTree(Tree, C, X, Y).

retractEnemy :- \+ enemy(_), !.
retractEnemy :- enemy(X), retract(enemy(X)), retractEnemy.

retractLocation :- \+ location(_,_,_), assertz(location(self, 1,1)), !.
retractLocation :- location(X, _, _), retract(location(X,_,_)), retractLocation.

cloneConsumable(X, Y) :- heal(X, Health, Hunger, Thirst), assertz(heal(Y, Health, Hunger, Thirst)), allName(X, N), assertz(allName(Y, N)),
	assertz(consumable(Y)), interact(X, I), assertz(interact(Y, I)).

cloneWeapon(X, Y) :- damage(X, D), assertz(damage(Y, D)), allName(X, N), assertz(weapon(Y)), assertz(allName(Y, N)),
	durability(X, DR), assertz(durability(Y, DR)), interact(X, I), assertz(interact(Y, I)).

randomConsumable(_,0,_,_) :- !.
randomConsumable(Consumable, Count, X, Y) :- Name = Consumable+Count, cloneConsumable(Consumable, Name), randomLocation(Name, X, Y),
	C is (Count-1), randomConsumable(Consumable, C, X, Y).

randomWeapon(_,0,_,_) :- !.
randomWeapon(Weapon, Count, X, Y) :- Name = Weapon+Count, cloneWeapon(Weapon, Name), randomLocation(Name, X, Y),
	C is (Count-1), randomWeapon(Weapon, C, X, Y).

randomObject(Total, A, O) :- randomize, random(1, Total, X), randomConsumable(emptyBottle, X, A, O),
	randomize, random(1, Total, W), randomConsumable(meat, W, A, O), 
	randomize, random(1, Total, F), randomConsumable(corn, F, A, O),
	randomize, random(1, Total, B), randomConsumable(sausage, B, A,O),
	randomize, random(0, 2, C), randomWeapon(sword, C, A,O), randomWeapon(sword, 1, A,O),
	randomize, random(0, 2, D), randomWeapon(axe, D, A, O),
	randomize, random(0, 2, E), randomWeapon(chainsaw, E, A, O),
	randomConsumable(medicine, 5, A, O), randomRadar(5, A, O).

randomEasy :- randomize, random(4, 10, Z), retract(mapSize(_,_)), retractLocation, retractEnemy, Y is 20, 
	assertz(mapSize(Y, Y)), randomEnemy(regularZombie, Z, Y, Y),
	randomObject(Z, Y, Y).

randomMedium :- randomize, random(6, 15, Z), randomize, random(3, 10, E), retractLocation,
	retract(mapSize(_,_)), retractEnemy, Y is (Z+E)*2, assertz(mapSize(Y, Y)), 
	randomEnemy(regularZombie, Z, Y, Y), randomEnemy(fastZombie, E, Y,Y),
	randomObject(Z, Y, Y).

randomHard :- randomize, randomize, random(6, 15, Z), randomize, random(3, 15, E), randomize, random(3, 15, D), retractLocation,
	retract(mapSize(_,_)), retractEnemy, Y is (Z+E+D+5), assertz(mapSize(Y, Y)), 
	randomEnemy(regularZombie, Z, Y, Y), randomEnemy(fastZombie, E, Y,Y), randomEnemy(tankZombie, D, Y,Y),
	randomObject(Z, Y, Y), randomLake(lake, 10, Y, Y), randomTree(tree, 10, Y, Y).

allEnemy(X) :- findall(Y, enemy(Y), X).

chase(E) :- moveChance(E, X), Z is X*10, randomize, random(0,11, Y), Y > Z, !.
chase(E) :- location(self, TX, _), location(E, X, Y), X < TX, retract(location(E, X, Y)),
	Z is X +1, assertz(location(E,Z, Y)), !.
chase(E) :- location(self, TX, _), location(E, X, Y), X > TX, retract(location(E, X, Y)),
	Z is X -1, assertz(location(E,Z, Y)), !.
chase(E) :- location(self, _, TY), location(E, X, Y), Y < TY, retract(location(E, X, Y)),
	Z is Y +1, assertz(location(E,X, Z)), !.
chase(E) :- location(self, _, TY), location(E, X, Y), Y > TY, retract(location(E, X, Y)),
	Z is Y -1, assertz(location(E, X, Z)), !.

randomMove([]) :- !.
randomMove([H | T]) :- location(H, X, Y), location(self, A, O), 
	B is X -2, C is X + 2, D is Y-2, E is Y+2, A >= B, A =< C, O >= D, O =< E, chase(H), randomMove(T), !.
randomMove([H | T]) :- moveChance(H, MC), E is MC * 10, randomize, random(0, 10, Z), Z > E, randomMove(T), !.
randomMove([H | T]) :- location(H, X,Y), mapSize(MX, MY), A is X-1, B is X+2, C is Y-1, D is Y+2,
	randomize, random(A, B, TX), randomize, random(C,D, TY), TX =< MX, TX > 0, TY =< MY, TY > 0, retract(location(H, X, Y)),
	assertz(location(H, TX, TY)), randomMove(T), !.

randomMove([H | T]) :- randomMove([H | T]).

randomizeEnemy :- allEnemy(X), randomMove(X).

randomAttack(_) :- prev(attack), !.
randomAttack([]) :- !.
randomAttack([H | T]) :- location(self, X, Y), \+ location(H, X, Y), randomAttack(T), !.
randomAttack([H | T]) :- retract(health(self, HE)), damage(H, D), CH is HE-D, assertz(health(self, CH)),
	write('A zombie attack you from behind! You lose '), write(D), write(' health!!'), nl, randomAttack(T), !.

attackEnemy :- allEnemy(X), randomAttack(X).
