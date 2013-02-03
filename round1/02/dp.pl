#!perl -w
use strict;
use warnings;
use Data::Dumper;
my $no_of_tests = <>;
for(my $i=0; $i < $no_of_tests; $i++) {
	my $line1	= <>;
	my($W,$H,$P,$Q,$N,$X,$Y,$a,$b,$c,$d)	= split(" ",$line1);
	my $pos	= &find_the_diff_pos($W,$H,$P,$Q,$N,$X,$Y,$a,$b,$c,$d);
	my $index	= $i+1;
	print "Case #".$index.": ".$pos."\n";
}
sub find_the_diff_pos() {
	my($W,$H,$P,$Q,$N,$X,$Y,$a,$b,$c,$d)	= @_;
	my $d_hrf			= &find_dead_pixels($W,$H,$N,$X,$Y,$a,$b,$c,$d);
	my $tot_pos		= (($W - $P) + 1) * (($H - $Q) + 1);
	my $fail_pos_hrf	= &find_fail_pos($d_hrf,$W,$H,$P,$Q);
	my $fail_pos 		= keys(%$fail_pos_hrf);
	my $pos			= $tot_pos - $fail_pos;
#	print "$W,$H,$P,$Q,$N,$X,$Y,$a,$b,$c,$d,$tot_pos,$fail_pos,$pos\n";
#	my $f_hrf			= &get_fail_pixels($fail_pos_hrf);
#	&print_screen_with_dead_pixels($W,$H,$d_hrf,$f_hrf);
	return $pos;
}
sub find_dead_pixels() {
	my($W,$H,$N,$X,$Y,$a,$b,$c,$d) = @_;
	my $d_hrf = {};
	my $x_arf = [$X];
	my $y_arf = [$Y];
	$d_hrf->{$X}{$Y}++;
	for(my $i=1; $i < $N; $i++) {
		$x_arf->[$i] = ($x_arf->[$i-1] * $a + $y_arf->[$i-1] * $b + 1) % $W;
		$y_arf->[$i] = ($x_arf->[$i-1] * $c + $y_arf->[$i-1] * $d + 1) % $H;
		$d_hrf->{$x_arf->[$i]}{$y_arf->[$i]}++;
	}
	return $d_hrf;
}
sub find_fail_pos() { #finds failure positions based on dead pixels
	my($d_hrf,$W,$H,$P,$Q) = @_;
	$W--;$H--;$P--; $Q--;
	my $fail_pos_diag_hrf = {};
	foreach my $x_d_pix (keys(%$d_hrf)) {
		my $beg_x = (($x_d_pix - $P) < 0		) ? 0 			: ($x_d_pix - $P);
		my $end_x = (($x_d_pix + $P) <= $W	) ? $x_d_pix	: ($W - $P);
		foreach my $y_d_pix (keys(%{$d_hrf->{$x_d_pix}})) {
			my $beg_y = (($y_d_pix - $Q) < 0		) ? 0 			: ($y_d_pix - $Q);
			my $end_y = (($y_d_pix + $Q) <= $H	) ? $y_d_pix	: ($H - $Q);
			for(my $i=$beg_x; $i <= $end_x; $i++) {
				my $k = $i+$P;
				for(my $j=$beg_y; $j <= $end_y; $j++) {
					my $l = $j+$Q;
					$fail_pos_diag_hrf->{$i.":".$j.":".$k.":".$l}++;
				}
			}
		}
	}
	return $fail_pos_diag_hrf;
}
sub get_fail_pixels() {
	my $fail_pos_hrf	= shift(@_);
	my $f_hrf			= {};
	foreach my $abcd (keys(%$fail_pos_hrf)) {
		my($a,$b,$c,$d) = split(":",$abcd);
		for(my $i=$a;$i<=$c;$i++) {
			for(my $j=$b;$j<=$d;$j++) {
				$f_hrf->{$i}{$j}++;
			}
		}
	}
	return $f_hrf;
}
sub print_screen_with_dead_pixels() {
	my($W,$H,$d_hrf,$f_hrf) = @_;
	for(my $i=0;$i<$H;$i++) {
		for(my $j=0;$j<$W;$j++) {
			if(exists($d_hrf->{$j}{$i})) {
				print "D";
			}
			else {
				if(exists($f_hrf->{$j}{$i})) {
					print "F";
				}
				else {
					print "P";
				}
			}
		}
		print "\n";
	}
}
