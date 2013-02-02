#!perl -w
use strict;
use warnings;
use Data::Dumper;
my $no_of_lines = <>;
die("Invalid input - Criteria for number of tests T: T ≤ 20 failed\n") if($no_of_lines > 20);
for(my $i=0; $i < $no_of_lines; $i++) {
	my $line1			= <>;
	my $line2			= <>;
	my($n,$k)			= split(" ",$line1);
	my($a,$b,$c,$r)	= split(" ",$line2);
	my($marr,$tarr)	= &create_m($k,$a,$b,$c,$r);
	my $out			= &find_the_min($marr,$tarr,$n,$k);
	my $index = $i+1;
	print "Case #".$index.": ".$out."\n";
}
sub create_m() {
	my($k,$a,$b,$c,$r) = @_;
	my $marr  = [$a];
	my $tarr	= [];@$tarr = (0) x ($k+1);$tarr->[$a]++ if($a <= $k);
	foreach(my $i=1; $i < $k; $i++) {
		$marr->[$i] = (($b * $marr->[$i-1]) + $c) % $r;
		$tarr->[$marr->[$i]]++ if($marr->[$i] <= $k);
	}
	return($marr,$tarr);
}
sub find_the_min() {
	my($marr,$tarr,$n,$k) = @_;
	my $min = 0;
	for(my $i=$k; $i < $n; $i++) {
		for(my $j=$min;$j <= $k; $j++) {
			unless($tarr->[$j]) {
				$min = $j;
				last;
			}
		}
		if($min == $k) {
			my $index = ($n-1-$i) % $k+1;
			my $min_val = $index ? $marr->[$index-1] : $min;
			return $min_val;
		}
		my $left = shift(@$marr);
		push(@$marr,$min);
		$tarr->[$min]++;
		if($left <= $k) {
			next if(--$tarr->[$left]);
			next if($min <= $left);
			$min = $left;
		}
	}
	return $min;
}
