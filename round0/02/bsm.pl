#!perl -w
use strict;
use warnings;
use Data::Dumper;
my $no_of_tests = <>;
die("Invalid input - Criteria for number of tests T: 1 ≤ T ≤ 50 failed\n") if($no_of_tests < 1 || $no_of_tests > 50);
for(my $i=0; $i < $no_of_tests; $i++) {
	my $str	= <>;
	my $out	= &process_input_string($str);
	my $index	= $i+1;
	print "Case #$index: $out\n";
}
sub process_input_string() {
	my $str = shift(@_);
	return "Invalid input - string not defined" unless(defined($str));
	chomp($str);
	return "YES" unless($str);
	my $len_str = length($str);
	return "Invalid input - Criteria for length of string len(s): 1 ≤ len(s) ≤ 100 failed" if($len_str < 1 || $len_str > 100);
	my $disp_arf	= [];	#for debugging only
	my $str_arf 	= [ split(//,$str) ];
	my $stack_arf	= ["0:0"];
	my $balance	= 0;
	my $tab		= "    ";
	while(@$stack_arf) {
		my $stack_val 		= pop(@$stack_arf);
		my($start,$match)	= split(":",$stack_val);
		#below statement means starting with )
		#and it cannot balance so try previous
		#stack entry
		next if($match < 0);
		my $smiley = 0;
		for(my $i=$start; $i < $len_str; $i++) {
			my $chr = $str_arf->[$i];
			$disp_arf->[$i] = ($tab x $match).$chr;
			if($chr =~ /[^():]/) {
				$smiley = 0;
				next;
			}
			if($chr eq ":") {
				#possible smiley and we give preference
				#to smileys since john likes to use them often
				$smiley = 1;
				next;
			}
			if($smiley) {
				push(@$stack_arf,$i.":".$match);
				$smiley = 0;
				next;
			}
			if($chr eq ")") {
				$match--;
				if($match < 0) {
					#it means starting with ) and it cannot balance
					#so try previous stack entry by exit loop
					last;
				}
				$disp_arf->[$i] = ($tab x $match).$chr;
				next;
			}
			if($chr eq "(") {
				$match++;
				next;
			}
		}
		unless($match) {
			#it means paranthesis is balanced and no
			#need to try other stack entries
			$balance = 1;
			last;
		}
	}
#	warn Dumper($disp_arf); #for debugging only
	return $balance ? "YES" : "NO";
}
