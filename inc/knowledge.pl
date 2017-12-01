:- dynamic(health/2).
:- dynamic(enemy/1).
:- dynamic(damage/2).
:- dynamic(moveChance/2).
:- dynamic(location/3).
:- dynamic(mapSize/2).
:- dynamic(object/1).
:- dynamic(allName/2).
:- dynamic(consumable/1).
:- dynamic(weapon/1).
:- dynamic(heal/4).
:- dynamic(durability/2).
:- dynamic(thirst/1).
:- dynamic(hunger/1).
:- dynamic(game/1).
:- dynamic(inventory/1).
:- dynamic(prev/1).
:- dynamic(equipment/1).
:- dynamic(interact/2).
:- dynamic(lake/1).
:- dynamic(tree/1).

prev(1).
game(0).

template(regularZombie).
template(fastZombie).
template(tankZombie).
template(emptyBottle).
template(waterBottle).
template(meat).
template(corn).
template(sausage).
template(soup).
template(sword).
template(axe).
template(chainsaw).
template(medicine).
template(radar).

health(regularZombie, 10).
health(fastZombie, 5).
health(tankZombie, 20).
health(self, 100).
hunger(self, 100).
thirst(self, 100).

damage(regularZombie, 5).
damage(fastZombie, 3).
damage(tankZombie, 10).
damage(self, 1).
damage(hand, 0).

damage(sword, 5).
damage(axe, 10).
damage(chainsaw, 15).
damage(hand, 0).

durability(sword, 10).
durability(axe, 10).
durability(chainsaw, 20).
durability(hand, 10).

moveChance(regularZombie, 0.5).
moveChance(fastZombie, 0.7).
moveChance(tankZombie, 0.3).
moveChance(self, 1).

heal(emptyBottle, 0, 0, 0).
heal(waterBottle, 5, 1, 10).
heal(meat, 20, 20, 1).
heal(corn, 10, 10, 1).
heal(sausage, 15, 15, 1).
heal(medicine, 30, 0, 0).

lake(lake).
tree(tree).
equipment(hand).
mapSize(1,1).

allName(regularZombie, 'Zombie').
allName(fastZombie, 'Sprinter Zombie').
allName(tankZombie, 'Heavy Weight Zombie').
allName(emptyBottle, 'Empty Water Bottle').
allName(waterBottle, 'Water Bottle').
allName(meat, 'Meat').
allName(corn, 'Corn').
allName(sausage, 'Sausage').
allName(sword, 'Sword').
allName(axe, 'Axe').
allName(chainsaw, 'Chainsaw').
allName(hand, 'hand').
allName(lake, 'Lake').
allName(tree, 'Tree').
allName(medicine, 'Medicine').
allName(radar, 'Radar').

interact(emptyBottle, 'You fill the empty bottle with water').
interact(waterBottle, 'You drink the water. The bottle is empty now').
interact(meat, 'You eat the raw meat').
interact(corn, 'You eat the corn').
interact(sausage, 'You eat the sausage').
interact(sword, 'You hold the sword in your hands. You look quite cool.').
interact(axe, 'You hold the axe and look like a savage.').
interact(chainsaw, 'You are invincible with the chainsaw.').
interact(medicine, 'You drank some medicine. Hopefully it\'s not a poison').