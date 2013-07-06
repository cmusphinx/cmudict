#!/usr/bin/perl -w

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
# Research Projects Agency and the National Science Foundation of the
# United States of America, and the CMU Sphinx Speech Consortium.
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
#

# do a sanity check on a dictionary (# of tabs, duplicates)
# this should be done after manual editing and before checking in
#
# [21oct98] (air) Created
# [30oct98] (air) expanded functionality: check for phonetic symbols
# [03feb99] (air) bug fix; added noise symbols to check
# [20010623] (air) added cmd-line flags; word/pron bound now \s+
# [20080422] (air) fixed for DOS eol's, also noisefile now properly optional
# [20090331] (air) *** RENAMED to test_cmudict.pl ***
#                  added tests specific to the raw cmudict

#
# correct dictionary format is:   ^WORD(\(\d\))*\tW ER\d* DD\n$
# 
# - "W ER DD" are symbols from the legal phone set(s)
# - no leading/trailing spaces allowed
# - no duplicates words allowed
# - character collating sequence enforced for baseform
# 
# above spec should cover all (current) consumers of the dictionary file.
# not all conventions checked however (eg, for multiple pronunciations)
#

use strict;

my ($word, $pron, $tok);
my (%dict, %phone);

use Getopt::Std; use vars qw/ $opt_p $opt_n /;
if ($#ARGV<0) { die("usage: test_dict -p <phonefile> <dictfile>\n"); }
getopt('p:n:');
my $phonefile = $opt_p;
my $dictfile = $ARGV[0];

# get the legal symbol set
open(PH,$phonefile) || die("can't open $phonefile!\n");
while (<PH>) { s/[\r\n]*//g; $phone{$_} = 0; }
close(PH);

open(DICT,$dictfile) ||die("$dictfile not found!\n");

# go through dict, do tests
%dict = (); my $last = ""; my ($lead, $trail); my $word_cnt = 0;
while (<DICT>) {
    chomp;  #    s/^\s*(.+?)\s*$/$1/;
    s/[\r\n]*$//g;  # deal with dos/unix diffs
    if ( /^;;;/ ) { next; }  # ignore all comments in this pass
    my $line = $_;
    if ( $line  =~ /^\s*$/ ) { next; }  # empty lines allowed

    # general spacing issues
    ($lead = $_) =~ s/^\s*(.+)/$1/;
    ($trail = $_) =~ s/(.+?)\s*$/$1/;
    if ($line ne $trail) { print "ERROR: trailing space in '$line'!\n"; }
    if ($line ne $lead) { print "ERROR: leading space in '$line'!\n"; }

    # examine the head term and the pronunciation
    ($word,$pron) = split (/\s+/,$line,2);
    $dict{$word}++;

    # check tabbing
    my @line = split (/  /,$line);
    if ( ($line[0] ne $word) or (scalar @line ne 2) ) { 
	print "WARNING: tabbing error (",scalar @line, ") in: $line\n";
    }

    # check variant suffix
    # note that other than it being a digit, it only has to be unique
    if ( $word =~ /^[\(\)]/ ) {  # ignore 1st char if it's a paren
	$tok = substr $word, 1;
    } else { $tok = $word; }
    if ( ($tok =~ /\(/) or ($tok =~ /\)/) ) {
	if ( not ($tok =~ /^.+?\(\d\)$/) ) {
	    print "ERROR: malformed variant tag in '$word'\n";
	}
    }

    # check for legal phonetic symbols
    my @sym = split(/\s/,$pron);
    my $errs = "";
    my ($ph,$stress,$tail);
    foreach my $s (@sym) {
	$ph = $stress = 0;
	($ph,$stress) = ($s =~ /([A-Z]+)([012]*)/);
	if ( ( not defined $phone{$ph} )
	    ) { $errs .= " $s"; } else { $phone{$s}++; }
    }
    if ($errs ne "") { print "ERROR: $word has illegal symbols: '$errs'\n"; }


    # word order
    if ( &strip_variant($last) gt &strip_variant($word) ) {
	print "ERROR: collation sequence for $last, $word wrong\n";
	print "\t",&strip_variant($last)," ?? ",&strip_variant($word),"\n";
    }

    # tests passed (or not) keep going
    $word_cnt++;
    $last = $word;
}
close(DICT);

# check for duplicates entries
foreach my $x (keys %dict) {
    if ($dict{$x}>1) { print "ERROR: '$x' occurs ", $dict{$x}, " times!\n"; }
}

print "\nprocessed $word_cnt words\n";

# print out the phone counts
$last = "";
foreach (sort keys %phone) {
    if ( substr($_,0,2) eq substr($last,0,2) ) { print "\t| "; } else { print "\n  "; }
    print "$_\t$phone{$_}";
    $last = $_;
}
print "\n";

#

sub strip_variant {
    my $token = shift;
    my $result = "";
    if ($token =~ /(..*?)\(/) { $result = $1; } else { return $token; }
    return $result;
}

###
