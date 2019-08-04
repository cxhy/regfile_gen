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
my $g_srcfile_name;

my $g_max_addr_width = 0;

my $g_start_row = 4;
my $g_start_clome = "A";

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

my $book = Spreadsheet::Read->new ($g_srcfile_name);
my $sheet = $book->sheet (1);
my $cell  = $sheet->cell ("C5");
my $cell2  = $sheet->cell ("C6");
my $cell3  = $sheet->cell ("D5");
my $cell4  = $sheet->cell (1,3);
my $sheet_max_row = $sheet->maxrow;
my $sheet_max_col = $sheet->maxcol;

print "$sheet_max_row\n";
print "$sheet_max_col\n";

&check_data();

&cal_max_offset();

sub help_log(){
  print "This is help log\n";
}

sub check_data(){
  
}

sub cal_max_offset(){
  #计算最大偏移地址
  #返回reg_addr的最大位宽
  my $max_offset_cell = $sheet->cell(4,5);

  print "$max_offset_cell\n";

}


