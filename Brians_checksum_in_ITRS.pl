#! /usr/bin/perl
#
#   Author        |    Brian Daly
#   Created       |    27-Jun-2014
#   Version       |    v1.00
#   Reason        |    Extract TREP process threads to CPU bindings and interrupt bindings for Geneos
#   Operation     |    Geneos writes this script into /reuters/netprobe/trep_threading.pl and executes
#                 |    This means the script does not have to be deployed initially by a process outside of Geneos. Efficiency!


use strict;
use warnings;

main();

sub main              #  ---  Main program --- #
{

    print "Variable, Value\n";                                                   # These headings are required for Geneos

    if (`/bin/uname -s` =~ /SunOS/ ){                                            # SOLARIS server details and RRCP threading
        get_general_server_info_non_root_solaris();
        get_rrcpd_thread_details_sol();
    } else {                                                                     # Else LINUX server details and RRCP threading

    #    get_interrupt_threads();                                                 # Require root privilege
    #    get_general_server_info_root();                                          #      - achieved by adding /reuters/netprobe/trep_threading to /etc/sudoers
                                                                                  #      - execute as radmin by running "sudo /reuters/netprobe/trep_threading"


        get_general_server_info_non_root();
        get_rrcpd_thread_details();
    }


    my @procs = ('p2ps', 'src_dist', 'adh', 'ads');
    foreach my $proc ( @procs ){
        for (my $i=1; $i <= 8; $i++) {                                           # Check for up to 8 instances. NJ2 is known to run 8 instances on ADH on one server.
            if( `ps -ef |grep "$proc -instance $i" |grep -v grep` ) {
                get_thread_details($i,$proc);                                    # Pass parameters to generic get_thread_details subroutine for processing
            }
        }
    }
        if( `ps -ef |grep "dacs.stnd" |grep -v grep` ) {                                                         # Determine if dacs station is currently running on server
        get_dacs_version();
    }
        get_cnf_checksum();                                                          # Obtain the checksum of the rmds.cnf file
}                      #  --- End of Main --- #

######  --------------  General subroutines called by Main start -------------------  #######

sub get_interrupt_threads
{

my $INTERRUPTS = "/proc/interrupts";
my %CPU_NUMBER = ();
my %INTERFACE_COUNT = ();
my %seen = ();

open (FILE, "$INTERRUPTS") or die "Cannot open $INTERRUPTS file $!";
while (<FILE>)
{
    if (/^\s*?(\d+).*(eth\d+)/)
    {
        my $INTERRUPT_NUMBER = $1;
        my $IFACE_NAME = $2;
        $INTERFACE_COUNT{$IFACE_NAME}++;                                         # The number of times the i/f is reported is equal to the interrupt queues
        open (SMP_AFF, "/proc/irq/$INTERRUPT_NUMBER/smp_affinity") or die "Cannot open SMP_AFFINITY_FILE $!";

        while (<SMP_AFF>)
        {
           $_  =~ m/(\w+)$/;                                                     # Extract Hex affinity mask, e.g.:00000404
           my $hexvalue = $1;
           if ( $hexvalue eq "000000ff" || $hexvalue eq "0000ffff" || $hexvalue eq "ffffffff") {      # Trap the condition when the affinity map is not explicitly configured
               $CPU_NUMBER{$IFACE_NAME} = "All cores\n";
           }else{

               my $binvalue = sprintf( "%b", hex( $hexvalue ) );                 # Convert Hex affinity mask to binary
               my $str = reverse $binvalue;                                      # Reverse the order, because strings are searched left to right

               while ($str =~ m/1/g)
               {
                    my $CPU = pos($str) - 1 . " ";                               # Locate the position of 1's in the binary string. The 1's position equates to the CPU number
                    if ( ! $seen{$IFACE_NAME . $CPU} )                           # Ensure uniqueness before appending CPU number to hash. Otherwise one gets repeated entries
                    {
                        $CPU_NUMBER{$IFACE_NAME} .= pos($str) - 1 . "|";
                        $seen{$IFACE_NAME . $CPU} = 1;
                    }
               }
           }
       }
    close SMP_AFF;
    }
}

    foreach my $key (keys %CPU_NUMBER) {
        chop $CPU_NUMBER{$key};
#        next if $key eq "eth0";                                                  # Place holder, should we wish to ignore an interface
        print "$key,Queues:$INTERFACE_COUNT{$key};Cores:$CPU_NUMBER{$key}\n";     # Hash INTERFACE_COUNT and CPU_NUMBER use the same keys. INTERFACE_COUNT records the number of interrupt queues
    }
}

sub get_general_server_info_root
{

my $core;
my $server;

    my $HYPERTHREAD = `/sbin/hpasmcli -s "SHOW HT"`;                               # Test is hyper threading is on
    if ( $HYPERTHREAD =~ /enabled/ ){
        print "HT, on\n";
    }else { print "HT, off\n"; }


    my $SERVER_TYPE = `/sbin/hpasmcli -s "SHOW SERVER"`;                           # Determine the server type, i.e. DLxxx
    if ( $SERVER_TYPE =~ /System\s+:\s+(.+)/ ) {
        $server = $1;
    }
    if ( $SERVER_TYPE =~ /Core\s+:\s+(\d+)/ ) {
        $core = $1;
    }
    if ( $SERVER_TYPE =~ /Processor\s+total\s+:\s+(\d+)/ ){                        # Calculate the number of physical cores
        my $processors = $1;
        my $physical_cores = $core * $processors;
        print "Server Type, $server Physical Cores $physical_cores\n";
    }
}

sub get_general_server_info_non_root
{

    my $KERNEL = `/bin/uname -r`;
    print "Kernel, $KERNEL";

    my $RHEL = `/bin/cat /etc/redhat-release`;
    print "RH Release, $RHEL";

    my $HOSTNAME = `/bin/hostname`;
    print "Hostname, $HOSTNAME";
}

sub get_general_server_info_non_root_solaris
{

    my $KERNEL = `/bin/uname -r`;
    print "Kernel, $KERNEL";

    my $SOLARIS = `/bin/cat /etc/release | /bin/grep Solaris`;
    print "SunOS Release, $SOLARIS";

    my $HOSTNAME = `/bin/hostname`;
    print "Hostname, $HOSTNAME";

}


sub get_thread_details
{

my $REUTERS_BASE = "/opt/reuters";
my $RMDS_CONFIG = "$REUTERS_BASE/SOFTWARE/globalconfig/triarch.cnf";
my $instance = shift;
my $component = shift;
my $comp = uc($component);
my $mon = "$REUTERS_BASE/$component/bin/$component" . "mon";
chomp (my $HOSTNAME = `/bin/hostname`);
my $release_found = 0;

#  Normalisations
if ( $comp eq "P2PS") { $comp = "ADS"; }                                          #  Required, because Geneos has hundreds of labels for ADS. Don't want to have to recreate for P2PS
if ( $comp eq "SRC_DIST") { $comp = "ADH"; }                                      #  Ditto as above, but for src_dist
if ( $mon =~ /src_dist/ ) { $mon = "$REUTERS_BASE/mdh/bin/$component" . "mon"; }  #  Directory structure for src_dist has inconsistent naming, namely mdh


open (FILE, "$mon -c $RMDS_CONFIG -instance $instance -mobprint |") or die "Cannot run adsmon $!";      # Based on value of mon executes adsmon, p2psmon, src_distmon or adhmon

    while (<FILE>) {
        if (/^Instance: $HOSTNAME\S+(p2ps|src_dist|adh|ads)$/ .. /Children:/) {
            s/,/|/;                                                               # The values returned are comma separated whereas Geneos requires they be pipe "|" separated
            if ( /sourceThreadCpu.(\d+):\s+String:\s+(\S+)$/ ){
                print "$comp$instance ST$1, $2\n";
            }
            if ( /mainThreadBinding:\s+String:\s+(\S+)$/ ){
                print "$comp$instance MT, $1\n";
            }
            if ( /filterThreadCpu:\s+String:\s+(\S+)$/ ){
                print "$comp$instance FT, $1\n";
            }
            if ( /rrcpReadCpu:\s+String:\s+(\S+)$/ ){
                print "$comp$instance RRCP_Read, $1\n";
            }
            if ( /writeThreadCpu.(\d+):\s+String:\s+(\S+)$/ ){
                print "$comp$instance WT$1, $2\n";
            }
            if ( /itemThreadCpu.(\d+):\s+String:\s+(\S+)$/ ){
                print "$comp$instance IT$1, $2\n";
            }
            if ( /mainThreadCpu:\s+String:\s+(\S+)$/ ){
                print "$comp$instance MT, $1\n";
            }
            if ( /releaseVersion:\s+String:\s*(\S+).*/ ){                          # Only available in ADS/ADH 2.4 and later
                print "$comp$instance Version, $1\n";
                $release_found = 1;
            }
            if ( $release_found == 0 && /path:\s+String:\s*.+SOFTWARE\/(\S+tis)./ ){    #  Required to capture P2PS, src_dist and ADS/ADH upto 2.2 versions
                print "$comp$instance Version, $1\n";
            }
        }
        if (/SSLFidDatabase/ .. /Children:/) {
           if ( /fieldDictVersion:\s+String.*:\s+(\S+):/ || /fieldDictVersion:\s+String.*:\s+(\S+)/){
              print "$comp$instance RDM FD Ver, $1\n";
           }
        }
    }
}

sub get_rrcpd_thread_details
{
my @PROCESSES = ('rrcpd sink', 'rrcpd source');
my $PS = '/bin/ps -eLf';
my $GREP = '/bin/grep -w';
my $TASKSET = '/bin/taskset -pc';
my %CPU_BIND = ();
my %seen =();
    foreach my $TREP_PROCESS (@PROCESSES)
    {
        my @PIDS = `$PS |$GREP "$TREP_PROCESS" |$GREP -v grep`;                    # Loads all matching lines into array. Each line is one element
        foreach (@PIDS){
            my @THREAD_PID = split /\s+/, $_;                                      # Split each line into separate elements
            my ($CPU) = `$TASKSET "$THREAD_PID[3]"` =~ m/(\S+)$/;                  # Extract the 4th element, the child PID
            if ( ! $seen{$TREP_PROCESS}{$CPU} ){                                   # Append only unique CPU usage per unique rrcpd type, i.e. sink or source
                $CPU_BIND{$TREP_PROCESS} .= $CPU . "|";
            }
            $seen{$TREP_PROCESS}{$CPU}++;                                          # Only required for the creating unique keys. Count is not being used
        }
    }
    foreach my $keys (keys %CPU_BIND) {
        chop $CPU_BIND{$keys};                                                     # The last entry will be a pipe "|" courtesy of line 225 above. Remove it.
        if ( $keys eq "rrcpd sink" ){
            if ( $CPU_BIND{$keys} =~ m/\-/ ) {                                     # If all the cores are available, instead of RRCP being bound to specific cores,
                print "RRCP Sink, All cores\n";                                    # RHEL reports 0-15. Test for the dash
            } else {
                print "RRCP Sink, $CPU_BIND{$keys}\n";
            }
        }
        if  ( $keys eq "rrcpd source" ){
            if ( $CPU_BIND{$keys} =~ m/\-/ ) {
                print "RRCP Source, All cores\n";
            } else {
                print "RRCP Source, $CPU_BIND{$keys}\n";
            }
        }
    }
}

sub get_rrcpd_thread_details_sol
{
    if ( `/bin/ps -ef |/bin/grep "rrcpd source"`){                                  # Solaris is only used for MLIP/ADH. We do not bind RRCP on Solaris
        print "RRCP Source, All cores\n";
    }
    if ( `/bin/ps -ef |/bin/grep "rrcpd sink"`) {
        print "RRCP Sink, All cores\n";
    }
}


sub get_dacs_version
{

my $PWD = '/bin/pwd';
my $DACS_PATH = '/reuters/dacs';

    chdir ($DACS_PATH) or die "Cannot change directory to $DACS_PATH $!";
    my $DACSDIR = `$PWD`;                                                    # Extract Load ID from directory path
    my $LOAD = (split (/\//, $DACSDIR))[-1];
    print "DACS Version, $LOAD";
}

sub get_cnf_checksum
{
use POSIX;
my $REUTERS_BASE = "/opt/reuters";
my $RMDS_CONFIG = "$REUTERS_BASE/SOFTWARE/globalconfig/triarch.cnf";
my $BUILD_SERVER_CNF = "$REUTERS_BASE/SOFTWARE/config/local/rmds.cnf";

    if ( `hostname` =~ /susbd/ && -e $BUILD_SERVER_CNF){
        my ($RMDS_CNF_CHECKSUM) = `/usr/bin/sum -r "$BUILD_SERVER_CNF"`  =~ m/(^\d+)\s+/;
                my $date = POSIX::strftime("%d%m%Y",localtime( ( stat $BUILD_SERVER_CNF )[9]));
        print "RMDS CNF Checksum,       $RMDS_CNF_CHECKSUM   $date\n";
    } elsif ( -e $RMDS_CONFIG ) {
        my ($RMDS_CNF_CHECKSUM) = `/usr/bin/sum -r "$RMDS_CONFIG"` =~ m/(^\d+)\s+/;
        my $date = POSIX::strftime("%d%m%Y",localtime( ( stat $RMDS_CONFIG )[9]));
            print "RMDS CNF Checksum, $RMDS_CNF_CHECKSUM   $date\n";
        }
}
