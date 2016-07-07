#!/usr/bin/perl
#
#	Author	|	Flynn Gardener
#	Created	|	29-November-2011
#	Reason	|	Automatic copy of rmds.cnf after Security Lockdown
#	WID		|	Takes from a control file or attribute files to copy and unpack on remote hosts under radmin user
#
#	Requires|	Net::SSH::Expect || Net::Ping || File::Copy || Getopt::Long || Pod::Usage
#
#	subs	| 	main = Main grouping of program for clarity.
#				history_file = Amend running commentary of distribution and changes.
#				username_password = Get users name and password for remote expect.
#				usage = Prints general program usage.
#				check_cnf_and_license_file = Checks cnf and license file for changes
#				copy_through_expect_under_radmin = After file is copied under cjcadmin logon and move via expect.
#				copy_files_to_host = Copy files to host/s under cjcadmin
#				check_user_name = Check whether you're running program under cjcadmin. If not exit!!
#				ping_test = Pings host to see if it's live. 
#				logging = Sets up logfile and updates
#
#	Version	|	v1.01 (Start).
#			|	V1.02 01-February-2012 	-> 	(FG) Added cnf/license option.
#			|	v1.03 06-February-2012 	-> 	(FG) Changed username and password to STDIN input.
#
#			|	v2.00 02-September-2013	-> 	(FG) Rewrite to encompass user Error on builds.
#			|	v2.01 29-September-2013	_>	(FG) Added -h host,host or -o multi -f host file.
#			|	v2.02 03-October-2013	-> 	(FG) Added timeout => 1 and sleep statements to pace ssh.
# 
###

use strict;
use warnings;

main_run();														##And we're off...

# Main sub for clarity
sub main_run {

	use Getopt::Long;
	use Pod::Usage;
	
	my ($hostname, $option, $help, $file, $site);	
	GetOptions('help|?' => \$help, 'h|host=s' => \$hostname, 'o|option=s' => \$option, 'f|file=s' => \$file, 's|site=s' => \$site);
	pod2usage(usage(1)) if $help;								##Commandline options or help|?
		
	if ($option and grep /install/i, $option) {
		check_user_name();										##Am I cjcadmin
		make_dirs_and_set_cnf_repository();						##Setup dirs
		logging(999);											##Create logfile
		exit;
	} else {
		check_user_name();										##Am I cjcadmin
		logging(999);											##Create logfile
	}
	
	$site = "local" if (not defined $site);
	
	if ($hostname) {											##Stated host run
	
		my (@hostlist);
	
		if (grep /\,/, $hostname) {
			@hostlist = (split /\,/, $hostname);
		} else {
			@hostlist = $hostname;
		}

		if ($#hostlist == 0) {									##Single host run
		
			foreach my $host (@hostlist) {
				logging (2, "COPY TYPE || Single Host copy chosen.");
				$option = "single";

				
				my $pingResult = ping_test($host);
				if ($pingResult == 2) {							##If host is unreachable die
					print "Error::$host: Ping fail $host!\n";
					logging(1, "Error::$host: Ping fail $host!");
					next;
				}
				
				my ($name, $password) = username_password();
				check_cnf_and_license_file($name, $option, $host, $site);	
				copy_files_to_host($option, $host, $name, $password, $site);
			}
		} else {
			my ($name, $password) = username_password();
			my $option = "multi";
			logging (2, "COPY TYPE || Multi Host copy chosen.");
			check_cnf_and_license_file($name, $option, $hostname, $site);
		
			foreach my $host (@hostlist) {						##Multi host run
				if ($host) {
				my $pingResult = ping_test($host);
					if ($pingResult == 2) {							##If host is unreachable die
						print "Error::$host: Ping fail $host!\n";
						logging(1, "Error::$host: Ping fail $host!");
						next;
					}
				
					copy_files_to_host($option, $host, $name, $password, $site);
				}
			}
		}
	} else {													##All hosts
		pod2usage(usage(1)) if !$option;
		pod2usage(usage(1)) if (grep !/all|cnf|license|multi/i, $option);

		my (@hosts);

		if (grep /multi/i, $option) {
			open HOSTS, "< ./$file" or die "Cannot open file $!";
			chomp (@hosts = (<HOSTS>));							##Hosts from given -f filename
			close HOSTS;
			@hosts = grep !/susbd|\#|^$/, @hosts;
		} else {
			open HOSTS, "< /reuters/SOFTWARE/config/local.nodes";
			chomp (@hosts = (<HOSTS>));							##Hosts from local.nodes
			close HOSTS;
			@hosts = grep !/susbd|\#|^$/, @hosts;
		}
		
		my ($name, $password) = username_password();			##Get username & password
		check_cnf_and_license_file($name, $option);				##Check cnf for changes
		
		foreach my $host (@hosts) {
			logging (1, "Host $host");
			print "Info::Host $host\n";
			my $pingResult = ping_test($host);					##Ping test
			if ($pingResult == 2) {
				logging (1, "Error::$host: unreachable.");
				print "Error::$host: Ping fail $host!\n";
				logging(1, "Error::$host: Ping fail $host!");
				next;											##Next loop on fail
			}
			
			copy_files_to_host($option, $host, $name, $password, $site);	##Start the copy and update run

		}
		print "\n";
	}	
	
	logging(55);	##Print out Errors
	
}##End main_run

# Open expect - sudo to radmin - cd /reuters/SOFTWARE - untar files
sub copy_through_expect_under_radmin
{

	my $option = $_[0];
	my $hostname = $_[1];
	my $name = $_[2];
	my $password = $_[3];
	
	print "Info::$hostname: Running expect commands\n";
	logging (2, "Info::$hostname: Running expect commands");

	my $hostCnf = "/reuters/SOFTWARE/globalconfig/triarch.cnf";
	my $hostLicense = "/reuters/SOFTWARE/globalconfig/TR_LICENSE";
	
	use Net::SSH::Expect;

	my $ssh = Net::SSH::Expect->new (							##New session
						host => $hostname,
						password=> $password,
						user => $name,
						raw_pty => 1,
						timeout => 1
						);
						
	$ssh->exec("stty raw -echo");
						
    # test the login output to make sure we had success
    my $login_output = $ssh->login();
	if (grep /Permission denied, please try again/, $login_output) {
		print "Error::$hostname: Login has failed $hostname. Login output was $login_output";
		next;
	} 
	
	my $output = $ssh->exec("sudo su - radmin\n");				##Change to radmin to copy file to radmin location
	if (grep /password/i, $output) {
		$output = $ssh->exec("$password\n");
	} 
	
	if (grep /all|single|multi/i, $option) {					##Copy files
		print "Info::$hostname: Moving file under radmin /tmp/triarch.cnf to /reuters/SOFTWARE/globalconfig\n";
		logging (1, "Info::$hostname: Moving file under radmin /tmp/triarch.cnf to /reuters/SOFTWARE/globalconfig\n");
		$output = $ssh->exec("cp /tmp/triarch.cnf /reuters/SOFTWARE/globalconfig\n");
		sleep 1;
		print "Info::$hostname: Moving file under radmin /tmp/TR_LICENSE to /reuters/SOFTWARE/globalconfig\n";
		logging (1, "Info::$hostname: Moving file under radmin /tmp/TR_LICENSE to /reuters/SOFTWARE/globalconfig\n");
		$output = $ssh->exec("cp /tmp/TR_LICENSE /reuters/SOFTWARE/globalconfig/TR_LICENSE\n");
		sleep 1;
		$output = $ssh->exec("exit\n");
		logging (1, "Exit from Expect");
				
		print "Info::Checking if it happened!\n";				##Checking process
		logging (1, "Checking if it happened!");
		$output = `ssh $hostname sum /tmp/triarch.cnf /reuters/SOFTWARE/globalconfig/triarch.cnf`;
		my @cnfOutput = (split /\n/, $output);
		
		if (((split /\s+/, $cnfOutput[0])[1]) != ((split /\s+/, $cnfOutput[1])[1])) {
			print "Error::$hostname: /reuters/SOFTWARE/globalconfig/triarch.cnf has not changed!\n";
			logging (1, "Error::$hostname: /reuters/SOFTWARE/globalconfig/triarch.cnf has not changed!\n");
		} else {
			print "Info::$hostname: /reuters/SOFTWARE/globalconfig/triarch.cnf updated.\n";
			logging (1, "Info::$hostname: /reuters/SOFTWARE/globalconfig/triarch.cnf updated.\n");
		}
		
		$output = `ssh $hostname sum /tmp/TR_LICENSE /reuters/SOFTWARE/globalconfig/TR_LICENSE`;
		my @TROutput = (split /\n/, $output);
		
		if (((split /\s+/, $TROutput[0])[1]) != ((split /\s+/, $TROutput[1])[1])) {
			print "Error::$hostname: /reuters/SOFTWARE/globalconfig/TR_LICENSE has not changed!\n";
			logging (1, "Error::$hostname: /reuters/SOFTWARE/globalconfig/TR_LICENSE has not changed!\n");
		} else {
			print "Info::$hostname: /reuters/SOFTWARE/globalconfig/TR_LICENSE updated.\n";
			logging (1, "Info::$hostname: /reuters/SOFTWARE/globalconfig/TR_LICENSE updated.\n");
		}

	} elsif (grep /cnf/i, $option) {
		print "Info::$hostname: Moving file under radmin /tmp/triarch.cnf to /reuters/SOFTWARE/globalconfig\n";
		logging (1, "Info::$hostname: Moving file under radmin /tmp/triarch.cnf to /reuters/SOFTWARE/globalconfig\n");
		$output = $ssh->exec("cp /tmp/triarch.cnf /reuters/SOFTWARE/globalconfig\n");
		sleep 1;
		$output = $ssh->exec("exit\n");
		logging (1, "$hostname :: Exit from Expect");
		
		print "Info::Checking if it happened!\n";
		logging (1, "Checking if it happened!");
		$output = `ssh $hostname sum /tmp/triarch.cnf /reuters/SOFTWARE/globalconfig/triarch.cnf`;
		my @cnfOutput = (split /\n/, $output);
		
		if (((split /\s+/, $cnfOutput[0])[1]) != ((split /\s+/, $cnfOutput[1])[1])) {
			print "Error::$hostname: /reuters/SOFTWARE/globalconfig/triarch.cnf has not changed!\n";
			logging (1, "Error::$hostname: /reuters/SOFTWARE/globalconfig/triarch.cnf has not changed!\n");
		} else {
			print "Info::$hostname: /reuters/SOFTWARE/globalconfig/triarch.cnf updated.\n";
			logging (1, "Info::$hostname: /reuters/SOFTWARE/globalconfig/triarch.cnf updated.\n");
		}	
		
	} elsif (grep /license/i, $option) {
		print "Info::$hostname: Moving file under radmin /tmp/TR_LICENSE to /reuters/SOFTWARE/globalconfig\n";
		logging (1, "Info::$hostname: Moving file under radmin /tmp/TR_LICENSE to /reuters/SOFTWARE/globalconfig\n");
		$output = $ssh->exec("cp /tmp/TR_LICENSE /reuters/SOFTWARE/globalconfig/TR_LICENSE\n");
		sleep 1;
		$output = $ssh->exec("exit\n");
		logging (1, "Info::$hostname: Exit from Expect");
		
		print "Info::Checking if it happened!\n";
		logging (1, "Info::Checking if it happened!");
		$output = `ssh $hostname sum /tmp/TR_LICENSE /reuters/SOFTWARE/globalconfig/TR_LICENSE`;
		
		my @TROutput = (split /\n/, $output);
		
		if (((split /\s+/, $TROutput[0])[1]) != ((split /\s+/, $TROutput[1])[1])) {
			print "Error::$hostname: /reuters/SOFTWARE/globalconfig/TR_LICENSE has not changed!\n";
			logging (1, "Error::$hostname: /reuters/SOFTWARE/globalconfig/TR_LICENSE has not changed!\n");
		} else {
			print "Info::$hostname: /reuters/SOFTWARE/globalconfig/TR_LICENSE updated.\n";
			logging (1, "Info::$hostname: /reuters/SOFTWARE/globalconfig/TR_LICENSE updated.\n");
		}
	}

	print "\n";
	
	system ("ssh $hostname rm /tmp/triarch.cnf /tmp/TR_LICENSE");
	
} ##End copy_through_expect_under_radmin

## copy_files_to_host then overwrite with radmin using expect
sub copy_files_to_host
{

	my $option = $_[0];
	my $hostname = $_[1];
	my $name = $_[2];
	my $password = $_[3];
	my $site = $_[4];
	
	my $cnf = "/reuters/SOFTWARE/config/local/rmds.cnf" if  $site =~ /local/;
	my $license = "/reuters/SOFTWARE/config/local/TR_LICENSE" if  $site =~ /local/;
	
	my $scp = "/bin/scp";
	my $ssh = "/bin/ssh";
	
	logging (2, "Copying files");
																##Either copy all files or either
	if (grep /all|single|multi/i, $option) {
		print "Info::$hostname: Copying $cnf to $hostname\n";
		logging (1, "Info::$hostname: Copying $cnf to $hostname");
		my $output = system ("$scp $cnf $hostname:/tmp/triarch.cnf");
		print $output if (grep /password/i, $output);
		print "Info::$hostname: Copying $license to $hostname\n";
		logging (1, "Info::$hostname: Copying $license to $hostname");
		$output = system ("$scp $license $hostname:/tmp/TR_LICENSE");
		print $output if (grep /password/i, $output);
	} elsif (grep /cnf/i, $option) {
		print "Info::$hostname: Copying $cnf to $hostname\n";
		logging (1, "Info::$hostname: Copying $cnf to $hostname");
		my $output = system ("$scp $cnf $hostname:/tmp/triarch.cnf");
		print $output if (grep /password/i, $output);
	} elsif (grep /license/i, $option) {
		print "Info::$hostname: Copying $license to $hostname\n";
		logging (1, "Info::$hostname: Copying $license to $hostname");
		my $output = system ("$scp $license $hostname:/tmp/TR_LICENSE");
		print $output if (grep /password/i, $output);
	}
	
	copy_through_expect_under_radmin($option, $hostname, $name, $password);

} ##End copy_files_to_host

# Update to history log
sub history_file
{

	my $name = "\($_[0]\)";								##From user input
	my $comment = $_[1];								##From user input

	use POSIX qw(strftime);
	my $dmy = strftime "%d%m%Y", localtime;				##Manage date string
	
	my $historyFile = "/reuters/SOFTWARE/config/cnf_ditribution_file_area/distribution_history";
	my $secondFile = "/reuters/SOFTWARE/config/cnf_ditribution_file_area/.profile";
		
	open HISTORY, "< $historyFile";						##Open previous for Information
	chomp (my @history = (<HISTORY>));		
	@history = grep !/^$/, @history;
	close HISTORY;
	
	my $distNumber = (split /\s+/, $history[$#history])[0];
	$distNumber = int $distNumber+1;
	$distNumber = sprintf("%04d", $distNumber);			##Increase distribution number

	my $line = join "\t", $distNumber, $dmy, $name, $comment;
	open HISTORY, ">> $historyFile";					##Update history
	print HISTORY "$line\n";
	close HISTORY;
	open HISTORY2, ">> $secondFile";
	print HISTORY2 "$line\n";
	close HISTORY2;

} ##End history_file

# Check the cnf and TR_LICENSE for changes
sub check_cnf_and_license_file
{

	my $name = $_[0];
	my $option = $_[1];
	my $hostname = $_[2];
	my $site = $_[3];
	
	logging (2, "CNF Checking");

	my $rmds_cnf = "/reuters/SOFTWARE/config/local/rmds.cnf";
	my $gold_rmds_cnf = "/reuters/SOFTWARE/config/cnf_ditribution_file_area/repository/rmds.cnf.GOLD";
	my $copy_rmds_cnf = "/reuters/SOFTWARE/config/cnf_ditribution_file_area/repository/rmds.cnf";
	
	my (@duplications, @current_rmds_array, @gold_rmds_array);
	my ($reason);

	{
		local $/;	## slurp whole file
														##Open GOLD and rmds.cnf
		open CURRENT_RMDS_CNF, "< $rmds_cnf" or die logging (1, $!);
		open GOLD_RMDS_CNF, "< $gold_rmds_cnf" or die logging (1, $!);	
		@current_rmds_array = split /\n/, <CURRENT_RMDS_CNF>;
		@gold_rmds_array = split /\n/, <GOLD_RMDS_CNF>;
		close CURRENT_RMDS_CNF;
		close GOLD_RMDS_CNF;
	}
	
    my %counts = ();
    for (@current_rmds_array) {
       $counts{$_}++;
    }
	
    foreach my $keys (keys %counts) {					##Work out duplications minus rubbish lines
		if ($counts{$keys} > 1) {
			if (grep !/\\|SEC_ACT_4,SEC_ACT_5,DEALT_VL1,VOL_X_PRC1,WEIGHTING/, $keys) {
				push (@duplications, $keys);
			}
		}
    }
														##Compare files against each other
	my %hash_of_gold_rmds = map { $_ => 1 } @gold_rmds_array;
	my %hash_of_current_rmds = map { $_ => 1 } @current_rmds_array;
	my @plusRmds = grep { !defined $hash_of_gold_rmds{$_} } @current_rmds_array;
	my @plusGold = grep { !defined $hash_of_current_rmds{$_} } @gold_rmds_array;
	
	if (@plusRmds || @plusGold || @duplications) {		##Work on input $var invoked or NULL
		if (@duplications) {
			@duplications = grep !/^$/, @duplications;
			print "\nError::Warning there are duplications in rmds.cnf\n";
			logging (1, "Warning there are duplications in rmds.cnf");
	
			for (@duplications) {
				logging (1, "DUPLICATION || $_");
				print "Error::DUPLICATION || $_\n";
			}
			print "\n";
		} 
		if (@plusRmds || @plusGold) {
			if (@plusRmds) {
				print "Info::additions have been seen.\n";
				for (@plusRmds) {
					print "$_\n";
				}
				print "\n\n";
			}
			if (@plusGold) {
				print "Info::deletions have been seen.\n";
				for (@plusGold) {
					print "$_\n";
				}
				print "\n\n";
			}
			
			print "rmds.cnf has changed. Do you wish to copy to Gold? [Y/N] : ";
			chomp (my $choice = <>);							##Comment goes to history file
			print "Please comment on the reason.\n";
			print "Comment : ";
			chomp ($reason = <>);
			until ($reason) {
				print "Comment : ";
				chomp ($reason = <>);
			}
			
			if ($hostname) {									##If single pass hostname
				history_file ($name, "$reason $hostname");
			} else {
				history_file ($name, $reason);
			}

			if (grep /^y$/i, $choice) {
				use File::Copy;									##Copy over Gold with current
				use POSIX qw(strftime);							
				my $fileTime = strftime("%H:%M-%d-%m-%Y", localtime);
				
				my $cnf_changes = "/reuters/SOFTWARE/config/cnf_ditribution_file_area/cnf_changes/cnfChanges-$fileTime";
				
				print "Info::copying file over to rmds.cnf.GOLD\n";
				copy ($gold_rmds_cnf, "$copy_rmds_cnf-$fileTime") or die logging (1, $!);
				copy ($rmds_cnf, $gold_rmds_cnf) or die logging (1, $!);
				
				open CHANGES, "> $cnf_changes";
				
				if (@plusRmds) {
					for (@plusRmds) {
						print CHANGES "ADDITIONS || $_\n";
					}
				}
				if (@plusGold) {
					for (@plusGold) {
						print CHANGES "DELETIONS || $_\n";
					}
				}
				close CHANGES;
	
			} else {
				print "No copying\n";
				exit;
			}
		}				
	} 
	
	if (!@plusRmds && !@plusGold && @duplications) {					##Distribute with no changes
		print "No change was detected in the rmds.cnf. Although the following duplications have been found\n";
		for (@duplications) {
			print "$_\n";
		}
		print "\n";
		print "Do you still want to distribute the bad cnf? [y/n] : ";	
		chomp (my $choice = <>);
		print "\n";
		if ($hostname) {
			history_file ($name, "Distributed $option $hostname");
		} else {
			history_file ($name, "Distributed $option");
		}
		
		
		if (grep !/^y$/i, $choice) {
			exit;
		}
		
	} elsif (!@plusRmds && !@plusGold) {								##Distribute with no changes
		print "No change was detected in the rmds.cnf Do you\n";
		print "still want to distribute the configuration? [y/n] : ";
		chomp (my $choice = <>);
		print "\n";
		if ($hostname) {

			history_file ($name, "Distributed $option $hostname");
		} else {
			history_file ($name, "Distributed $option");
		}
		
		if (grep !/^y$/i, $choice) {
			exit;
		}
	} 
	
} ##End check_cnf_and_license_file

# Get username and password to copy files and use radmin under expect
sub username_password
{

	my ($name, $password, $password2);
	my $loop = 0;
	
	print "Enter your login name : ";
	chomp ($name = <>);
		
	until ($loop == 1) {
		
		print "Enter your login password : ";
		system("stty -echo");							##hide input
		chomp ($password = <STDIN>);
		system("stty echo");							##Show input
		
		print "\nEnter password again : ";
		system("stty -echo");
		chomp ($password2 = <STDIN>);
		print "\n";
		system("stty echo");
		
		if ($password ne $password2) {					##Match passwords or try again until CTR-C
			print "Passwords do not match. Try again.\n";
			next;
		} else {
			$loop =1;
		}
	}

	return ($name, $password);

} ##End username_password

## General script Information message
sub usage
{

	my $type = $_[0];

	if ($type == 1) {
		print "\nYou have not chosen an option. Please choose -option \"all|cnf|license\"\n";
		print "\n\t./distributeConfig.pl -option \"all|cnf|license\" for all hosts from the local.nodes file\n";
		print "\nor\n";
		print "\n\t./distributeConfig.pl -host hostname|hostname,hostname,... -- Single hostname or multiple to copy rmds.cnf and TR_LICENSE files.\n";
		#print "\nor\n";
		#print "\n\t./distributeConfig.pl -option install -- New build. Install directory structure and pertinent files.\n\n";
	}
	
	exit;
		
} ## End usage

# create file area
sub make_dirs_and_set_cnf_repository
{

	my $mainDir = "/reuters/SOFTWARE/config/testing/cnf_ditribution_file_area";
	
	if (! -d $mainDir) {
		mkdir $mainDir or die $!;
		chmod 0776, $mainDir;
	}
	
	if (! -d "$mainDir/cnf_changes") {
		mkdir "$mainDir/cnf_changes" or die $!;
		chmod 0776, "$mainDir/cnf_changes";
	}
	
	if (! -d "$mainDir/logs") {
		mkdir "$mainDir/logs" or die $!;
		chmod 0776, "$mainDir/logs";
	}
	
	if (! -d "$mainDir/repository") {
		mkdir "$mainDir/repository" or die $!;
		chmod 0776, "$mainDir/repository";
	}

	if (! -e "$mainDir/distribution_history") {
		open FILE, "> $mainDir/distribution_history";
		print FILE "0001    01022011        (fgardene)      Start\n";
		close FILE;
		chmod 0666, "$mainDir/distribution_history";
	}
	
	use File::Copy;
	copy ("/reuters/SOFTWARE/config/local/rmds.cnf", "$mainDir/repository/rmds.cnf.GOLD");
	chmod 0666, "$mainDir/repository/rmds.cnf.GOLD";
	copy ("/reuters/SOFTWARE/config/local/rmds.cnf", "$mainDir/repository/rmds.cnf");
	chmod 0666, "$mainDir/repository/rmds.cnf";
	
} ##End make_dirs

## check you're under the right user
sub check_user_name
{

	chomp (my $username = `/usr/ucb/whoami`);
	
	if (grep !/cjcadmin/, $username) {							##Run script as cjcadmin for scp
		logging (2, "You are logged in as $username and not cjcadmin. Exiting.");
		print "\n\tError::You are logged in as $username and not cjcadmin. Exiting!\n\n";
		exit;
	}

} ##End check_user_name

# Does ping test 1 pass 2 fail
sub ping_test
{

	use Net::Ping;
	
	my $hostname = $_[0];
							
	my $job = Net::Ping->new();
    if ($job->ping($hostname)) { return 1 }  else { return 2 };	##Return 2 if host is unreachable
    $job->close();
	
} ##End ping_test

##Setup and append logfile
sub logging
{

	my $fulltime = localtime;
	
	my $token = $_[0];
	my $lineForLog = $_[1];

	my $logDirectory = "./cnf_ditribution_file_area/logs";
	my $filename = "cnf_distribution.log";
	
	if ($token == 1) {										##Log Line
		open LOGOUT, ">> $logDirectory/$filename" or die $!;
		chomp ($lineForLog);
		print LOGOUT "$lineForLog\n";
		close LOGOUT;
	} elsif ($token == 2) {									##Log Header
		open LOGOUT, ">> $logDirectory/$filename" or die $!;
		print LOGOUT "--##--\n";
		print LOGOUT "$lineForLog\n";
		print LOGOUT "--##--\n";
		close LOGOUT;
	} elsif ($token == 999) {								##New on start
		unlink "$logDirectory/errors.log";
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
	} elsif ($token == 55) {								##Print Errors at end.
		
		open LOG_FILE, "< $logDirectory/$filename";
		
		my $count = 0;
		
		
		while (<LOG_FILE>) {
			if (grep /Error/i, $_) {
				open ERROR_FILE, "> $logDirectory/errors.log";
				if ($count == 0) {
					print "Printing Error's\n";
					print "Possible reasons. Drive full. Host permission failures. cjcadmin does not exist on far host for auto login.\n\n";
					$count++;
					print "$_";
					print ERROR_FILE "$_";
				} else {
					print "$_";
					print ERROR_FILE "$_";
				}
			}
		}
	}
	
} ##End logging