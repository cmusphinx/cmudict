#!perl -w

#
# ====================================================================
# Copyright (C) 1999-2008 Carnegie Mellon University and Alexander
# Rudnicky. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
#
# This work was supported in part by funding from the Defense Advanced
# Research Projects Agency, the Office of Naval Research and the National
# Science Foundation of the United States of America, and by member
# companies of the Carnegie Mellon Sphinx Speech Consortium. We acknowledge
# the contributions of many volunteers to the expansion and improvement of
# this dictionary.
#
# THIS SOFTWARE IS PROVIDED BY CARNEGIE MELLON UNIVERSITY ``AS IS'' AND
# ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL CARNEGIE MELLON UNIVERSITY
# NOR ITS EMPLOYEES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ====================================================================
#

# Sort cmudict according to head entry collating sequence

# [20090331] (air) Created.

use strict;

if ( scalar @ARGV ne 2 ) { die "usage: sort_cmudict <input> <output>\n"; }

open(IN, $ARGV[0]) || die "can't open $ARGV[0] for reading!\n";
open(OUT,">$ARGV[1]") || die "can't open $ARGV[1] for writing!\n";

my %header = ();  # header comment lines (passed through)
my %histo = ();   # some statistics on variants

my %dict = ("" => {VARIANT => [], COMMENT => ""} );    # words end up in here
my $last = "";  # the last word processed

&get_dict(\%dict,\%header,*IN);  # process the entries

# print special comments (copyright, etc.)
foreach my $h (sort keys %header) { print OUT "$header{$h}"; }

# print out each entry
my $DELIMITER = '  ';  
foreach my $w (sort keys %dict) {
  my $var=1;  # number variants from 2 (this is different from original)
  foreach my $p ( @{$dict{$w}{VARIANT}} ) {
      if ($var eq 1) {
	  print  OUT "$w$DELIMITER$p\n";
      }  else {
	  print  OUT "$w($var)$DELIMITER$p\n";
      }
      $var++;
  }
}



# read in a dictionary
sub get_dict {
  my $dict = shift;  # data structure with dictionary entries
  my $header = shift;
  my $target = shift;  # input file handle
  my ($word,$pron,$root,$variant);
  my ($basecount,$base,$dupl,$varia);

  while (<$target>) {
    s/[\r\n]+$//g;  # DOS-robust chomp;

    # process comments; blank lines ignored
    # presume that ";;; #" will be collected and emitted at the top
    if ($_ =~ /^;;; \#/) {  # save header info
	$header{$last} .= "$_\n";
	next;
    } 
    elsif ( $_ =~ /^;;;/ ) { $header{$last} .= "$_\n"; next; }  # ignore plain comments
    elsif ( $_ =~ /^\s*$/ ) { $header{$last} .= "$_\n"; next; }  # ignore blank lines

    # extract the word,pron pair and prepare for processing
    ($word,$pron) = /(.+?)\s+(.+?)$/;
    if (! defined $word) { print STDERR "bad entry (no head word): $_\n"; next; }

    $basecount++;

    if ($word =~ /\(\d\)$/) { # variant
      ($root,$variant) = ($word =~ m/(.+?)\((.+?)\)/);
    } else {
      $root = $word;
      $variant = 0;
    }

    # found a new baseform; set it up
    if ( ! defined $dict->{$root} ) {
	$dict->{$root}{VARIANT}[0] = $pron;
	$base++;
	next;
    }

    # already-seen baseform; see if pron is a duplicate
    foreach my $var ( @{$dict->{$root}{VARIANT}} ) {
	if ( $var eq $pron ) {
	    print STDERR "duplicate entry: $root ($variant) $pron!\n";
	    $dupl++;
	    $pron = "";
	    last;
	}
    }

    # it's a new variant on an existing baseform, keep it
    if ( $pron ne "" ) { 
	push @{$dict->{$root}{VARIANT}}, $pron;
	$varia++;
	$histo{scalar @{$dict->{$root}{VARIANT}}}++;  # track variant stats
	if ( scalar @{$dict->{$root}{VARIANT}} ge 4 ) {
	    print STDERR "$root -- ",scalar @{$dict->{$root}{VARIANT}},"\n";
	     }
    }
    $last = $word;  # remember which token we just did
  }
}
