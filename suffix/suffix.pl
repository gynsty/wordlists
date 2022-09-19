#!/usr/bin/perl
use strict;

my $dicfile = shift;
my $suffile = shift;
my $options = shift;

if (!($dicfile || $suffile || $options )){
  print "Missing parameters: 1.dicfile 2.suffile 3.options\n";
  die "Options are: 1-suffix only, 2.prefix only, 3.both\n, 123. means all options\n";
}

open DICT,"<",$dicfile or die "$!\n";
open SUF,"<",$suffile or die "$!\n";

my @dic = <DICT>;
my @suf = <SUF>;

map {print "$_" } @dic; # print default username as password

# print suffixes
foreach my $s (@suf){
 foreach my $d (@dic){
   chomp($s);
   chomp($d);

   if ($options =~ /^1$/){
     print "$d$s\n";
   }
   elsif ($options =~ /^2$/ ){
     print "$s$d\n";
   } elsif ($options =~ /^3$/ ){
     print "$s$d$s\n";
   } elsif ($options =~ /^123$/ ){
     print "$s$d\n";
     print "$s$d$s\n";
     print "$d$s\n";
   } 
   else { }
    
 }
}

exit(0);
