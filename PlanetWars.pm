#!/usr/bin/perl

use warnings;
use strict;
use POSIX;

package Fleet;
sub new {
    my $class = shift;    
    my $self = {
        _fleet_id           => shift,
        _owner              => shift,
        _num_ships          => shift,
        _source_planet      => shift,
        _destination_planet => shift,
        _total_trip_length  => shift,
        _turns_remaining    => shift,
    };    
    bless $self, $class;
    return $self;    
}      
sub FleetID {
    my ($self) = @_;
    return $self->{_fleet_id}
}
sub Owner {
    my ($self) = @_;
    return $self->{_owner}
}
sub NumShips {
    my ($self) = @_;
    return $self->{_num_ships}
}
sub SourcePlanet {
    my ($self) = @_;
    return $self->{_source_planet}
}
sub DestinationPlanet {
    my ($self) = @_;
    return $self->{_destination_planet}
}
sub TotalTripLength {
    my ($self) = @_;
    return $self->{_total_trip_length}
}
sub TurnsRemaining {
    my ($self) = @_;
    return $self->{_turns_remaining}
}

package Planet;
sub new {
    my $class = shift;    
    my $self = {
        _planet_id     => shift,
        _X             => shift,
        _Y             => shift,
        _owner         => shift,
        _num_ships     => shift,
        _growth_rate   => shift,

    };    
    bless $self, $class;
    return $self;    
}
sub PlanetID {
    my ($self) = @_;
    return $self->{_planet_id}
}
sub Owner {
    my ($self, $new_owner) = @_;
    if (defined $new_owner) {
        $self->{_owner} = $new_owner;    
    }
    return $self->{_owner}
}
sub NumShips {
    my ($self, $new_num_ships) = @_;
    if (defined $new_num_ships) {
        $self->{_num_ships} = $new_num_ships;
    }
    return $self->{_num_ships}
}
sub GrowthRate {
    my ($self) = @_;
    return $self->{_growth_rate}
}
sub X {
    my ($self) = @_;
    return $self->{_X}
}
sub Y {
    my ($self) = @_;
    return $self->{_Y}
}
sub AddShips {
    my ($self, $amount) = @_;
    $self->{_num_ships} += $amount;
}
sub RemoveShips {
    my ($self, $amount) = @_;
    $self->{_num_ships} -= $amount;
}

package PlanetWars;
sub new {
    my ($class, $gameState) = @_;    
    my $self = {
        _planets => [],
        _fleets  => [],   
    };    
    bless $self, $class;
    $self->ParseGameState($gameState);
    return $self;    
}
sub NumPlanets {
    my ($self) = @_;
    return scalar(@{$self->{_planets}});
}
sub GetPlanet {
    my ($self, $planet_id) = @_;
    foreach (@{$self->{_planets}}) {
        if ($_->PlanetID() == $planet_id) {
            return $_;
        }
    }
    die('planet doesnt exist');
}
sub NumFleets {
    my ($self) = @_;
    return scalar(@{$self->{_fleets}});
}
sub GetFleet {
    my ($self, $fleet_id) = @_;
    foreach (@{$self->{_fleets}}) {
        if ($_->FleetID() == $fleet_id) {
            return $_;
        }
    }
    die('fleet doesnt exist');
}
sub Planets {
    my ($self) = @_;
    return @{$self->{_planets}};
}
sub MyPlanets {
    my ($self) = @_;
    my @planets;
    foreach (@{$self->{_planets}}) {
        if ($_->Owner() == 1) {
            push(@planets,$_);
        }
    }
    return @planets;
}
sub NeutralPlanets {
    my ($self) = @_;
    my @planets;
    foreach (@{$self->{_planets}}) {
        if ($_->Owner() == 0) {
            push(@planets,$_);
        }
    }
    return @planets;
}
sub EnemyPlanets {
    my ($self) = @_;
    my @planets;
    foreach (@{$self->{_planets}}) {
        if (($_->Owner() > 1) ) {
            push(@planets,$_);
        }
    }
    return @planets;
}
sub NotMyPlanets {
    my ($self) = @_;
    my @planets;
    foreach (@{$self->{_planets}}) {
        if ($_->Owner() != 1) {
            push(@planets,$_);
        }
    }
    return @planets;
}
sub Fleets {
    my ($self) = @_;
    return @{$self->{_fleets}};
}
sub MyFleets {
    my ($self) = @_;
    my @fleets;
    foreach (@{$self->{_fleets}}) {
        if ($_->Owner() == 1) {
            push(@fleets,$_);
        }
    }
    return @fleets;
}
sub EnemyFleets {
    my ($self) = @_;
    my @fleets;
    foreach (@{$self->{_fleets}}) {
        if (($_->Owner() > 1) ) {
            push(@fleets,$_);
        }
    }
    return @fleets;
}
sub Distance {
    my ($self, $source_planet_id, $destination_planet_id) = @_;
    my $source_planet = $self->GetPlanet($source_planet_id);
    my $destination_planet = $self->GetPlanet($destination_planet_id);
    my $dx = $source_planet->X() - $destination_planet->X();
    my $dy = $source_planet->Y() - $destination_planet->Y();
    return abs(&POSIX::ceil(sqrt($dx * $dx + $dy * $dy)));
}
sub IssueOrder {
    my ($self, $source_planet, $destination_planet, $num_ships) = @_;
    print "$source_planet $destination_planet $num_ships\n";
}
sub IsAlive {
    my ($self, $player_id) = @_;
    foreach (@{$self->{_planets}}) {
        if ($_->Owner() == $player_id) {
            return 1;
        }
    }
    foreach (@{$self->{_fleets}}) {
        if ($_->Owner() == $player_id) {
            return 1;
        }
    }
    return 0;
}
sub ParseGameState{
    my ($self, $gameState) = @_;
    my $planet_id = 0;
    my $fleet_id = 0;

    foreach (@$gameState) {
        if ($_ =~ m/P\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)/) {;
            push(@{$self->{_planets}},new Planet($planet_id,$1,$2,$3,$4,$5));
            $planet_id++;
        } elsif ($_ =~ m/F\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)/) {
            push(@{$self->{_fleets}},new Fleet($fleet_id,$1,$2,$3,$4,$5,$6));
            $fleet_id++;
        } else {
            die('invalid parseinput')
        };
    }
}
sub FinishTurn{
    print "go\n";
}
1;
