#!/usr/bin/perl
#
#       Author  |       Flynn Gardener
#       Created |       06-June-2012
#       Reason  |       Automatic copy of any file with untar and softlinks after Security Lockdown
#       WID             |       Takes command line options to either copy files to one host or all hosts
#
#       subs    |       main_run = Main grouping of program for clarity.
#                               main_menu = Create main menu.
#                               execute_config = Parse config.
#                               expect_under_radmin = Do the work under user radmin.
#                               show_config = Show output of chosen files.
#                               file_choice = get file choice (menu).
#                               copy_files = copy files if required.
#                               host_choice = get host choice (menu).
#                               username_password = Get username and password.
#                               usage = Prints general program usage.
#                               ping_test = Pings host to see if it's live.
#                               get_time = 1 = time line, 2 = file name time, 3 = day, 4 = weekday.
#                               make_dirs = make a working directory structure for script.
#                               logging = Sets / Rolls logs.
#
#       Version |       1.00 (FG) 06-June-2012          |Start.
#                       |       1.01 (FG) 18-September-2012     |Added restart feature.
#                       |       1.02 (FG) 01-July-2013          |File deletions + extra logging.
#                       |       2.00 (FG) 03-July-2013          |Complete rewrite.
#
####

use strict;
use warnings;                                                                                           ##Only set for testing.
use lib '/reuters/perl/perl5/site_perl/5.8.4/';

make_dirs();                                                                                            ##Make dirs if required.
logging(999);                                                                                           ##Create logfile
main_run();

#Start!!
sub main_run
{

        use Getopt::Long;
        use Pod::Usage;

        my $config_area = "/reuters/SOFTWARE/config/file_distribution_area/distributionConfigs";
        my $host_area = "/reuters/SOFTWARE/config/file_distribution_area/hostFiles";

        my ($config, $hostname, $option, $help, $null);
        GetOptions('help|?' => \$help, 'config=s' => \$config, 'host=s' => \$hostname, 'option=s' => \$option);
        pod2usage(usage(1)) if $help;                                                   ##Commandline options or help|?

        if ($hostname && $config) {                                                             ##host and config set - or at least have values
                if ($hostname && -e "$config_area/$config") {

                        print "\n\n";
                        my ($name, $password) = username_password();    ##INput
                        print "\n\n";

                        if (-e "$host_area/$hostname") {
                                open HOSTS, "< $host_area/$hostname";
                                while (<HOSTS>) {
                                        chomp $_;
                                        if (ping_test($_) == 2) {
                                                print "$_ is not reachable.\n";
                                                logging (2, "ERROR: ping fail -> $_ is not reachable\n");
                                        } else {
                                                execute_config($_, "$config_area/$config", $name, $password);
                                        }
                                }
                                close HOSTS;
                        } else {
                                if (ping_test($hostname) ==  2) {
                                        print "$hostname is not reachable.\n";
                                        logging (2, "ERROR: ping fail -> $hostname is not reachable\n");
                                } else {
                                        execute_config($hostname, "$config_area/$config", $name, $password);
                                }
                        }
                } else {
                        pod2usage(usage(2));
                }
        } elsif ($hostname) {                                                                   ##Host option only

                print "\n\n";
                my ($name, $password) = username_password();            ##INput
                print "\n\n";

                if (-e "$host_area/$hostname") {
                        main_menu($null, "$host_area/$hostname", $name, $password);
                } elsif (grep /\,/, $hostname) {
                        my @hosts = (split /\,/, $hostname);
                        main_menu($null, \@hosts, $name, $password);
                } elsif (ping_test($hostname) == 1) {
                        main_menu($null, $hostname, $name, $password);
                } elsif (ping_test($hostname) == 2) {
                        print "$hostname is not reachable.\n";
                        logging (2, "ERROR: ping fail -> $hostname is not reachable\n");
                        main_menu($null, $null, $name, $password);
                }
        } elsif ($config) {                                                                             ##Config only

                print "\n\n";
                my ($name, $password) = username_password();            ##INput
                print "\n\n";

                if (-e "$config_area/$config") {
                        main_menu("$config_area/$config", $null, $name, $password);
                } else {
                        main_menu($null, $null, $name, $password);
                }
        } else {

                print "\n\n";
                my ($name, $password) = username_password();            ##INput
                print "\n\n";

                main_menu($null, $null, $name, $password);
        }

}##End main_run

##produce main_menu
sub main_menu
{

        my ($config, $hostOption, $name, $password) = @_;
        $config = "None" if !$config;
        $hostOption = "None" if !$hostOption;
        my $choice = 101010;

        until ($choice >= 10 && $choice <= 10) {                                ##Dummy loop
                system("clear");
                print "\n\n\n\tFile Copy Menu\n";
                print "\n\n\t 1) Choose configuration file.\tCurrent = $config\n";
                print "\t 2) View configuration file.\n";

                if ( ref($hostOption) ) {
                        print "\t 3) Choose a host|file|all\tCurrent = @$hostOption\n";
                } else {
                        print "\t 3) Choose a host|file|all\tCurrent = $hostOption\n";
                }
                print "\t 4) View configuration file.\n";
                print "\t 5) Run config.\n";

                print "\n\n\t99) Exit\n";
                print "\n\n\tEnter Choice ";

                chomp ($choice = <>);
                if (grep !/\d/, $choice) {
                        $choice = 10101;
                }

                if ($choice == 1) {
                        $config = file_choice(1);
                        logging (1, "INFO: Configuration file $config chosen.");
                } elsif ($choice == 2) {
                        next if (grep /none/i, $config or !$config);
                        show_config($config);
                } elsif ($choice == 3) {
                        $hostOption = host_choice();
                        logging (1, "INFO: Host option $hostOption chosen.");
                } elsif ($choice == 4) {
                        next if (grep /none/i, $hostOption or !$hostOption or !-e $hostOption);
                        show_config($hostOption);
                } elsif ($choice == 5) {
                        logging(2, "Executing configuration....");
                        if (-e $hostOption and -e $config) {
                                logging (1, "INFO: Open host file $hostOption");
                                open HOSTS, "$hostOption";
                                while (<HOSTS>) {
                                        chomp ($_);
                                        if (grep /\#/, $_) {
                                                next;
                                        }
                                        my $alive = ping_test($_);
                                        if ($alive == 2) {
                                                print "$_ is not reachable.\n";
                                                logging (2, "ERROR: ping fail -> $_ is not reachable\n");
                                        } else {
                                                logging (2, "INFO: Running config against host $_");
                                                execute_config($_, $config, $name, $password);
                                        }
                                }
                                close HOSTS;
                        } elsif ( ref($hostOption) ) {
                                        logging (2, "INFO: Running config against host @$hostOption");
                                foreach (@$hostOption) {
                                        execute_config($_, $config, $name, $password);
                                }
                        } else {
                                logging (2, "INFO: Running config against host $hostOption");
                                execute_config($hostOption, $config, $name, $password);
                        }
                } elsif ($choice == 99) {
                        logging (2, "INFO: Program Exit.");
                        exit;
                }
        }

}##End main_menu

##Parse config file for options
sub execute_config
{

        my $hostOption = $_[0];
        my $config = $_[1];
        my $name = $_[2];
        my $password = $_[3];

        my (%configFromFile);

        logging (2, "INFO: Parsing config file ");

        open CONFIG, "< $config";
        while (<CONFIG>) {
                if (grep !/\#|^$/, $_) {
                        chomp $_;
                        if (grep /\,/, $_ and grep /\|/, $_) {
                                push @{ $configFromFile {((split /\|/, $_)[0])} }, (split /\,/, ((split /\|/, $_)[1]));
                        } elsif (grep /\|/, $_) {
                                push @{ $configFromFile {((split /\|/, $_)[0])} }, (split /\|/, $_)[1];
                        } else {
                                logging (1, "ERROR: With config line $_");
                        }
                }
        }
        close CONFIG;

        #if ( @{$configFromFile{SCP}} ) {
        #       logging (2, "INFO: Copying files to remote $hostOption");
        #
        #       for ( @{$configFromFile{SCP}} ) {
        #               copy_files($hostOption, $_);
        #       }
        #}

        expect_under_radmin(\%configFromFile, $hostOption, $name, $password, 2);

}##End execute_config

# Open expect - sudo to radmin - cd /reuters/SOFTWARE - untar files
sub expect_under_radmin
{


        my %configFromFile = %{$_[0]};
        my $hostname = $_[1];
        my $name = $_[2];
        my $password = $_[3];
        my $token = $_[4];

        my $time = get_time(2);

        my @keyArrayInOrderOfProcess = qw(SCP COM LCP DEB TAR DEA LNK RST);

        logging (2, "INFO: Running expect commands");

        use Net::SSH::Expect;

        my $ssh = Net::SSH::Expect->new (
                                                host => $hostname,
                                                password=> $password,
                                                user => $name,
                                                raw_pty => 1,
                                                timeout => 2
                                                );

    # test the login output to make sure we had success
    my $login_output = $ssh->login();

        if (grep !/$hostname/, $login_output) {
                logging (2, "ERROR: Login has failed $hostname. Login output was $login_output");
                print "Login has failed $hostname. Login output was $login_output";
        }

        my $output = $ssh->exec("sudo su -\n");                 ##Change to radmin to copy file to radmin location
        $output = $ssh->exec("$password\n");

        if ($token == 1) {                                                                              ##Standard move a file

        } elsif ($token == 2) {

                foreach my $key (@keyArrayInOrderOfProcess) {
                        if (exists $configFromFile{$key}) {
                                if (grep /LCP/, $key) {                                         ##Local copy /tmp -> /..
                                        for ( @{$configFromFile{$key}} ) {
                                                my $filename = (split /\s+/, $_)[0];
                                                my $dir = (split /\s+/, $_)[1];
                                                print "Copying file $filename to $dir\n";
                                                logging (1, "INFO: Copying current file /tmp/$filename to $dir/$filename.$time\n");
                                                my $output = $ssh->exec("cp $dir/$filename $dir/$filename.$time\n");
                                                $output = $ssh->exec("cp /tmp/$filename $dir/$filename\n");

                                        }
                                } elsif (grep /DEB/, $key) {
                                        for ( @{$configFromFile{$key}} ) {              ##Delete Before Run
                                                print "Remove $_\n";
                                                logging (1, "INFO: Remove $_\n");
                                                my $output = $ssh->exec("rm -rf $_\n");
                                        }
                                } elsif (grep /COM/, $key) {
                                        for ( @{$configFromFile{$key}} ) {              ##Run commandz
                                                print "Run $_\n";
                                                logging (1, "INFO: run $_\n");
                                                my $output = $ssh->exec("$_\n");
                                        }
                                } elsif (grep /TAR/, $key) {
                                        for ( @{$configFromFile{$key}} ) {              ##untar bumpf
                                                print "Untar $_\n";
                                                logging (1, "INFO: Untar $_\n");
                                                my $output = $ssh->exec("$_\n");
                                        }
                                } elsif (grep /DEA/, $key) {
                                        for ( @{$configFromFile{$key}} ) {              ##Delete After Run
                                                if (grep /radmin/, $_) {
                                                        my $filename = (split /\:/, $_)[1];
                                                        print "Remove $filename\n";
                                                        logging (1, "INFO: Remove $filename\n");
                                                        $output = $ssh->exec("rm -rf $filename\n");
                                                }
                                        }
                                } elsif (grep /LNK/, $key) {
                                        for ( @{$configFromFile{$key}} ) {              ##Softlinks
                                                print "Softlinks $_\n";
                                                logging (1, "INFO: Softlinks $_\n");
                                                $output = $ssh->exec("$_\n");
                                        }
                                }
                        }
                }
        }

        $output = $ssh->exec("exit\n");
        logging (2, "INFO: Exit from Expect");

        undef %configFromFile;
        print "\n";

}##End expect_under_radmin

##show_config
sub show_config
{

        system("clear");
        print "\n\n";

        open FILE, "< $_[0]";
        while (<FILE>) {
                print "$_";
        }
        close FILE;

        print "\n\nAny key to return.";
        my $dummy = <>;

}##End show_config

##Choose a hosts file for a group of boxes
sub file_choice
{

        my $token = $_[0];

        if ($token == 1) {
                my @dirListing = </reuters/SOFTWARE/config/file_distribution_area/distributionConfigs/*>;
                my $choice = 10101;

                until ($choice >= 0 && $choice <= $#dirListing) {
                        system("clear");
                        print "\n\n\n";

                        for (my $loop = 0; $loop <= $#dirListing; $loop++) {
                                print "\t$loop) $dirListing[$loop]\n";
                        }

                        print "\n\t99) Back.\n";
                        print "\n\n\tEnter choice -> ";
                        chomp ($choice = <>);
                        if (grep !/\d/, $choice) {
                                $choice = 10101;
                        }

                        if ($choice >= 0 && $choice <= $#dirListing) {
                                return ($dirListing[$choice])
                        } elsif($choice == 99) {
                                return ("None");
                        }
                }

        } elsif ($token == 2) {
                my @dirListing = </reuters/SOFTWARE/config/file_distribution_area/hostFiles/*>;
                my $choice = 10101;

                until ($choice >= 0 && $choice <= $#dirListing) {
                        system("clear");
                        print "\n\n\n";

                        for (my $loop = 0; $loop <= $#dirListing; $loop++) {
                                print "\t$loop) $dirListing[$loop]\n";
                        }

                        print "\n\t99) Back.\n";
                        print "\n\n\tEnter choice -> ";
                        chomp ($choice = <>);
                        if (grep !/\d/, $choice) {
                                $choice = 10101;
                        }

                        if ($choice >= 0 && $choice <= $#dirListing) {
                                return ($dirListing[$choice])
                        } elsif($choice == 99) {
                                return ("None");
                        }
                }
        }

} ##End file_choice

## just copying files
sub copy_files
{

        my $host = $_[0];
        my $file = $_[1];
        my $file_area = "/reuters/SOFTWARE/config/file_distribution_area/files";

        print "$file_area/$file\n";
        logging (1, "INFO: Copying $file to remote $host");
        system ("scp $file_area/$file $host:/tmp");

} ##End copy_files

## choose host or all
sub host_choice
{

        my $localNodes = "/reuters/SOFTWARE/config/local.nodes";
        my $choice = 10101;
        my (@hosts);

        open HOSTS, "$localNodes";
        chomp (@hosts = <HOSTS>);
        @hosts = grep !/\#|^$|susbd/, @hosts;

        use POSIX qw(ceil);
        my $collumnCount = ceil($#hosts / 25);

        until ($choice >= 0 && $choice <= $#hosts) {
                system("clear");
                print "\n\n\n";

                for (my $loop = 0; $loop <= $#hosts; $loop = $loop + 3) {
                        if ($hosts[$loop] && $hosts[$loop+1] && $hosts[$loop+2]) {
                                print "\t$loop) $hosts[$loop]\t", $loop+1, ") $hosts[$loop+1]\t", $loop+2, ") $hosts[$loop+2]\n";
                        }elsif ($hosts[$loop] && $hosts[$loop+2]) {
                                print "\t$loop) $hosts[$loop]\t", $loop+2, ") $hosts[$loop+2]\n";
                        } else {
                        print "\t$loop) $hosts[$loop]\n";
                        }
                }

                print "\n\t97) Choose a file.\n";
                print "\n\t99) Back.\n";
                print "\n\n\tEnter choice -> ";
                chomp ($choice = <>);

                if (grep !/\d/, $choice) {
                        $choice = 10101;
                }

                if ($choice >= 0 && $choice <= $#hosts) {
                        return ($hosts[$choice])
                } elsif ($choice == 97) {
                        return (file_choice(2));
                } elsif($choice == 99) {
                        return ("None");
                }
        }

} ##End host_choice

# Get username and password to copy files and use radmin under expect
sub username_password
{

        my ($name, $password, $password2);
        my $loop = 0;

        print "Enter your login name : ";
        chomp ($name = <>);

        until ($loop == 2) {

                print "Enter your login password : ";
                system("stty -echo");                                                           ##hide input
                chomp ($password = <STDIN>);
                system("stty echo");                                                            ##Show input

                print "\nEnter password again :";
                system("stty -echo");
                chomp ($password2 = <STDIN>);
                print "\n";
                system("stty echo");

                if ($password ne $password2) {                                          ##Match passwords or try again until CTR-C
                        print "Passwords do not match. Try again.\n";
                        next;
                } else {
                        $loop = 2;
                }
        }

        return ($name, $password);

} ##End username_password

## General script information message
sub usage
{

        my $type = $_[0];

        if ($type == 1) {
                print "\n\t./copyFiles.pl \e[0;35m-> Straight to menu.\e[0;37m\n";
                print "or\n";
                print "\t./copyFiles.pl -config \"Configuration filename\" \e[0;35m-> Configuration to menu.\e[0;37m\n";
                print "or\n";
                print "\t./copyFiles.pl -host hostfile | hostname | \"hostname1,hostname2,hostname3,...\" \e[0;35m-> Hostconfig to menu.\e[0;37m\n";
                print "or\n";
                print "\t./copyFiles.pl -config \"Configuration filename\" -host hostfile | hostname | \"hostname1,hostname2,hostname3,...\" \e[0;35m-> Run no menu.\e[0;37m\n\n";
        } elsif ($type == 2) {
                print "\nGiven configuration filename does not exist! Exit.\n\n";
        }

        exit;

} ## End usage

# Does ping test 1 pass 2 fail
sub ping_test
{

        use Net::Ping;

        my $hostname = $_[0];

        my $job = Net::Ping->new();
    if ($job->ping($hostname)) { return 1 }  else { return 2 }; ##Return 2 if host is unreachable
    $job->close();

} ##End ping_test

## get time and format it
sub get_time
{

        my $timeToken = $_[0];                                                                  ## I am interested in process time or file type format.
                                                                                                                        ## 1 = time line, 2 = file name time, 3 = day, 4 = weekday.
        use POSIX qw(strftime);

        if ($timeToken == 1) {
                return (my $lineTime = strftime "%d/%m/%Y %H:%M:%S", localtime);
        } elsif ($timeToken == 2) {
                return (my $fileTime = strftime "%d-%m-%Y-%H:%M:%S", localtime);
        } elsif ($timeToken == 3) {
                return (my $day = strftime "%d", localtime);
        } elsif ($timeToken == 4) {
                return(localtime(time))[6];
        }

} ##End time

# create file area
sub make_dirs
{

        mkdir "/reuters/SOFTWARE/config/file_distribution_area" unless -d "/reuters/SOFTWARE/config/file_distribution_area";
        mkdir "/reuters/SOFTWARE/config/file_distribution_area/files" unless -d "/reuters/SOFTWARE/config/file_distribution_area/files";
        mkdir "/reuters/SOFTWARE/config/file_distribution_area/hostFiles" unless -d "/reuters/SOFTWARE/config/file_distribution_area/hostFiles";
        mkdir "/reuters/SOFTWARE/config/file_distribution_area/logs" unless -d "/reuters/SOFTWARE/config/file_distribution_area/logs";
        mkdir "/reuters/SOFTWARE/config/file_distribution_area/distributionConfigs" unless -d "/reuters/SOFTWARE/config/file_distribution_area/distributionConfigs";

} ##End make_dirs

##Setup and append logfile
sub logging
{

        my $fulltime = localtime;

        my $token = $_[0];
        my $lineForLog = $_[1];

        my $logDirectory = "./file_distribution_area/logs";
        my $filename = "file_distribution.log";

        if ($token == 1) {                                                                              ##Log Line
                open LOGOUT, ">> $logDirectory/$filename" or die $!;
                chomp ($lineForLog);
                print LOGOUT "$lineForLog\n";
                close LOGOUT;
        } elsif ($token == 2) {                                                                 ##Log Header
                open LOGOUT, ">> $logDirectory/$filename" or die $!;
                print LOGOUT "--##--\n";
                print LOGOUT "$lineForLog\n";
                print LOGOUT "--##--\n";
                close LOGOUT;
        } elsif ($token == 999) {                                                               ##New on start
                if (-e "$logDirectory/$filename") {
                        use File::Copy;
                        move("$logDirectory/$filename", "$logDirectory/$filename.old") or die $!;
                        open LOGOUT, "> $logDirectory/$filename" or die $!;
                        print LOGOUT "--##--\n";
                        print LOGOUT "Logfile created $fulltime\n";
                        print LOGOUT "--##--\n";
                        close LOGOUT;
                } else {
                        open LOGOUT, "> $logDirectory/$filename" or die $!;
                        print LOGOUT "--##--\n";
                        print LOGOUT "Logfile created $fulltime\n";
                        print LOGOUT "--##--\n";
                        close LOGOUT;
                }
        }

} ##End logging

