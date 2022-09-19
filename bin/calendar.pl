#!/usr/bin/perl
use strict;
use warnings;
use List::MoreUtils qw(uniq);
use Getopt::Long;
use Term::ANSIColor;

# getoptionsb
my ($gen,$lang,$from,$to,$SEP,$version,$help,$verb);

GetOptions ("gen=s" => \$gen, 
            "lang=s"   => \$lang, 
            "from=i" => \$from,
	    "to=i" => \$to,  # if not to -> get actual year
            "sep=s" => \$SEP, # if separator - > negeneruj bez separatora
            "version"  => \$version,
	    "verb" => \$verb,
	    "help" => \$help)
or die("Error in command line arguments\n");

#-gen num|string|all, -lang cz|sk|en|all -from -to  

help() if ($help);

if ($version){
  print "Version is:0.01\n";
}

if ($gen){
 print "$gen\n";
}

if ($lang){
  print "$lang\n";
}

if ($SEP){
  print "$SEP\n";
}

# options check
#die "-from is required and -to is required!\n" if (!($from && $to));

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();

if (!$from){
  $from = 1930;
}

if (!$to){
 $to = $year+1900;
}

my @years = ($from..$to);

#$year += 1900; 

# salute 
#my @years = (1930..$year); # to catch actual year
#my @years = (1930..2017);
my @months = (1..12);
my @zero = ("01".."09");
my @days = (1..31);
my @separators = qw ( . / - % );

# fix format problem with 01 instead of 0

my @tmp = ();
my $setzero = 1;

if ($setzero){
  splice (@days, 9, 0, @zero);
  splice (@months, 9, 0, @zero);
}

# fix issue with year format like 2017 -> 17
my @sub_years = ();

foreach my $a (@years){
  push(@sub_years,$a);
  push(@sub_years,substr($a,-2));
}

@years = @sub_years; @sub_years = ();

my @output = ();
my @uniq;

# sk months
my
@sk_months_short = qw (
jan
feb
mar
apr
maj
jun
jul
aug
sep
okt
nov
dec
);

my @sk_months_long = qw (
januar
februar
marec
april
maj
jun
jul
august
september
oktober
november
december
);

my @cz_months_short = qw (
led
uno
unor
bre
dub
kve
cer
crv
srp
zar
rij
lis
list
pro
);

my @cz_months_long = qw (
leden
unor
brezen
duben
kveten
cerven
cervenec
srpen
zari
rijen
listopad
prosinec
);

my @en_months_short = qw (
jan
feb
mar
apr
may
jun
jul
aug
sep
oct
nov
dec
);

my @en_months_long = qw (
january
february
march
april
may
june
july
august
september
october
november
december
);

my @en_days_short = qw (
mo
mon
tu
tue
we
wed
th
thu
fr
fri
sa
sat
su
sun
);

my @en_days_long = qw (
monday
tuesday
wednesday
thursday
friday
saturday
sunday
);

sub printFormats{
 my ($d,$m,$y,$SEP) = @_;

    if (!$SEP){
      # day month year
      push(@output,"$d$m$y"); 
      # year month day
      push(@output,"$y$m$d");
      # month day year
      push(@output,"$m$d$y");

      # month year
      push(@output,"$m$y"); 
      # year month 
      push(@output,"$y$m");
    }

    if ($SEP){
     # day month year
     push(@output,"$d$SEP$m$SEP$y"); 
     # year month day
     push(@output,"$y$SEP$m$SEP$d");
     # month day year
     push(@output,"$m$SEP$d$SEP$y");

     # years as substring
     my $y_sub = substr($y,-2);

     # day month year_sub
     push(@output,"$d$SEP$m$SEP$y_sub"); 
     # year_sub month day
     push(@output,"$y_sub$SEP$m$SEP$d");
     # month day year_sub
     push(@output,"$m$SEP$d$SEP$y_sub");
    }
    
}

sub printFormats2{
 my ($m,$y,$SEP) = @_;
   # mont - year 
   # we have sep print more combinations

   # do all this work for 3 options: october, October, OCTOBER
 if (!$SEP){ 
  push(@output,"$m$y");
  push(@output,"$y$m"); 
 }

 if ($SEP){
  push(@output,"$m$SEP$y");
  push(@output,"$y$SEP$m"); 
 }

}

sub generateNumberFormat{
 my ($dd,$mm,$yy,$SEP) = @_;
 
 foreach my $d (@$dd){
  foreach my $m (@$mm){
   foreach my $y (@$yy){
     printFormats($d,$m,$y,$SEP);
 
   }
  }
 }
 

};

sub generateStringFormat{
 my ($dd,$mm,$yy,$SEP) = @_;

 # generate day-month-year if we have day as param
   foreach my $d (@$dd){
    foreach my $m (@$mm){
     foreach my $y (@$yy){
       printFormats($d,$m,$y,$SEP);
       printFormats(ucfirst($d),ucfirst($m),$y,$SEP);
       printFormats(uc($d),uc($m),$y,$SEP);
     }
    }
   }
};

sub generateStringFormat2{
 my ($mm,$yy,$SEP) = @_;
   # generate just month-year
   foreach my $m (@$mm){
     foreach my $y (@$yy){
       printFormats2($m,$y,$SEP);
       printFormats2(ucfirst($m),$y,$SEP);
       printFormats2(uc($m),$y,$SEP);
     }
 }
};

generateNumberFormat(\@days,\@months,\@years,$SEP);
#generateStringFormat(\@days,\@cz_months_long,\@years,$SEP);

# final output
if (scalar(@output) > 0){
  print color('white');
  map { print "$_\n" } (uniq @output);
  print color('reset');
}

sub help{
 print color('red');
 print "Program help:\n";
 print "You can get this help with --help or -h\n";
 print "-from - enter year to generate patterns from. If not set default value is year 1930.\n";
 print "-to - enter year to generate pattern to. If not set default value is current year.\n";
 print "-gen - generate type of pattern number|string\n";
 print "-lang - generate patterns based on languages: cz|sk|en\n";
 print "-sep - generate patterns with value separated by this SEPARATOR\n";
 print "-sep - accepts multiple values. In use case use quotes to separate values. Example: \"/ - \ % *\"\n";
 print color('reset');
 exit(255);
}

print STDERR ("I feel fine!\n");
if ($verb){
 print STDERR "Lines printed:" .scalar(@output),"\n";
}
exit(0);

=a
1. vygeneruj ciselne datumy s roznym separatorom alebo bez separatora
2. vygeneruj datumy s menom
3. vygeneruje datumy podla jazyka

# zero fix - does not work ? why? 

# put year substring into years array
# options -> years range 
# select lang
# generuj cisla alebo stringy
# generuj rodne cisla
# -gen num|string|all, -lang cz|sk|en|all -from -to  

