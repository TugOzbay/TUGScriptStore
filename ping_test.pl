#!/usr/bin/perl


open FH, "< ./local.nodes";
my @array = <FH>;


chomp (@array = grep !/^$|\#|susb/, @array);


my $count = 0;

foreach my $host (@array) {
        $count ++;
        if (ping_test($host) == 1) {

                print "$count Success $host\n";

        }
        ##print "$count $host\n";

}


# Does ping test 1 pass 2 fail
sub ping_test
{

        use Net::Ping;

        my $hostname = $_[0];

        my $job = Net::Ping->new();
    if ($job->ping($hostname)) { return 1 }  else { return 2 }; ##Return 2 if host is unreachable
    $job->close();

} ##End ping_test
