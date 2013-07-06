#!/usr/bin/env perl

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
#
# [21oct98] (air) Created
# [30oct98] (air) expanded functionality: check for phonetic symbols
# [03feb99] (air) bug fix; added noise symbols to check
# [20010623] (air) added cmd-line flags; word/pron bound now \s+
# [20080422] (air) fixed for DOS eol's, also noisefile now properly optional

#
# correct dictionary format is:   ^WORD\tW ER DD\n$
# 
# - "W ER DD" are symbols from the legal phone set(s)
# - no leading/trailing spaces allowed
# - no duplicates words allowed
# - character collating sequence enforced
# 
# above spec should cover all (current) consumers of the dictionary file.
# not all conventions checked however (eg, for multiple pronunciations)
#

my $ErrFlag = 0;

use Getopt::Std; use vars qw/ $opt_p $opt_n /;
if ($#ARGV<0) { die("usage: test_dict -p <phonefile> [-n <noisefile>] <dictfile>\n"); }
getopt('p:n:'); $phonefile = $opt_p; $noisefile = $opt_n;
$dictfile = $ARGV[0];

# get the legal symbol set
open(PH,$phonefile) || die("can't open $phonefile!\n");
while (<PH>) { s/[\r\n]*//g; $phone{$_} = 1; } close(PH);
if ( defined $noisefile ) {
  open(PH,$noisefile) || die("can't open $noisefile!\n");
  while (<PH>) { s/[\r\n]*//g; $phone{$_} = 1; } close(PH);
}
open(DICT,$dictfile) ||die("$dictfile not found!\n");

# go through dict, do tests
%dict = (); $last = ""; my ($lead, $trail); $word_cnt = 0;
while (<DICT>) {
    chomp;  #    s/^\s*(.+?)\s*$/$1/;
    s/[\r\n]+//g;
    if ( /^;;;/ ) { next; }
    $line = $_;
    ($word,$pron) = split (/\s+/,$line,2);  # BIG assumption about no leading junk...
    $dict{$word}++;

    ($lead = $_) =~ s/^\s*(.+)/$1/;
    ($trail = $_) =~ s/(.+?)\s*$/$1/;
    if ($line ne $trail) { print "ERROR: trailing space in '$line'!\n"; $ErrFlag++;}
    if ($line ne $lead) { print "ERROR: leading space in '$line'!\n"; $ErrFlag++;}
    if ( $last ge $word ) { print "ERROR: words out of order: $last, $word\n"; $ErrFlag++;}

    # check for legal symbols
    @sym = split(/\s/,$pron);
    $errs = "";
    foreach $s (@sym) {	if ( ! $phone{$s} ) { $errs .= " $s"; } else { $phone{$s}++; } }
    if ($errs ne "") { print "ERROR: $word has illegal symbols: '$errs'\n"; $ErrFlag++;}

    # bad format
    @line = split (/\t/,$line);
    if ( $#line != 1 ) { print "ERROR: bad tabbing (",$#line, ") in: $line\n"; $ErrFlag++;}
    $word_cnt++;
    $last = $word;
}
close(DICT);

# check for duplicates entries
foreach $x (keys %dict) {
    if ($dict{$x}>1) { print "ERROR: $x occurs ", $dict{$x}, " times!\n"; $ErrFlag++;}
}

print STDERR "..processed $word_cnt words\n";
if ($ErrFlag > 0) {
    print STDERR "..$ErrFlag error(s) found\n";
    exit 1;
}

# print out the phone counts
# foreach (sort keys %phone) { print STDERR "$_\t$phone{$_}\n"; }

#
