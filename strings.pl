#!/usr/local/bin/perl -w
# my string sample
#
my $str = "The red and white boys of Arsenal";

my @words = split(' ', $str);		# split my words using space “ “ and attach the $str string to each

foreach my $word (@words) {			# for each of my $words within the @words array print each content.
    print "$word\n";
}

print " \n\n\n";
print "All words: @words\n";		# print the whole array @words
print "Second word: $words[1]\n";	# print the slot [1] which is the second word in the @word array
# print "Second word: @words[1]\n";	# print the slot [1] which is the second word in the @word array

exit 0;

