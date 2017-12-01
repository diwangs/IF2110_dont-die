location(self, 1, 1).
thirst(100).
hunger(100).
inventory([]).

dead :- retractall(location), retractall(enemy), retractall(consumable), retractall(weapon).

isDead :- \+ enemy(_), write('You have slain all the zombies. You win'), nl, nl,nl,nl,nl,nl, write('But you died of loneliness'), nl, 
	retract(game(_)), assertz(game(0)), !. 
isDead :- thirst(0), retract(game(_)), assertz(game(0)), write('You are dead of thirst. Lol'), nl, !.
isDead :- hunger(0), retract(game(_)), assertz(game(0)), write('You are dead of hunger. Lol'), nl, !.
isDead :- location(self, X, Y), location(Tree, X, Y), tree(Tree), hitTree, !.
isDead :- health(self, 0), retract(game(_)), assertz(game(0)), write('You are dead.'), nl, !.
isDead :- inLake, game(0), !.
isDead :- look, !.

editThirst(X) :- retract(thirst(Y)), Z is Y-X, assertz(thirst(Z)).
editHunger(X) :- retract(hunger(Y)), Z is Y-X, assertz(hunger(Z)).

drown :- retract(game(_)), assertz(game(0)), write('You drowned. Game over.'), nl, dead.

hitTree :- retract(game(_)), assertz(game(0)), write('You hit a tree and split your head open. Game over.'), nl, dead.

updatePerAction(X) :- retractall(prev), assertz(prev(X)), randomizeEnemy, attackEnemy, editThirst(1), editHunger(1), isDead.

updateLoc(X, Y) :- mapSize(MX, MY), X =< MX, X > 0, Y >0, Y =< MY,
		retract(location(self, _, _)), assertz(location(self, X, Y)), !.
updateLoc(_,_) :- write('There is a very tall fence. You can\'t go there.'), randomizeEnemy, nl. 

n :- game(1), location(self, X, Y), Z is Y-1, updateLoc(X, Z), updatePerAction(n), !.
n :- game(0), write('You haven\'t start the game').
s :- game(1), location(self, X, Y), Z is Y+1, updateLoc(X,Z), updatePerAction(s),!.
s :- game(0), write('You haven\'t start the game').
w :- game(1), location(self, X, Y), Z is X-1, updateLoc(Z, Y), updatePerAction(w), !.
w :- game(0), write('You haven\'t start the game').
e :- game(1), location(self, X, Y), Z is X+1, updateLoc(Z, Y), updatePerAction(e), !.
e :- game(0), write('You haven\'t start the game').

move([]) :- !.
move([H | T]) :- call(H), move(T).

movetimes(_, 0) :- !.
movetimes(X, Times) :- call(X), Z is Times-1, movetimes(X, Z).

look :- game(0), write('You haven\'t started the game'), !.
look :- look1, look2, look3, look4, look5, look6. 

look1 :- game(1), location(self, X, Y), N is Y+1,
	location(A, X, N), write('There is '), allName(A, _), write(A), write(' on the south side'), nl, !.
look1 :- write('There is nothing on the south side'), nl, !.
look2 :- game(1), location(self, X, Y), S is Y-1,
	location(A, X, S), write('There is '), allName(A, _), write(A), write(' on the north side'), nl, !.
look2 :- write('There is nothing on the north side'), nl, !.
look3 :- game(1), location(self, X, Y), W is X-1,
	location(A, W, Y), write('There is '), allName(A, _), write(A), write(' on the west side'), nl, !.
look3 :- write('There is nothing on the west side'),nl, !.
look4 :- game(1), location(self, X, Y), E is X+1,
	location(A, E, Y), write('There is '), allName(A, _), write(A), write(' on the east side'),  nl, !.
look4 :- write('There is nothing on the east side'), nl, !.
look5 :- game(1), location(self, X, Y), location(A, X, Y), A \== self, \+ enemy(A), allName(A, _), write('There is '),
	write(A), write(' on the ground'), nl, !.
look5 :- write('There is nothing on the ground'), nl, !.
look6 :- game(1), location(self, X, Y), location(A, X, Y), A \== self, enemy(A), allName(A, _), write('THERE IS '),
	write(A), write(' BEHIND YOU!'), nl, !.
look6 :- !.

status :- game(0), write('You haven\'t started the game'), fail, !.
status :- game(1), thirst(T), hunger(H), health(self, HE), inventory(L), equipment(EQ),
	write('Health : '), write(HE), nl,
	write('Thirst : '), write(T), nl,
	write('Hunger : '), write(H), nl,
	write('Equipment : '), write(EQ), nl,
	write('Inventory : '), write(L), nl.

isInventFull :- inventory(L), length(L, X), X == 6.

take(_) :- \+ game(1), write('You haven\'t started the game'), !.
take(_):- isInventFull, write('Your inventory is full'), !.
take(A) :- location(self, X, Y), location(A, X, Y), allName(A, 'Radar'), write('You take a radar'), nl, 
	retract(location(A,X,Y)), retract(inventory(L)), assertz(inventory([A | L])), !.
take(A) :- location(self, X, Y), location(A, X, Y), weapon(A), write('You take a '), allName(A, N), write(N), nl, 
	retract(location(A,X,Y)), retract(inventory(L)), assertz(inventory([A | L])), !.
take(A) :- location(self, X, Y), location(A, X, Y), consumable(A), write('You take a '), allName(A, N), write(N), nl,
	retract(location(A,X,Y)), retract(inventory(L)), assertz(inventory([A | L])), !.

dropInvent(_, [], _) :- !.
dropInvent(X, [H | T], T) :- allName(X, Z), allName(H, Z), !.
dropInvent(X, [H | T], [H | TX]) :- dropInvent(X, T, TX).

drop(_) :- \+ game(1), write('You haven\'t started the game'), !.
drop(X) :- game(1), inventory(I), inInvent(X, I), retract(inventory(L)), dropInvent(X, L, Y), assertz(inventory(Y)), location(self, A, O), assertz(location(X, A,O)),
	write('You dropped a '), write(X), nl.

useConsumable(X) :- heal(X, HHE, HU, TH), retract(thirst(T)), retract(hunger(H)), retract(health(self, HE)),
	CHE is HE + HHE, CHU is H + HU, CTH is TH + T, assertz(thirst(CTH)), assertz(health(self, CHE)),
	assertz(hunger(CHU)).

notMoreThan100 :- health(self, HE), HE > 100, retract(health(self, _)), assertz(health(self, 100)).
notMoreThan100 :- thirst(T), T > 100, retract(thirst(T)), assertz(thirst(100)).
notMoreThan100 :- hunger(H), H > 100, retract(hunger(H)), assertz(hunger(100)).
notMoreThan100 :- !.

inInvent(_, []) :- fail, !.
inInvent(X, [H | _]) :- allName(X, Z), allName(H, Z), !.
inInvent(X, [_ | T]) :- inInvent(X, T).

inLake :- location(self, X, Y), lake(Z), location(Z, X, Y), inventory(L), \+ inInvent(emptyBottle, L), drown, !.
inLake :- location(self, X, Y), lake(Z), location(Z, X, Y), retract(inventory(L)), dropInvent(emptyBottle, L, W), random(1, 100, A), N = waterBottle+A,
	cloneConsumable(waterBottle, N), assertz(inventory([N | W])), !.
inLake :- !.

dropHand :- retract(inventory(L)), dropInvent(hand, L, Y), assertz(inventory(Y)).

use(_) :- \+ game(1), write('You haven\'t started the game'), !.
use(X) :- weapon(X), retract(equipment(W)), retract(inventory(L)),
	dropInvent(X, L, Y), assertz(inventory([W |Y])), dropHand, assertz(equipment(X)), interact(X, Z), write(Z), !.
use(X) :- allName(X, 'Empty Water Bottle'), write('It\'s empty...'), !.
use(X) :- allName(X, 'Water Bottle'), interact(X, Z), write(Z), retract(inventory(L)), dropInvent(X, L, W), useConsumable(X),
	random(1, 100, A), N = emptyBottle+A, cloneConsumable(emptyBottle, N), assertz(inventory([N|W])), !.
use(X) :- consumable(X), inventory(I), inInvent(X, I), retract(inventory(L)), dropInvent(X, L, Y), assertz(inventory(Y)), useConsumable(X), notMoreThan100, interact(X, Z), write(Z), !.

attackR(X) :- game(1), enemy(X), location(X, A, O), location(self, A, O),
	retract(health(X, H)), retract(health(self, HS)),
	damage(self, DS), equipment(EQ), damage(EQ, DQ), D is DQ+DS, damage(X, DE), SCH is HS-DE, ECH is H-D,
	assertz(health(X, ECH)), assertz(health(self, SCH)),
	write('You attack the '), write(X), write(' with a '), allName(EQ, NQ), write(NQ), nl,
	write('You damaged the enemy by '), write(D), write(' points'), nl,
	write('The '), write(X), write(' damaged you by '), write(DE), write(' points'), nl,
	SCH > 0,
	write('Your health is '), write(SCH), nl,
	ECH > 0,
	write('The '), write(X), write(' health is '), write(ECH), nl, 
	attackR(X), !.

attackR(X) :- retract(health(X, H)), H =< 0, assertz(health(X, 0)), retract(location(X, _, _)), 
	write('The '), write(X), write(' is dead!'), nl, 
	retract(enemy(X)), !.

attackR(_) :- health(self, SCH), SCH =< 0, write('You are dead. Better be ready next time.'), nl, retract(game(_)), assertz(game(0)).

attack :- \+ game(1), write('You haven\'t started the game'), !.
attack :- enemy(E), location(self, X, Y), location(E, X, Y), health(E, H), H == 0, !.
attack :- enemy(E), location(self, X, Y), location(E, X, Y), attackR(E), !.

amock :- \+ enemy(_), isDead, !.
amock :- retract(health(self, _)), assertz(health(self, 999999)), enemy(X),
	retract(location(self, _, _)), location(X, A, O), assertz(location(self, A, O)),
	attack, amock.

quit :- retract(game(_)), assertz(game(0)), halt.