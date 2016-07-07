
#! /usr/bin/perl

#   Author     |    Brian Daly
#   Created    |    27 November 2015
#   Reason     |    Modify rmds.cnf configuration in preparation for setting the aggregateItemLimit from DACS
#   Goal       |    Remove specific itemLimit and itemLimitPerMount entries from rmds.cnf and replace them with a general entry
#              |    For example:
#              |        trhlo4slsp01a02*ads*itemLimit : 500000
#              |        trhlo4slsp01a02*ads*itemLimitPerMount : 500000
#   Version    |    v1.00
#   Use        |    ./convert_itemLimit_entries_for_dacs_migration.pl



use strict;
use warnings;

# ---------------------------------------------- MAIN --------------------------------------------------- #

# Convert itemLimit entries
convert_item_limits();

# -------------------------------------------- MAIN END ------------------------------------------------- #


sub convert_item_limits
{

    #  Open the rmds configuration file triarch.cnf
    open ( my $rmds_cnf, '<', "/reuters/SOFTWARE/config/local/rmds.cnf" ) or die "cannot open file: $!";
    open ( my $rmds_cnf_new, '>', "./new_rmds.cnf" ) or die "cannot open file: $!";

    #  Create array with known servers to target
    my @ads_servers_to_modify =  (
        'trhlo4slsp01a02', 'trhlo4slsp01b02', 'trhlo4slsp02a02', 'trhlo4slsp02b02',    # Shared Cell 02
        'trhlo4slsp04a02', 'trhlo4slsp04b02', 'trhlo4sldp01b32', 'trhlo4sldp01a32',    # Shared Cell 02
        'trhlo4slsp03a03', 'trhlo4slsp03b03', 'trhlo4slsp04a03', 'trhlo4slsp04b03',    # VPN Cell 03
        'trhlo4sldp01a09', 'trhlo4sldp01b09',                                          # ITG Cell 09
        'trhlo4slsp01a15', 'trhlo4slsp01b15',                                          # TRMER Cell 15
        'trhlo4sldp01a16', 'trhlo4sldp01b16',                                          # Reuters.com Cell 16
        'trhlo4slsp01a17', 'trhlo4slsp01b17',                                          # Fusion Media Cell 17
        'trhlo4sldp01a13', 'trhlo4sldp01b13',                                          # POC Cell 13. Has LO4 style itemLimit users configured

        'trhlo1slsd01a02', 'trhlo1slsp01a02', 'trhlo1slsp01b02', 'trhlo1slsp02a02',    # Shared Cell 02
        'trhlo1slsp02b02', 'trhlo1slsp03a02', 'trhlo1slsp03b02', 'trhlo1slsp01a32',    # Shared Cell 02
        'trhlo1slsp01b32',                                                             # Shared Cell 02
        'trhlo1slsp03a03', 'trhlo1slsp03b03',                                          # VPN Cell 03
        'trhlo1sldp01a06', 'trhlo1sldp01b06',                                          # Liquid Net Cell 06
        'trhlo1sldp01a10', 'trhlo1sldp01b10',                                          # BATS Cell 10
        'trhlo1slsp01a14', 'trhlo1slsp01b14',                                          # POC Cell 14
        'trhlo1sldp01a20', 'trhlo1sldp01b20',                                          # FTEN Cell 20

        'trhlo2slsp01a02', 'trhlo2slsp01b02',                                          # Shared Cell 02
        'trhlo2slsp03a02', 'trhlo2slsp03b02',                                          # Shared Cell 02
        'trhlo2slsp01a04', 'trhlo2slsp01b04',                                          # ITG Cell 04
        'trhlo2sldp01a07', 'trhlo2sldp01b07',                                          # BATS Cell 07

        'trhfr4slsd01a02', 'trhfr4slsp01a02', 'trhfr4slsp01b02', 'trhfr4slsp02a02',    # Shared Cell 02
        'trhfr4slsp02b02', 'trhfr4slsp03a02', 'trhfr4slsp04a02', 'trhfr4slsp05a02',    # Shared Cell 02
        'trhfr4slsp05b02', 'trhfr4slsp01a32', 'trhfr4slsp01b32',                       # Shared Cell 02
        'trhfr4slsd01a03', 'trhfr4slsp02a03', 'trhfr4slsp02b03',                       # VPN Cell 03
        'trhfr4slsd01a04', 'trhfr4slsp01a04', 'trhfr4slsp01b04',                       # VOR Cell 04
        'trhfr4sldp01a11', 'trhfr4sldp01b11',                                          # ICCREA Cell 11

        'trhfr5slsp01b32', 'trhfr5slsp03b02', 'trhfr5slsp04b02', 'trhfr5slsp06b02'     # Shared Cell 02
        );

    #  Loop through the triarch.cnf configuration file
    #  Loop through the triarch.cnf configuration file
	
	
    while ( <$rmds_cnf> ) {
        chomp;

        for my $ads ( @ads_servers_to_modify ) {

            # Match the specific CSLN based itemLimit and itemLimitPerMount
            # For example, trhlo4slsp04b03*ads*LO4_03_RHB_FR13111*itemLimit : 250
            #              trhlo4slsp04b03*ads*LO4_03_RHB_FR13111*itemLimitPerMount : 250

            if ( /$ads/ and /(itemLimit|itemLimitPerMount)/ and /(LO4|LO2|LO1|FR4|FR5)/ and ! /hEDD/) {
                # Use substitution to mark the entries which must be removed
                 s/ : \d+/ : Got_to_go/;

            }

           # Remove superfluous radmin and rmdsTest entries.
           # Only for the specific servers, because one needs to reload the configuration to test. Change $ads to simply ads to do all.
           if ( /$ads/ and /(itemLimit|itemLimitPerMount)/ and /(radmin|rmdsTest)/ ) {
               s/ : \d+/ : Got_to_go/;
           }


           # Remove second instance entries. They are no longer required.
           #if ( /$ads(\.|\*)2/ and /(itemLimit|itemLimitPerMount)/ ) {
           #    s/ : \d+/ : Got_to_go/;
           #}



           # Alter the general itemLimit and itemLimitPerMount settings
           if ( /$ads\*ads\*itemLimit/ || /$ads\*ads\*itemLimitPerMount/ ) {

               # Use substitution to set the default itemLimit and itemLimit per ads to 500000 as agreed with Thomson Reuters
               s/ : \d+/ : 500000/;

           }

           # Remove aggregate item limit where explicitly set against a server
           # Danger! Some cells such as Cell 16 and 17 do not have this set against the subscribing ID. That is, they have this set generally
           #if ( /$ads\*ads\*aggregateItemLimit/ ) {
           #    s/ : \d+/ : Got_to_go/;
           #}

          # Remove specific servers which have already been decommissioned
#          if ( /^trhlo4slsp03b02|^trhlo4slsp03a02/ ) {
#             s/ : \S+/ : Got_to_go/;
#          }

        }

        #  Removal of lines is achieved by simply not printing them
        #  Print all lines that do not meet the criteria below, i.e. the rest of the triarch.cnf
        print $rmds_cnf_new "$_\n" unless ( /Got_to_go/ );

    }

    print "\n\tPlease replace the rmds.cnf at /reuters/SOFTWARE/config/local with the file generated by this script, ./new_rmds.cnf\n\n";

}
