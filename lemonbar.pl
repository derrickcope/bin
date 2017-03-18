#!/usr/bin/perl
#use utf8;
use open ':std', ':encoding(UTF-8)';
#use Unicode::Normalize;

#binmode STDOUT, ':utf8';
use autodie;

$| = 1; 

sub datetime {
    	$datestring = localtime();
}

sub memhome {
    chomp($dfresult = `df -h /dev/sdb1`);
    @sda1 = split /\s+/, $dfresult;
    $homestat = "Home: $sda1[9]/$sda1[8] $sda1[11]";
    return $homestat;
}

sub memroot {
    chomp($dfresult = `df -h /dev/sda2`);
    @sdb2 = split /\s+/, $dfresult;
    $rootstat = "Root: $sdb2[9]/$sdb2[8] $sdb2[11]";
    return $rootstat;
}

sub groups {
    open GROUPS, '<', '/tmp/groups.sh/active';  
#        or die;
my $groups;    
while ( <GROUPS> ) {
        chomp;
        $groups = join " ", $_, $groups;
    }
@groups = split " ", $groups;
@groups = sort @groups;
$groups = join " ", @groups; 
return $groups;
}

sub free {
    chomp($dfresult = `free -mh`);
    @memarray = split /\s+/, $dfresult;
    $memstat = "Mem: $memarray[9]/$memarray[8]";
    return $memstat;
}

while () {
    print "%\{F#1793d1\}" ."%\{r\}" ."%\{F#1793d1\}" . &free ." | " . &memroot ." | " . &memhome ." | " ."Date: " . &datetime ."\n";
#    print "%\{F#1793d1\}" ."%\{l\}" . &groups ."%\{r\}" ."%\{F#1793d1\}" . &memroot ." | " . &memhome ." | " ."Date: " . &datetime ."\n";
    sleep(1);
}
