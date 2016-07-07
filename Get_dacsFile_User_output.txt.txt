#!/usr/bin/perl

#   Author        |    Brian Daly
#   Created       |    5-Dec-2014 (based on an idea by Tug Ozbay)
#   Version       |    v1.01
#   Reason        |    Provide a view of the login Id and corresponding name of the users defined in DACS.
#                 |    See Geneos UI DACS Tab -- DACS USERS

use strict;
use warnings;

# Include Perl DB libraries
use Sybase::DBlib;

# Set location of interfaces file
$ENV{"SYBASE"} = "/reuters/sybase";

# Declare variables
my (@data, %LoginNames);

# Print header
print "DACS Login Id, Username\n";

# Main
&discoverLoginsAndUsers;

foreach my $key (sort keys %LoginNames) {
    if ( $key =~ /^(BZ|CH|FR|HK|KO|LO|MB|MX|NJ|SG|SH|SY|TK|TM|TW|TY)/ ) {
        print "$key: $LoginNames{$key}\n";
    }
}

sub discoverLoginsAndUsers
{
        my $dbh = new Sybase::DBlib 'dacs_system','rhsrhs';
        $dbh->dbuse("dacs_main");
        $dbh->dbcmd("select a.login, a.name from dacsUser a");
        $dbh->dbsqlexec;
        $dbh->dbresults;
        while (@data = $dbh->dbnextrow)
        {
            $LoginNames{$data[0]} = $data[1];
        }
}
