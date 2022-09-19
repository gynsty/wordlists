#!/usr/bin/perl -w
use strict;

print "Enter keywords:\n";

my @arr;

while (my $line = <STDIN>){
 chomp($line);
 push(@arr,$line);
}



foreach (@arr){
  open FILE,"<", 'suffix.txt' or die "$!\n";
  while (my $suf = <FILE>){
    chomp($suf);

    # original
    print "$_$suf\n";
    print "$suf$_\n";

    # lower
    print lc $_,$suf,"\n";
    print $suf,lc $_,"\n";

    # upper
    print uc $_,$suf,"\n";
    print $suf,uc $_,"\n";

    # capitalize
    print ucfirst $_,$suf,"\n";
    print $suf,ucfirst $_,"\n";

  }
}
