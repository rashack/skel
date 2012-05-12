#!/usr/bin/perl -w

select STDOUT; $| = 1; # make unbuffered, i want to see output NOW, performance is not an issue here

my $blanked = 0;
my $vol = 0;

sub mute_master {
    $vol = `/home/kjella/bin/shortvol`;
    $vol =~ s/[^[]+[[]([0-9]{1,3})\%[]].+/$1/;
    system "amixer set Master 0";
}

sub unmute_master {
    system "amixer set Master $vol";
}



open (IN, "xscreensaver-command -watch |");
while (<IN>) {
    if (m/^(BLANK|LOCK)/) {
        if (!$blanked) {
            print $_;
            $blanked = 1;
	    system "echo \$(date +\"%F_%T\") OUT >> ~/.time"
#	    mute_master;
        }
    } elsif (m/^UNBLANK/) {
        print $_;
        $blanked = 0;
	system "echo \$(date +\"%F_%T\") IN >> ~/.time"
#	unmute_master;
    }
}
