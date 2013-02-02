#!perl -w
use Data::Dumper;
my $no_of_tests = <>;
for(my $i=0; $i < $no_of_tests; $i++) {
	my $string	= <>;
	my $oval	= &find_the_beauty($string);
	my $index	= $i+1;
	print "Case #$index: $oval\n";
}
sub numerically { $a <=> $b };

sub find_the_beauty() {
	my $string = shift(@_);
	chomp($string);$string = lc($string);
	my $len_str = length($string);
	my $string_hrf = {};
	my @string = split(//,$string);
	foreach my $chr (@string) {
		$chr = lc($chr);
		$string_hrf->{$chr}++ if($chr =~ /[a-z]/);
	}
	my @count_arr	= reverse sort numerically values(%$string_hrf);
	my $max_val	= 26;
	my $tot_val	= 0;
	while(@count_arr) {
		my $count	 = shift(@count_arr);
		$tot_val	+= $count * $max_val--;
	}
	return $tot_val;
}
