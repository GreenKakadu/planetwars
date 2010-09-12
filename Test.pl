#!/usr/bin/perl

use feature ':5.10';
use warnings;
use strict;
use PlanetWars;
use Test::More;


say "Testing Fleet-object";
my $fleet = new Fleet(1, 2, 3, 4, 5, 6);

is($fleet->Owner(),1,'Owner');
is($fleet->NumShips(),2,'NumShips');
is($fleet->SourcePlanet(),3,'SourcePlanet');
is($fleet->DestinationPlanet(),4,'DestinationPlanet');
is($fleet->TotalTripLenght(),5,'TotalTripLenght');
is($fleet->TurnsRemaining(),6,'TurnsRemaining');

say "Testing Planet-object";
my $planet = new Planet(1, 2, 3, 4, 5, 6);

is($planet->PlanetID(),1,'PlanetID');
is($planet->Owner(),2,'Owner');
is($planet->NumShips(),3,'NumShips');
is($planet->GrowthRate(),4,'GrowthRate');
is($planet->X(),5,'X');
is($planet->Y(),6,'Y');

$planet->Owner(7);
is($planet->Owner(),7,'New Owner');

$planet->AddShips(8);
is($planet->NumShips(),11,'AddShips');
$planet->RemoveShips(9);
is($planet->NumShips(),2,'RemoveShips');

say "Testing PlanetWars-object";
my $PlanetWars = new PlanetWars();

#P 0    0    1 34 2  # Player one's home planet.
#P 7    9    2 34 2  # Player two's home planet.
#P 3.14 2.71 0 15 5  # A neutral planet with real-number coordinates.

#F 1 15 0 1 12 2     # Player one has sent some ships to attack player two.
#F 2 28 1 2  8 4     # Player two has sent some ships to take over the neutral planet.
#go

$



done_testing();
