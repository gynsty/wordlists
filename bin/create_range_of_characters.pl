#!/usr/bin/perl
use strict;
use warnings;

my @arr = ('a'..'z',0..9);
my @new = @arr;

my $i=1;
my $howmany = shift;
if (!$howmany){
die "Param1 is howmany char todo.\n";
}
printIt($howmany);

sub printIt{
  my $count = shift;
  exit if $count == 0;
  foreach my $char (@new){
  	print "$char\n";
  }
  $count--;
  $i++;
  my $y=0;
  @new = ($arr[0] x $i..$arr[25] x $i);
  printIt($count);
}

