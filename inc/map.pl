writeCell(X, Y) :- location(self, X, Y), write('|P|'), !.
writeCell(X, Y) :- location(S, X, Y), enemy(S), write('|Z|'),!.
writeCell(X, Y) :- location(S, X, Y), allName(S, 'Medicine') , write('|M|'),!.
writeCell(X, Y) :- location(S, X, Y), allName(S, 'Radar') , write('|R|'),!.
writeCell(X, Y) :- location(S,X,Y), consumable(S), write('|C|'),!.
writeCell(X, Y) :- location(S, X, Y), weapon(S), write('|W|'),!.
writeCell(X, Y) :- location(S, X, Y), lake(S), write('|L|'),!.
writeCell(X, Y) :- location(S, X, Y), tree(S), write('|T|'),!.
writeCell(_, _) :- write('|_|'), !.

writeMap(_, Y, _, MY) :- Y > MY, !.
writeMap(X, Y, MX, MY) :- X > MX, Z is Y+1, nl, location(self, A, _), writeMap(A, Z, MX, MY).
writeMap(X, Y, MX, MY) :- writeCell(X, Y), Z is X+1, writeMap(Z, Y, MX, MY).

map :- game(0), write('You haven\'t started the game'), !.
map :- inventory(L), \+ inInvent(radar, L), write('You don\'t have radar in your inventory'), !.
map :- location(self, X, Y), mapSize(MX, MY), Z is X + 19, W is Y +9, W =< MY, Z =< MX,
		writeMap(X,Y,Z,W), !.

map :- location(self, X, Y), mapSize(MX, MY), Z is X + 19, W is Y +9, W > MY, Z > MX,
		writeMap(X,Y,MX,MY), !.

map :- location(self, X, Y), mapSize(_, MY), Z is X + 19, W is Y +9, W > MY,
		writeMap(X,Y,Z,MY), !.

map :- location(self, X, Y), mapSize(MX, _), W is Y +9,
		writeMap(X,Y,MX,W), !.

cheatmap :- location(self, X, Y), mapSize(MX, MY), Z is X + 19, W is Y +9, W =< MY, Z =< MX,
		writeMap(X,Y,Z,W), !.

cheatmap :- location(self, X, Y), mapSize(MX, MY), Z is X + 19, W is Y +9, W > MY, Z > MX,
		writeMap(X,Y,MX,MY), !.

cheatmap :- location(self, X, Y), mapSize(_, MY), Z is X + 19, W is Y +9, W > MY,
		writeMap(X,Y,Z,MY), !.

cheatmap :- location(self, X, Y), mapSize(MX, _), W is Y +9,
		writeMap(X,Y,MX,W), !.
