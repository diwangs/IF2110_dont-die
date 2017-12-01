title :-
    write('   ('), nl,                                      
    write('   )\\ )        (      )    ('), nl,            
    write('  (()/(        )\\  ( /(    )\\ ) (    ('), nl,    
    write('   /(_))  (   ((_) )\\())  (()/( )\\  ))\\ '), nl,   
    write('  (_))_   )\\  )\\ )(_))/    ((_)|(_)/((_)'), nl,  
    write('   |   \\ ((_)_(_/(| |_     _| | (_|_))'), nl,    
    write('   | |) / _ \\ \' \\))  _|  / _` | | / -_)'), nl,   
    write('   |___/\\___/_||_| \\__|  \\__,_| |_\\___|'), nl, nl.     

help :-
    nl, write('<--- Game management --->'), nl,
    write('start\t\t: Start the game'), nl,
    write('save(filename)\t: Save the current game state'), nl,
    write('cont(filename)\t: Continue a saved game'), nl,
    write('quit\t\t: Go back to reality'), nl,
    nl, write('<--- Ingame commands --->'), nl,
    write('status\t\t: Displays your health, weapon, hunger, thirst, and inventory'), nl,
    write('n/e/s/w\t\t: Move according to compass\' direction'), nl,
    write('movetimes(d, X)\t: Move X times to d (n/s/e/w)'), nl,
    write('look\t\t: Displays information about your surroundings'), nl,
    write('map\t\t: Look at the map (if you have a radar in your inventory)'), nl,
    write('take(object)\t: Take an object on the ground and put it in your inventory'), nl,
    write('use(object)\t: Use/equip an object in your inventory'), nl,
    write('drop(object)\t: Put an object out of your inventory'), nl,
    write('attack\t\t: Engange an enemy'), nl,
    nl, write('<--- Legend --->'), nl,
    write('L : Lake'), nl,
    write('P : You'), nl,
    write('T : Tree'), nl,
    write('Z : Zombie'), nl,
    write('W : Weapon'), nl,
    write('C : Consumable'), nl,
    write('M : Medicine'), nl,
    write('R : Radar'), nl.


desc :-
    write('You are stranded in the middle of a forest. You don\'t remember who you are.'), nl,
    write('You just know that you are surrounded by lots of undead. '), nl,
    write('Some are fat, some are fast, some are just.. undead. Kill them all. Try not to die.'), nl,
    nl, write('Type \'help\' for help!'), nl, nl.

start :- retract(game(_)), assertz(game(1)), title, desc, randomHard.