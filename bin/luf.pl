#!/usr/bin/perl
use strict;
use warnings;

while (<STDIN>){
 chomp($_);
 print lc "$_\n";
 print uc "$_\n";
 print ucfirst "$_\n";

}
