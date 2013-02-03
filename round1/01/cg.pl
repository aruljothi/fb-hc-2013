#!perl -w
use strict;
use warnings;
use Data::Dumper;
my $no_of_tests = <>;
for(my $i=0; $i < $no_of_tests; $i++) {
	my($n,$k,%hrf,$sum);
	my($line1,$line2);
	$line1	= <>;
	$line2	= <>;
	($n,$k)	= split(" ",$line1);
	%hrf	= map {$_ => 0} split(" ",$line2);
	$sum	= &find_the_sum($n,$k,\%hrf);
	my $index = $i+1;
	print "Case #".$index.": ".$sum."\n";
}
sub find_the_sum() {
	my($n,$k,$hrf) = @_;
	my $count_req  = $n-$k+1;
	my $half_of_n  = ($n%2) ? int($n/2)+1 : int($n/2);
	my $loop_count = ($count_req < $half_of_n) ? $count_req : $half_of_n;
	my $max_arf    = [];
	my $min_arf    = [];
	my $min        = (keys(%$hrf))[0];
	my $max        = $min;
	for(my $i=0;$i < $loop_count; $i++) {
		my $tmp = $min;
		   $min = $max;
		   $max = $tmp;
		foreach my $key (keys(%$hrf)) {
			next if($hrf->{$key}); #ignore if it is already a min or max
			if($key > $max) {
				$max = $key;
			}
			if($key < $min) {
				$min = $key;
			}
		}
		push(@$max_arf,$max);$hrf->{$max} = 1;
		last if($max <= $min);
		unshift(@$min_arf,$min);$hrf->{$min} = 1;
	}
	my $arf    = $max_arf;push(@$arf,@$min_arf);
	my $modulo = 1000000007;
	my $limit  = $k-1;
	my $sum    = 0;
	for(my $i=1;($n-$i) >= $limit;$i++) {
		my $val = shift(@$arf);
		my $cmb = &comb($n-$i,$limit);
		my $mod_by_val = ($modulo % $val) ? int($modulo/$val)+1 : int($modulo/$val);
		my $div  = int($cmb / $mod_by_val);
		my $rem  = $cmb % $mod_by_val;
		my $mod  = (($val * $mod_by_val) % $modulo);
		   $sum  = $sum + ((($mod * $div) + ($val * $rem)) % $modulo);
		print "$val,$cmb,$sum\n";
	}
	return $sum % $modulo;
}
sub comb() {
	my($n,$r) = @_;
	my $big   = ($n-$r) > $r ? ($n-$r) : $r;
	my $small = ($n-$r) > $r ? $r      : $n-$r;
	my $n_by_nminr_fact = &fact($n,$big);
	my $r_fact          = &fact($small);
	my $c               = int($n_by_nminr_fact/$r_fact);
	return $c;
}
sub fact() {
	my $n = shift(@_);
	my $r = shift(@_) || 0;
	my $f = 1;
	$f *= $_ for $r+1..$n;
	return $f;
}

