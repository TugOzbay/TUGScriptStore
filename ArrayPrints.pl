#

my @leagueTeams = (“Arsenal”, “Tottenham”, “Manchester United”);

print “1 “, @leagueTeams, “\n”;

Print “2 $leagueTeams[2]\n”;

for(@leagueTeams) 
	{
	print “3 $_\n”;
	}

foreach my $team (@leagueTeams) 
	{
	print “4 $team\n”;
	}

foreach (@leagueTeams) 
	{
	print “5 $_\n”;
	}
