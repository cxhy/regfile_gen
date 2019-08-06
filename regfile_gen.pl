#! /usr/bin/perl
###############################################################################
#
# Description    :  
# Version        : 0.1
# Author         : guodezheng <cxhy1981@gmail.com>
# Created Time   : 2019-08-04 13:03
# Last Modified  : 2019-08-04 16:38
#
# Copyright (C) 2019 guodezheng <cxhy1981@gmail.com>
# Distributed under terms of the MIT license.
###############################################################################

use strict;
#use warnings;

$| = 1;

use File::Copy;
use IO::Scalar;
use Spreadsheet::Read;
use Spreadsheet::ReadSXC;
use Spreadsheet::ParseXLSX;
use Switch;
use Getopt::Long;

###############################################################################
#golbal variable
###############################################################################
my @RDarg;

my $g_srcfile_name;

my $g_max_addr_width = 0;

my $g_start_row = 4;
my $g_start_col = 1;

my $g_max_row;
my $g_max_col;


push @RDarg, strip => 1;
push @RDarg, attr  => 1;
use vars qw($opt_h $opt_v );
GetOptions(
  'help|h'       => \$opt_h,
  'version|v'    => \$opt_v
) or die $!;

if($opt_h){
  &help_log();
  exit(1);
}

if($opt_v){
  print "0.1\n";
}

$g_srcfile_name = shift(@ARGV);

die "Cannot open file $g_srcfile_name\n" unless(-e $g_srcfile_name);

my $book = ReadData ($g_srcfile_name, @RDarg)->[1] or die "cannot read $g_srcfile_name\n";
$g_max_row = $book->{maxrow};
$g_max_col = $book->{maxcol};
# my $xx = $book->{maxcol};
# my $yy = $book->{maxrow};
# my $cell = cr2cell(3,5);
# my $zz = $book->{$cell};

# print "$xx\n";
# print "$yy\n";
# print "$zz\n";
# print "$book->{attr}[4][5]{merged}\n";

# foreach my $row (1 .. $book->{maxrow}) {
#     foreach my $col (1 .. $book->{maxcol}) {
#         my $cell = cr2cell ($col, $row);
#         printf "%s %-3s %d  ", $cell, $book->{$cell},
#             $book->{attr}[$col][$row]{merged};
#         }
#     print "\n";
#     }

&check_data();

&cal_max_offset();

sub help_log(){
  print "This is help log\n";
}

sub check_data(){
  
}

#This function returns the bit width of the largest offset address
sub cal_max_offset(){
  my $cell_tmp = cr2cell($g_start_col,($g_max_row-2));
  my $max_addr_h = $book->{$cell_tmp};
  my $max_addr_b = sprintf "%b", hex(substr($max_addr_h,2));
  my $g_max_addr_width = length($max_addr_b);
}


