#!/usr/bin/perl
# Author      : Tugrul Ozbay
# Date        : 4th Feb 2014
# Reason      : Flynn provided small project; ssh to all boxes and runs a cmd, then outputs
# Version     : 2.1.0
# Strict      : Suppose so
# Warnings    : Using cjcadmin (dark...) from mgmt server so be careful
#
#
use strict;
use warnings;
#
#
my $time = localtime(time);
print $time;
#
# check login is cjcadmin. if not die
#
my $user = (getpwuid $>);
die " Error you must run this as cjcadmin" if $user ne 'cjcadmin';
#
#
#
my (@list);
#
open FILE_IN, "< ./hosts" or die $!;
chomp (my @HostsFileIn = <FILE_IN>);
close FILE_IN;
#
unlink "./perl4.log" if -f "./perl4.log";       ## clears the perl4.log if it exists
my @cleanHosts = grep ! /\#|^$/, @HostsFileIn;  ## clears my input to Hosts
#print "@cleanHosts\n";

main();

sub main {



        foreach my $host (@cleanHosts) {        ## for each $host within array @cleanHosts

                #print "$host\n";

                my $hostIp = ( split  /\s+/, $host)[0];         ## take entry 0 as ip which is the first entry
                my $hostname = ( split  /\s+/, $host)[1];       ## take entry 1 as hostname

                ##if ($hostname =~ "localhost");
                if (grep /localhost/i,  $hostname) {
                        localhost_work($hostname);
                        next; ##Next itteration of loop
                }

        ##      localhost_work() if (grep /localhost/i,  $hostname);


                ##print "$hostname\n";

                #print "Hostname $hostname + ip $hostIp\n";

                my $result = ping_test($hostname);

                tugz($result, $hostname);
                #print "$hostname $result\n";

        }




}##End main

sub localhost_work
{
 my $localHost = $_[0];

        print " We have a LOCALHOST..$localHost \n\n";
        my $command1 = "hostname";
        my $command2 = "date";
        my $command3 = "ls";
        my @commands = ("$command1", "$command2", "$command3");
        open FILE_OUT, ">> ./perl4.log";

        foreach my $command (@commands) {

        print FILE_OUT "$localHost\n";
        print FILE_OUT '######################################', "\n";
        print FILE_OUT "LOCALHOST $localHost Command || $command\n";
        print FILE_OUT '######################################', "\n";

        my $output = `$command`;                ## Check if output exists
        my @output = (split /\n/, $output);

                foreach my $line (@output)
                {
                        print FILE_OUT "$localHost,$command,$line\n";

                }

        }


}##end localhost_work




sub check_the_box
{

        my $hostname = $_[0];

        my $command1 = "ps -ef|grep radmin|grep dacs|grep -v grep";
        my $command2 = "date";
        my $command3 = "alias";
        my $command4 = "ls -al";

        my @commands = ("$command1", "$command2", "$command3", "$command4");

        open FILE_OUT, ">> ./perl4.log";
        print FILE_OUT "$hostname\n";

        foreach my $command (@commands) {

                print FILE_OUT '######################################', "\n";
                print FILE_OUT "$hostname Command || $command\n";
                print FILE_OUT '######################################', "\n";

                my $output = `ssh $hostname $command`;     ## Check if output exists
                my @output = (split /\n/, $output);

                foreach my $line (@output)
                {

                        print FILE_OUT "$hostname,$command,$line\n";


                }

                #print FILE_OUT "$_\n" for @output;

                #print FILE_OUT "$hostname\n";
                #print FILE_OUT "$output";

        }

        close FILE_OUT;

}##End check_the_box

sub tugz
{

        my $result = $_[0];
        my $hostname = $_[1];

        ##Tug reference
        ##my ($result, $hostname) = @_;

        ##print "$result\n";

        if ( $result == 2 )
                {
                print "$hostname is unreachable \n";
                                                                # exit 1;
                }
        elsif (  $result == 1 )
                {
                print "We can reach $hostname!\n";
                        check_the_box($hostname);
                }

}##End tugz

#
#
# Does ping test 1 pass 2 fail for all servers valid in hosts
#
sub ping_test
{
    use Net::Ping;
    my $hostname = $_[0];
    my $job = Net::Ping->new();
    if ($job-> ping($hostname)) { return 1 }  else { return 2 };              ## Return 2 if host is unreachable
    $job->close();
}
