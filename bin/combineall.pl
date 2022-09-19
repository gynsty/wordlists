#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Math::Combinatorics;
use Term::ANSIColor;

$|=1;

my ( $help, $simple, $combi, $reverse, $brute, $lcucfirst, @tmp, $pairs );

GetOptions(
	"simple" => \$simple,
	"pairs" => \$pairs,
	"combi" => \$combi,
	"brute" => \$brute,
	"help" => sub{ USAGE() }
);

if ( !($simple||$pairs||$combi||$brute)) { 
	print color 'green';
	print "\nMISSING Option! Use: --simple, --pairs or --brute.\n";
	print color 'reset';
	USAGE(); 
}

# read lines from STDIN
while ( my $line = <STDIN> ) {
	chomp ($line);
	$line =~ s/^\s+//g;
	$line =~ s/\s+$//g;
	next if ( $line =~ /^\n/ );
	push (@tmp, $line ); # create list of items
}		

# CALLING OPTIONS

if ( $simple ) {
simple( \@tmp );
}

if ( $pairs ) {
	if ( scalar (@tmp) == 1 ){
	die "Sorry, it is not possible to create such list from 1 element only!\n";
	}
	pairs( \@tmp );	
}

if ($combi) {
	if ( scalar (@tmp) ==1 ){
	die "Sorry, it is not possible to create such list from 1 element only!\n";
	}
	bruteit( \@tmp );
}

if ( $brute ) {
 bruteit( \@tmp );
}


########## functions #############
sub simple {
	my ($arr) = @_;
	my $level = 1;
	foreach my $elem ( @$arr ) {
		next if ( $elem =~ /^\d+$/ );
		# LINES OF NUMBERS ONLY REMOVED

		# basic - lowercase, uppercase, first_upper_case		
		lcucfirst($elem);


		# double
		lcucfirst ($elem x 2);
		print lc ($elem ) . uc ($elem) ."\n";

		# triple
		lcucfirst($elem x 3);	
		#		if ( $level == 1 ) { next; }

		print uc ($elem) . lc ($elem) . lc ($elem) ."\n";
		print uc ($elem) . uc($elem). lc($elem) . "\n";
		print lc ($elem) . uc($elem) . lc($elem) . "\n";	
		print lc ($elem) . lc ($elem ). uc ($elem) . "\n";
	
		# double,triple of every character
                my $len = length($elem);
                my @double;
                my @triple;

                for (my $a=0; $a<$len;$a++ ) {
                my $str = substr $elem,$a,1;
                push (@double, $str x 2);
                push (@triple, $str x 3);
                }
                my $double = join "", @double;
                my $triple = join "", @triple;
                lcucfirst( $double );
                lcucfirst ( $triple );	

        	for (my $a=0; $a<$len;$a++ ) {
        	my $str = substr $elem,$a,1;
        	push (@double, $str x 2);
        	push (@triple, $str x 3);
        	}
        
		# last char, double, triple

		# add first letter at the end
		my $first = substr $elem,0,1;
		my $string = $elem . $first;
		lcucfirst ( $string );
	
		# step-by-char Password: Pa, Pas, Pass, ...

		for(my $c=2;$c<$len;$c++){
			lcucfirst( substr $elem,0,$c);
			# requires hack - first letter uppcercase, will be there twice 
			# uc and ucfirst function
		}
		
		# double, triple of start or end char
		my $start = substr $elem, 0,1;
		my $end = substr $elem, -1,1;
		lcucfirst( $start x 2 . substr $elem, 1 );
		lcucfirst( $start x 3 . substr $elem, 1 );
		lcucfirst( substr $elem,0,-1, . $end x 2 );
		lcucfirst( substr $elem,0,-1, . $end x 3 );
		
		#uppercase combinations
		#my $len = length($elem);
		for (my $a=2; $a<$len; $a++){
                print uc (substr $elem,0,$a,) . substr $elem,$a,$len, ."\n";
		}

		if ( length ( $elem ) != 1 ) { 
		# CAN NOT PRINT REVERSE OF SOMETHING THAT IS 1 CHAR LONG ONLY
		my $reverse = reverse ( split //, $elem);
		lcucfirst ( $reverse );	
		lcucfirst ( $reverse x 2 );
		lcucfirst ( $reverse x 3 );
		lcucfirst( $elem . $reverse );
		lcucfirst ( $reverse . $elem );

		# human natural substitutions I observed
			my $subst = $elem;
			$subst =~ s/y/i/ig;
			lcucfirst ( $subst );
			
			my $subst2 = $elem;
			$subst2 =~ s/i/y/ig;
			lcucfirst( $subst2 );

		# computer jargon
		if ( $elem =~ /o|s|e|l|f|i/ ) {

		if ( $elem =~ /o/i ) {
			my $jargon = $elem;
			$jargon=~ s/o/0/ig;
			lcucfirst( $jargon );
		}
		if ( $elem =~ /s/i ) {
			my $jargon = $elem;
			$jargon =~ s/s/5/ig;
			lcucfirst( $jargon );
		}
		if ( $elem =~ /e/i ) {
			my $jargon = $elem;
			$jargon =~ s/e/3/ig;
			lcucfirst( $jargon );
		}
		if ( $elem =~ /f/i ) {
			my $jargon = $elem;
			$jargon =~ s/f/4/ig;
			lcucfirst( $jargon );
		}
		if ( $elem =~ /l/i ) {
			my $jargon = $elem;
			$jargon =~ s/l/1/ig;
			lcucfirst( $jargon );
		}
		if ( $elem =~ /i/i ) {
			my $jargon = $elem;
			$jargon =~ s/i/1/ig;
			lcucfirst( $jargon );
		}
		if ( $elem =~ /o|s|e|l|i|f/i ) {
			# implement all jargon substitutions
			my $jargon = $elem;
			$jargon =~ s/o/0/ig;
			$jargon =~ s/s/5/ig;
			$jargon =~ s/e/3/ig;
			$jargon =~ s/l/1/ig;
			$jargon =~ s/i/1/ig;
			$jargon =~ s/f/4/ig;
			lcucfirst( $jargon );
			# DOPLNIT:
			# h - # e - @ c - , e - 3, s - $
		}
		}

		}
	}
}

sub pairs {
	my ($pairs) = @_;
	foreach my $elem1 ( @$pairs ) {
		foreach my $elem2 ( @$pairs ) {
			if ( $elem2 !~ /$elem1/ ) {
				my $string1 = $elem1 . $elem2;
				lcucfirst( $string1 );
				print ucfirst $elem1 . ucfirst $elem2 ."\n";
				# special addition
			}
		}
	}
}

sub lcucfirst {
my ( @line ) = @_;
	my $line = "@line";
	print lc "$line\n";
	exit if ( $line =~ /^[0-9].+/ );
	# because we can not print uppercase of number

	print uc "$line\n";
	print ucfirst "$line\n";
}

sub bruteit {
	my ( $lines ) = @_;
	if ( $combi ) {
	my $combinat1 = Math::Combinatorics->new( data => [@$lines] );	
		while(my @permu = $combinat1->next_permutation){
                        #lcucfirst( join('', @permu) );
                        print join('', @permu),"\n";
                }
	}
	else {
	foreach my $elem ( @$lines ) {
		my @data = split //, $elem;
		my $combinat2 = Math::Combinatorics->new( data => [@data] );
		while(my @permu = $combinat2->next_permutation){
    			#lcucfirst ( join('', @permu));
                        print join('', @permu),"\n";
  		}
	}
	}
}

sub USAGE {
	print color 'bold red';
	print "\nThis is HELP: \n";
	print uc "we do not produce lines consisting numbers only!\n\n";
	print "$0 --help - THIS HELP.\n\n";
	print "$0 --simple - will create simple list.\n";
	print color 'bold blue';
	print "OUTPUT: password, Password, PASSWORD, Drowssap...\n\n";
	print color 'bold red';
	print "$0 --pairs - will combine list of your patterns by pairs.\n";
	print color 'bold blue';
	print "OUTPUT: admin, pass - will produce: adminpass, passadmin...\n\n";
	print color 'bold red';
	print"$0 --combi - will create permutations of of the list\n";
	print color 'bold blue';
	print "OUTPUT: admin, pass, pass1 - will produce: adminpasspass1..\n\n";
	print color 'bold red';
	print "$0 --brute - will produce all possible permutations of pattern\n";
	print color 'reset';
	exit;
}
# --level ??
#-- je tam buga, v jargone, moze to generovat duplicitne zaznamy..
# doplnit prve pismeno na posledne pismeno
# posledno pismeno a pismeno, ktore nasleduje za nim v abecede
