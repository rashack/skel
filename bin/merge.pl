#!/usr/bin/perl -w
# -*- Mode: perl; tab-width: 4; indent-tabs-mode: nil; -*-
#
# Directory Merging Script
# Version 1.0
#
# Copyright (c) 2002 by Ian Hickson
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
use strict;

# takes two arguments: directory 1, directory 2
# recursively descend through directory 1, moving stuff that doesn't exist in directory 2 into directory 2

my $verbose = 0;

if (@ARGV == 2) {
    merge(@ARGV);
} else {
    print STDERR "merge requires two arguments, paths to directories. The first will be merged into the second.";
}

sub merge {
    my($a, $b) = @_;
    #   SOURCE: not -e    -f    -d   empty -d else
    # TARGET:
    #  not -e    err      mv    mv    mv      err
    #
    #      -f    err      err   err   err     err
    #
    #      -d    err      err   loop  rmdir   err
    #
    #    else    err      err   err   err     err
    print "merge: merging $a and $b\n";
    if (not -e $a) {
        print STDERR "merge:$a: doesn't exist\n";
    } elsif (not (-f $a or -d $a)) {
        print STDERR "merge:$a: not a normal file\n";
    } elsif (not -e $b) {
        print "merge: moving $a to $b\n" if $verbose;
        rename($a, $b) or print STDERR "merge:$a: could not rename to $b, $!\n";;
    } elsif (-d $b) {
        if (-d $a) {
            my @entries = getdir($a);
            if (@entries) {
                # not empty
                # recurse through it to give us a chance to make it empty
                print "merge: going through contents of $a\n" if $verbose;
                foreach my $entry (@entries) {
                    my $c = "$a/$entry";
                    $c =~ s|//|/|gos;
                    my $d = "$b/$entry";
                    $d =~ s|//|/|gos;
                    &merge($c, $d);
                }
            }
            # empty now?
            @entries = getdir($a);
            if (not @entries) {
                print "merge: deleting empty directory $a\n" if $verbose;
                rmdir($a) or print STDERR "merge:$a: could not delete directory, $!\n";
            } else {
                print STDERR "merge:$a: could not delete directory, directory is not empty\n";
            }
        } else {
            print STDERR "merge:$a: conflicts with directory $b\n";
        }
    } else {
        print STDERR "merge:$a: conflicts with non-directory $b\n";
    }
}

sub getdir {
    my($a) = @_;
    local *DIR;
    unless (opendir(DIR, $a)) {
        print STDERR "merge:$a: can't open directory\n";
        return;
    }
    my @entries;
    while (my $entry = readdir(DIR)) {
        if ($entry !~ m/^\.\.?$/o) {
            push(@entries, $entry);
        }
    }
    closedir(DIR) or print STDERR "merge:$a: could not close directory, $!\n";
    return @entries;
}
