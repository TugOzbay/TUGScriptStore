#!/reuters/perl/bin/perl
# Version 1.0 Initial Version Paul Tomblin CJC Ltd
# Version 1.1 Added DACS 6.1 versus DACS 6.2 distribution change using permie
# Version 1.2 Added additional checks to ensure we adhere to EH standards
# Version 1.3 Added code to work around exceptions to the RHS rules
# Version 1.4 Added code to check map collect has been committed
# Version 1.5 Adpated script to take account of new 4 part client names, plus alert level change for 80% subscription
# Version 1.6 (FG) Added IDN and DIRECTFEED only test to stop profiles expending out of control.
# Version 1.7 (FG) Changed radmin to radmind for DELAYFEEDS
# Version 1.8 (DW) Changed DELAYFEEDS to DELAYFEED
# Version 1.9 (BD) Found bug where all permissionings were being set against radmind. Fixed by replacing $service with $vendorService at line 93
# Version 1.9 (FG) Added "$status = $dbh->dbcancel;" which fixes some odd DB behaviour since 6.6 install.

# Include sybperl and time
use Sybase::DBlib;
use Time::Local;

$dbDate = &getDateTime("dbl");
$now = &getDateTime();
$ENV{"SYBASE"} = "/opt/reuters/sybase";
$Interfaces = "/opt/reuters/sybase/interfaces";
$reportFile = "./fullyPerm_radmind_User.log";
$distFile = "./permie.distfile";
$exceptionsFile = "./trhsRulesExceptions.csv";
$dacsPassword = "C0mcAdm1n";
$autoDistribute="False";
$host=`hostname`;
chomp($host);
my ($exemptFromNumAccessesRef, $exemptFromPermsetRef)=&parseExceptionsFile($exceptionsFile);
@exemptFromNumAccesses=@$exemptFromNumAccessesRef;
@exemptFromPermset=@$exemptFromPermsetRef;
pp ("INFO: the logins exempt from the number of access positions test are @exemptFromNumAccesses\n");
pp ("INFO: the multi-user logins exempt from permsets permissioning test are @exemptFromPermset\n");
# Main program begins

open (REPORT,">>$reportFile");

$dbh = new Sybase::DBlib 'dacs_system','rhsrhs', 'DACS';
$version=&getDACSversion;

my(@vendorServices)=&wrapVendorService;

pp ("INFO: Script Starting at $dbDate on host $host\n");

# Lets check to see if radmind user exists!

if (!(&findUserRecord("TRHS","radmind") == 1))
{
   pp ("WARNING: User radmind does not have a valid DACS account on site TRHS\n");
   #next;
   exit 0;
}


pp ("INFO: User radmind has a valid DACS account checking permissions ...\n");

foreach $vendorService (@vendorServices)
{

        if ( grep /^DELAYFEED$/, $vendorService)
        {

                $vendorPermed=&findServiceRecord($vendorService);
                if ($vendorPermed == 0)
                {
                        pp("ADDITION:Permissioning radmind for $vendorService on $host at $dbDate\n");
                        &activateUserService("TRHS","radmind",$vendorService,$dbDate);
                        $autoDistribute="True";
                }
                else
                {
                        pp("INFO:radmind user already permissioned for $vendorService on $host\n");
                }
        }
}



my(@siteAes)=&wrapSiteAE;
foreach $siteAEarray (@siteAes)
{
   my ($ref) = $siteAEarray;
   $aeId = @$ref[0];
   $aeName = @$ref[1];
   $service = @$ref[2];
   #print "Working with id $aeId ae $aeName and service $service\n";
   $aePermed=&findAERecord("TRHS","radmind",$aeId);


        foreach $vendorService (@vendorServices)
        {

           if ( grep/^DELAYFEED$/, $vendorService)
           {
              if ($aePermed == 0)
              {
                     pp("ADDITION:Permissioning radmind for ae $aeName from service $vendorService on $host at $dbDate\n");
                     &activateUserAE("TRHS","radmind",$aeId,$vendorService,$aeName,$dbDate);
                     $autoDistribute="True";
              }
              else
              {
                     pp("INFO:radmind user already permissioned for ae $aeName from $vendorService on $host\n");
              }
           }
        }
}




if ($autoDistribute eq "True")
{
   pp("INFO: Distributing permissioning information for host $host at $dbDate\n");
   open (DISTFILE,">$distFile");
   # We must create a different distFile depending upon version of DACS
   if ($version eq "DACS60")
   {
      print DISTFILE ("AUTODENY:false:\n");
      print DISTFILE ("DISTRIBUTE:true:");
      close DISTFILE;
      $PERMSUCCESS=`. /reuters/dacs/config/dacs.env;/reuters/dacs/bin/permie -i $distFile -s TRHS -U reuter -P $dacsPassword`;
      $PERMSUCCESS=`echo $?`;
   }
   else
   {
      if ($version eq "DACS62")
      {
         print DISTFILE ("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
         print DISTFILE ("<permission xmlns=\"http://www.thomsonreuters.com/dacs/permission\">\n");
         print DISTFILE ("        <site siteType=\"PHYSICAL\">\n");
         print DISTFILE ("                <siteName>TRHS</siteName>\n");
         print DISTFILE ("                <distribution>\n");
         print DISTFILE ("                        <loadName>DACS-RADMIN-SYNCH</loadName>\n");
         print DISTFILE ("                        <dacsDistributionType>FULL</dacsDistributionType>\n");
         print DISTFILE ("                </distribution>\n");
         print DISTFILE ("        </site>\n");
         print DISTFILE ("</permission>\n");
         close DISTFILE;
         $PERMSUCCESS=`. /reuters/dacs/config/dacs.env;java -jar /reuters/dacs/bin/PermieJ.jar -i $distFile -o /reuters/logs/dacs/permie.log -U reuter -P $dacsPassword`;
         $PERMSUCCESS=`echo $?`;
      }
   }
   chomp($PERMSUCCESS);
   if ( $PERMSUCCESS == 0 )
   {
      pp ("INFO: Permission distribution successful on $host at $dbDate\n");
   }
   else
   {
      pp ("ERROR: $PERMSUCCESS Failed to distribute changes to  $host please check ........... \n");
   }
   `rm $distFile`;
}
else
{
   pp("INFO: No changes on $host no need to distribute\n");
}

# Additional Checks to ensure we conform to EH standards
# First lets find out some information so we can determine what tests to run.

# Check to see if cell is basic or platform, check old and new standards of customer name
# e.g. LO4-Cell05-UK12345 or LO4-Cell05-TRHP-UK12345

$targetType="";
my($customer)=&getCustomer;
#($locCode,$CellNo,$subScribNum)=split('-',$customer);
(@customerArray)=split('-',$customer);
$locCode=@customerArray[0];
$CellNo=@customerArray[1];
$subScribNum=@customerArray[2];
$customerArraySize=(scalar @customerArray);
if ( $customerArraySize == 4)
{
   $subScribNum=@customerArray[3];
}

if (!($subScribNum =~ m/^[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9]$/))
{
   if (($subScribNum eq "Core") || ($subScribNum eq "CORE") || ($subScribNum eq "core"))
   {
      $targetType="C";
      pp("INFO: This is a core cell\n");
   }
   else
   {
      $targetType="B";
      pp("INFO: This is a shared cell so a basic client\n");
   }
}
else
{
   my(@users)=&wrapUsers;
   foreach $uref (@users)
   {
      $site = @$uref[0];
      $login = @$uref[1];
      $name = @$uref[2];
      #pp ("INFO: Testing user $login for RHB style syntax on platform cell\n");
      if ( $login =~ m/[A-Z][A-Z][0-9]_\d+_(\w+)_[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9]/ )
      {
         $type=$1;
         if (!($type eq "RHP"))
         {
            pp("INFO: This is a dedicated cell but is a basic client\n");
            $targetType="B";
         }
      }
   }
}
if (!(($targetType eq "B") || ($targetType eq "C")))
{
   $targetType="P";
   pp("INFO: This is a platform client\n");
}

pp("INFO: Cell is of type $targetType, on site $locCode, cell $CellNo and subscriber details $subScribNum\n");


################################################################################
# Check the permissioning of RWFTEST1 and alert if permissioned.
@rwftestUsers=&getRWFTESTusers("TRHS","RWFTEST1","MFTEST1");
foreach $testUser (@rwftestUsers)
{
   pp("ERROR: NON SYSTEM User $testUser is permissioned for either RWFTEST1 or MFTEST1 please deactivate\n");
}

################################################################################
# Check when the last map collect was done
$mapCollectDate=&getMapCollectDate;
#print "Date of map collect is $mapCollectDate\n";
$epochTime=&getTimeAsEpoch($mapCollectDate);
$time = time();
if (($time - $epochTime) > 2419200)
{
   pp("ERROR: Current map  collect may be out of date, latest revision is $mapCollectDate\n");
}
else
{
  pp("INFO: Map collect is current, latest revision is $mapCollectDate\n");
}
##############################################################################
# Check whether map collect has been committed
@pendingflag=&getPendingFlag;
$newmap=&getNewMapCollectDate;
if (($pendingflag[0] == 0) && ($pendingflag[1] == 0) && ($pendingflag[2] == 0) && ($pendingflag[3] == 0))
{
 pp("INFO: New map collect revision $newmap has been committed\n");
}
else
{
pp("ERROR: New map collect revision $newmap has not been committed\n");
}

################################################################################
# Check that the client name adheres to the EH standards and client name field is populated.
if (!($locCode =~ m/^[A-Z][A-Z][A-Z0-9]$/))
{
   pp("ERROR: The site code $locCode in the client name doesn't adhere to EH standards, for example LO4, NJ2 or HK8\n");
}
if (!($CellNo =~ m/^Cell[0-9]\d+$/))
{
   pp("ERROR: The cell number $CellNo in the client name doesn't adhere to EH standards, for example Cell04, Cell16\n");
}

################################################################################
# Check that Basic cell clients have the name field populated
if ( $targetType eq "B" )
{
   my(@users)=&wrapUsers;
   foreach $uref (@users)
   {
      $site = @$uref[0];
      $login = @$uref[1];
      $name = @$uref[2];
      #print ("INFO: Testing user $login with name XXX${name}XXX\n");
      if ( $name =~ m/^\s*$/)
      {
         pp("ERROR: The user $login doesn't have the Name field populated in the user details for a shared cell user in DACS. This doesn't adhere to EH standards\n");
      }
   }
}

################################################################################
# Check for Basic style username in use on a platform client
# This code is currently not used as we use this test to determine is client is Basic or Platform. If we can reliably detect the cell type another way we could re-instate.

#if ( $targetType eq "P" )
#{
   #my(@users)=&wrapUsers;
   #foreach $uref (@users)
   #{
      #$site = @$uref[0];
      #$login = @$uref[1];
      #$name = @$uref[2];
      #print ("INFO: Testing user $login for RHB style syntax on platform cell\n");
      #if ( $login =~ m/[A-Z][A-Z][0-9]_\d+_\w+_[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9]/ )
      #{
         #pp("ERROR: This is a platform client but there is a basic style user $login active in DACS\n");
      #}
   #}
#}

################################################################################
# Check that the clients with multiple ids have permsets
if ( $targetType eq "B" )
{
   my(@users)=&wrapUsers;
   my(%userLoginHash);
   foreach $uref (@users)
   {
      $site = @$uref[0];
      $login = @$uref[1];
      $name = @$uref[2];
      ($locCode,$cellNo,$type,$subCode,$instance)=split("_",$login);
      $userLogin=$locCode."_".$cellNo."_".$type."_".$subCode;
      my $newUser = 1;
      if (( $instance =~ m/\d+/) && (!( $type eq "VOR")))
      {
         # User may have multiple instances
         #print ("$login has multiple instances $instance\n");
         foreach $USER (keys %userLoginHash)
         {
            if (!($USER eq $userLogin))
            {
               $newUser = 1;
            }
            else
            {
               $newUser = 0;
               last;
            }
         }
         if ($newUser == 1)
         {
            my (@logins);
            #$userLoginHash{$userLogin} = \@logins;
            my $arrayRef =  $userLoginHash{$userLogin};
            push (@$arrayRef,$login);
            $userLoginHash{$userLogin}[0] = $login;
         }
         else
         {
            my $arrayRef =  $userLoginHash{$userLogin};
            push (@$arrayRef,$login);
         }
      }
   }
   foreach $entry (keys %userLoginHash)
   {
      my ($ref) = $userLoginHash{$entry};
      #print "Multiple instance user $entry and ref $ref and $userLoginHash{$entry}\n";
      foreach $userInstance (@$ref)
      {
         # Check if user is exempt
         $exemptUser = grep(/^$userInstance$/, @exemptFromPermset);
         # We need to check they are using a permset
         @permsets=&wrapUserPermSet($userInstance);
         $numPermSets=$#permsets+1;
         if (($numPermSets == 0) && ($exemptUser == 0))
         {
            pp ("ERROR: Multiple instance user $userInstance should use permsets and has $numPermSets applied. This doesn't adhere to EH standards\n");
         }
      }
   }
}


################################################################################
# Check the number of entities subscribed for RHP clients
if ( $targetType eq "P" )
{
   $numEntities=&getNumEntities;
   $numSubscribed=&getNumSubscribed;
   $percent =($numEntities ? int($numSubscribed/$numEntities*100) : undef);
   if ( $percent > 80 )
   {
      pp ("ERROR: This is a platform client and we $numSubscribed entities subscribed which is $percent % of the total $numEntities which is deemed a too high. Please consult with the TRHS product owner\n");
   }
}

################################################################################
# Check for RHB clients usage collection is enabled and consolidation is turned on
if ( $targetType eq "B" )
{
   @filters=&getUsageFilters;
   $numFilters=$#filters+1;
   #print "$numFilters filters are defined in the DB\n";
   if ($numFilters == 0)
   {
      pp ("ERROR: No active usage filters (item_open) for RHB client is defined please enable usage data with consolidation\n");
   }
   else
   {
      #$consolidationEnabled=`crontab -l | grep consolidate_usage | grep -v ^#`;
      $consolidationEnabled=&checkConsolidationFeature;
      if (  $consolidationEnabled ==  0 )
      {
         pp ("ERROR: Usage consolidation is not enabled for an RHB client. This could cause the database to fill up. Please enable ...\n");
      }
   }
}

################################################################################
# Check for the number of positions in a basic client is 2
if ( $targetType eq "B" )
{
   %userPositionHash=&getUserPositions;
   foreach $LOGIN (keys %userPositionHash)
   {
      $exemptUser = grep(/^$LOGIN$/, @exemptFromNumAccesses);

      if ($LOGIN =~ m/VOR/)
      {
         if (!( $userPositionHash{$LOGIN} == 1 ) && ( $exemptUser == 0))
         {
             pp ("WARNING: User $LOGIN has num positions set to $userPositionHash{$LOGIN}. For a VOR client this should equal 1\n");
         }
      }
      else
      {
         if (( $userPositionHash{$LOGIN} == 2) || ( $userPositionHash{$LOGIN} == 0))
         {
            #print ("INFO: text book user $LOGIN \n");
         }
         else
         {
            if ( $exemptUser == 0)
            {
               pp ("WARNING: User $LOGIN has num positions set to $userPositionHash{$LOGIN}. For an RHB client this should equal 2\n");
            }
         }
      }
   }
}

close (REPORT);

## Subroutines #####################################################################
sub pp
{
  print @_;
  print REPORT @_;
}

sub usage
{
  pp("\n        Usage: permReport.pl -c configFile\n\n");
}

sub getCustomer
{
  my ($customer);

  $status = $dbh->dbcancel;

  $dbh->dbcmd("select distinct client from dacs_main..site\n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  $customer = $dbh->dbnextrow;
  return $customer;
}

sub getUsers
{
  my (@userArray,$data);

  $dbh->dbcmd("select login from dacs_main..dacsUser \
               where user_group <> '_SYSTEM_' and \
               ((deactivation = NULL and commit_time = NULL) or \
               (deactivation = NULL and activation = NULL)) \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  while($data = $dbh->dbnextrow)
  {
     push (@userArray,$data);
  }
  return @userArray;
}

sub findUserRecord
{
  my($site,$user) = @_;

  $dbh->dbcmd("select site,login from dacs_main..dacsUser where \
               site = '$site' and \
               login = '$user' and \
               ((deactivation = NULL and commit_time = NULL) or \
               (deactivation = NULL and activation = NULL)) \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  my @data;
  while(@data = $dbh->dbnextrow)
  {
    return (1);
  }
}

sub findServiceRecord
{
  my($service) = @_;

  $dbh->dbcmd("select site,dacsUser,service from dacs_main..user_service where \
               site = 'TRHS' and \
               dacsUser = 'radmind' and \
               service = '$service' and \
               ((deactivation = NULL and commit_time = NULL) or \
               (deactivation = NULL and activation = NULL)) \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  my @data;
  while(@data = $dbh->dbnextrow)
  {
    return (1);
  }
}

sub findAERecord
{
  my($site,$user,$ae_id) = @_;

  $dbh->dbcmd("select site,dacsUser,ae_id from dacs_main..user_ae where \
               site = '$site' and \
               dacsUser = '$user' and \
               ae_id = $ae_id and \
               ((deactivation = NULL and commit_time = NULL) or \
               (deactivation = NULL and activation = NULL)) \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  my @data;
  while(@data = $dbh->dbnextrow)
  {
    return (1);
  }
}


sub wrapVendorService
{
  my (@vendorServiceArray,$data);

  $dbh->dbcmd("select name\
                from dacs_main..vendorService  \
                where positive_perm = 1 and \
                deactivation = NULL \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  while($data = $dbh->dbnextrow)
  {
     push (@vendorServiceArray,$data);
  }
  return @vendorServiceArray;
}

sub activateUserService
{
   my($site,$user,$service,$dbDate) = @_;
   $dbh->dbcmd("insert into dacs_main..user_service values \
                \(
                '$site',
                '$user',
                '$service',
                '$dbDate',
                NULL,
                NULL,
                NULL,
                'reuter',
                NULL
                \)
                \n");
   $dbh->dbsqlexec;
   $dbh->dbresults;
}

sub activateUserAE
{
   my($site,$user,$subService,$service,$aeName,$dbDate) = @_;
   $dbh->dbcmd("insert into dacs_main..user_ae  values \
                \(
                '$site',
                '$user',
                '$aeName',
                $subService,
                '$service',
                '$dbDate',
                NULL,
                NULL,
                'reuter',
                NULL
                \)
                \n");
   $dbh->dbsqlexec;
   $dbh->dbresults;
}


sub wrapSiteAE
{
  # Build an array of all the user permissions with audit trail
  my (@siteAeArray,@data);

  $dbh->dbcmd("select s.aeId,a.local_name,a.vservice\
                from dacs_main..siteAe s, dacs_main..auth_entity a  \
                where s.site='TRHS' and \
                s.aeId = a.id and \
                a.deactivation = NULL and \
                s.deactivation = NULL \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  $i=0;
  while(@data = $dbh->dbnextrow)
  {
     my (@arrayLoc);
     $siteAeArray[$i] = \@arrayLoc;
     my $arrayRef = $siteAeArray[$i];
     push (@$arrayRef,$data[0]);
     push (@$arrayRef,$data[1]);
     push (@$arrayRef,$data[2]);
     $i=$i+1;
     #print "Putting data $data[0], $data[1] and $data[2] into $arrayRef for row $i\n";
  }
  return @siteAeArray;
}


sub wrapUserAE
{
  # Build an array of all the user permissions with audit trail
  my (@userAeArray,@data);

  $dbh->dbcmd("select u.site,u.dacsUser,d.name,u.service,u.ae ,u.activation,u.deactivation\
                from dacs_main..user_ae u, dacs_main..dacsUser d  \
                where u.site=d.site and \
                u.dacsUser=d.login and \
                d.deactivation = NULL and \
                d.user_group <> '_SYSTEM_' and \
                u.dacsUser <> 'rmdsTest' \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  $i=0;
  while(@data = $dbh->dbnextrow)
  {
     my (@arrayLoc);
     $userAeArray[$i] = \@arrayLoc;
     my $arrayRef = $userAeArray[$i];
     push (@$arrayRef,$data[0]);
     push (@$arrayRef,$data[1]);
     push (@$arrayRef,$data[2]);
     push (@$arrayRef,$data[3]);
     push (@$arrayRef,$data[4]);
     push (@$arrayRef,$data[5]);
     push (@$arrayRef,$data[6]);
     $i=$i+1;
     #print "Putting data $data[0], $data[1] and $data[2] into $arrayRef for row $i\n";
  }
  return @userAeArray;
}

sub wrapAEs
{
  # Build an array of all the products associated with this site
  my (@siteAeArray,@data);

  $dbh->dbcmd("select distinct vservice, local_name, type, description \
                from dacs_main..auth_entity a, dacs_main..siteAe s \
                where a.id = s.aeId and \
                ((a.deactivation = NULL and a.commit_time = NULL) or \
                (a.deactivation = NULL and a.activation = NULL)) and \
                ((s.deactivation = NULL and s.commit_time = NULL) or \
                (s.deactivation = NULL and s.activation = NULL))
                order by local_name\n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  $i=0;
  while(@data = $dbh->dbnextrow)
  {
     my (@arrayLoc);
     $siteAeArray[$i] = \@arrayLoc;
     my $arrayRef = $siteAeArray[$i];
     push (@$arrayRef,$data[0]);
     push (@$arrayRef,$data[1]);
     push (@$arrayRef,$data[2]);
     push (@$arrayRef,$data[3]);
     $i=$i+1;
     #print "Putting data $data[0], $data[1] and $data[2] into $arrayRef for row $i\n";
  }
  return @siteAeArray;
}


sub wrapUserAEs
{
  # Build an array of all the products associated with this site
  my ($dacsUser) = @_;
  my (@userAeArray,@data);

  $dbh->dbcmd("select distinct service, local_name, type, description \
                from dacs_main..auth_entity a, dacs_main..user_ae u \
                where a.id = u.ae_id and \
                a.vservice = u.service and \
                u.dacsUser = '$dacsUser' and \
                ((a.deactivation = NULL and a.commit_time = NULL) or \
                (a.deactivation = NULL and a.activation = NULL)) and \
                ((u.deactivation = NULL and u.commit_time = NULL) or \
                (u.deactivation = NULL and u.activation = NULL))
                order by local_name\n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  $i=0;
  while(@data = $dbh->dbnextrow)
  {
     my (@arrayLoc);
     $userAeArray[$i] = \@arrayLoc;
     my $arrayRef = $userAeArray[$i];
     push (@$arrayRef,$data[0]);
     push (@$arrayRef,$data[1]);
     push (@$arrayRef,$data[2]);
     push (@$arrayRef,$data[3]);
     $i=$i+1;
     #print "Putting data $data[0], $data[1] and $data[2] into $arrayRef for row $i\n";
  }
  return @userAeArray;
}

sub getDateTime
{
  my ($formatType) = @_;
  if ($formatType eq "6weeksold" )
  {
     #print "Adjusting time by 6 weeks\n";
     #$time = (time() - 3628800);
     $time = (time() - 3618800);
  }
  else
  {
     $time = time();
  }

  my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
  my $thisDay = (Sun,Mon,Tue,Wed,Thu,Fri,Sat)[(localtime($time))[6]];
  my $thisMonth = (Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec)[(localtime($time))[4]];
  my $thisYear = 1900+$year;
  my $now = "${mday}_${thisMonth}_${thisYear}_${hour}_${min}_${sec}";
  return(&format($now,$formatType));
}

sub format
{
  my ($now,$formatType) = @_;
  if($formatType eq "") {
    return $now;
  }
  elsif($formatType eq db) {
    my($mday,$month,$year) = ($now =~ /^(.+)_(.+)_(.+)_\d+_\d+_\d+/);
    return("$month $mday $year");
  }
  elsif($formatType eq dbl) {
    my($mday,$month,$year,$hour,$min) = ($now =~ /^(.+)_(.+)_(.+)_(\d+)_(\d+)_\d+/);
    return("$month $mday $year $hour:$min");
  }
  elsif($formatType eq "6weeksold") {
    my($mday,$month,$year,$hour,$min) = ($now =~ /^(.+)_(.+)_(.+)_(\d+)_(\d+)_\d+/);
    return("$month $mday $year $hour:$min");
  }
}

sub getDateParts
{
   $time = time();
   my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
   my $thisMonth = 1+ $mon;
   my $thisYear = 1900+$year;
   return $mday,$thisMonth,$thisYear;
}

sub getTimeAsEpoch
{
  my ($date) = @_;
  #print "Working on date $date\n";
  if ($date  =~ m/(\d\d\d\d)(\d\d)(\d\d)/)
  {
     $year=$1;
     # Adjust month by 1 for the time subroutine
     $month=($2-1);
     $day=$3;
     $epochTime = timelocal(0,0,0,$day,$month,$year);
  }
  else
  {
     $epochTime = "INVALID";
  }
  return ($epochTime);
}

sub parseConfig
{
   my ($file) = @_;
   my @returnArray;
   $i=0;
   if ( -e $file)
   {
      print "Opening file $file\n";
      open(CONFIG,"$file");
      while (<CONFIG>)
      {
         $line = $_;
         if (($line =~ m/(.+),(.+),(\d+)/) && (!($line =~ m/^#/)))
         {
            my (@arrayPairs);
            $returnArray[$i] = \@arrayPairs;
            my $arrayRef = $returnArray[$i];
            push (@$arrayRef,$1);
            push (@$arrayRef,$2);
            push (@$arrayRef,$3);
            #print "Adding $1 and $2 and $3 into $arrayRef for row $i\n";
            $i=$i+1;
         }
      }
      close CONFIG;
      return @returnArray;
   }
   else
   {
       pp ("Cannot open config file $file\n");
       exit
   }
}

sub writeInterfacesFile
{
   my ($host,$dataserver,$port) = @_;
   if ( -w $Interfaces )
   {
      #print "Interfaces file $Interfaces found and ready for writing\n";
      open(INTERFACES,"> $Interfaces");
      print INTERFACES ("$dataserver\n");
      print INTERFACES ("\tquery tcp ether $host $port\n");
      close(INTERFACES);
   }
   else
   {
      print "Interfaces file $Interfaces not open for writing\n";
   }
}

sub getRWFTESTusers
{
   my($site,$service1,$service2) = @_;
   my(@userArray);
   $dbh->dbcmd("select distinct(d.login) from dacs_main..dacsUser d, dacs_main..user_service s\
                where s.service in ('$service1','$service2') and \
                d.login=s.dacsUser and \
                d.site=s.site and \
                s.site='$site' and \
                d.user_group <> '_SYSTEM_' and \
                ((d.deactivation = NULL and d.commit_time = NULL) or \
                (d.deactivation = NULL and d.activation = NULL)) and \
                ((s.deactivation = NULL and s.commit_time = NULL) or \
                (s.deactivation = NULL and s.activation = NULL)) \n");
   $dbh->dbsqlexec;
   $dbh->dbresults;
   $i=0;
   while($data = $dbh->dbnextrow)
   {
      push (@userArray,$data);
      #print ("Adding user $data to array of users wth test sources\n");
   }
   return @userArray;
}

sub getMapCollectDate
{
   my($revision);
   $dbh->dbcmd("select max(revision) from dacs_main..auth_entity \n");
   $dbh->dbsqlexec;
   $dbh->dbresults;
   $revision = $dbh->dbnextrow;
   return ($revision);
}
sub getNewMapCollectDate
{
   my($new_revision);
   $dbh->dbcmd("select max(new_revision) from dacs_main..auth_entity \n");
   $dbh->dbsqlexec;
   $dbh->dbresults;
   $new_revision = $dbh->dbnextrow;
   return ($new_revision);
}
sub getPendingFlag
{
   my(@pendingflag,$data);
   $dbh->dbcmd("select distinct pending_flag from dacs_main..auth_entity where pending_flag = 3 or pending_flag = 2 or pending_flag = 1 \n");

   $dbh->dbsqlexec;
   $dbh->dbresults;
   while($data = $dbh->dbnextrow)
   {
     push (@pendingflag,$data);
   }
   return @pendingflag;
   #$pendingflag = $dbh->dbnextrow;
   #$pendinflag = 12345;
   #return ($pendingflag);
}

sub getDACSversion
{
   my ($version);
   $dbh->dbcmd("select DACSload from  dacs_main..DACSversion  \n");
   $dbh->dbsqlexec;
   $dbh->dbresults;
   $version = $dbh->dbnextrow;
   return $version;
}

sub wrapUsers
{
  # Build an array of users
  my(@userArray,@data);

  $dbh->dbcmd("select d.site,d.login,d.name,d.location\
              from dacs_main..dacsUser d  \
              where \
              d.user_group <> '_SYSTEM_' and \
              d.login <> 'rmdsTest' and \
              ((d.deactivation = NULL and d.commit_time = NULL) or \
              (d.deactivation = NULL and d.activation = NULL)) \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  $i=0;
  while(@data = $dbh->dbnextrow)
  {
     my (@arrayLoc);
     $userArray[$i] = \@arrayLoc;
     my $arrayRef = $userArray[$i];
     push (@$arrayRef,$data[0]);
     push (@$arrayRef,$data[1]);
     push (@$arrayRef,$data[2]);
     push (@$arrayRef,$data[3]);
     $i=$i+1;
     #print "Putting data $data[0], $data[1] and $data[2] into $arrayRef for row $i\n";
  }
  return @userArray;
}

sub getUsageFilter
{
  # Build an array of the usage filter
  my(@filterArray,@data);
  $dbh->dbcmd("select mount, mount_denied, item_open, item_denied \
               from dacs_main..usage_filter \
               where \
               commit_time = NULL and activation <> NULL and deactivation = NULL; \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  $i=0;
  while(@data = $dbh->dbnextrow)
  {
     my (@arrayLoc);
     $filterArray[$i] = \@arrayLoc;
     my $arrayRef = $filterArray[$i];
     push (@$arrayRef,$data[0]);
     push (@$arrayRef,$data[1]);
     push (@$arrayRef,$data[2]);
     push (@$arrayRef,$data[3]);
     $i=$i+1;
     #print "Putting data $data[0], $data[1] and $data[2] into $arrayRef for row $i\n";
  }
  return @filterArray;
}

sub wrapPermSets
{
  my (@permSetArray,@data);
  $dbh->dbcmd("select distinct id,name,site \
               from dacs_main..permissionSet \
               where ((deactivation = NULL and commit_time = NULL) or \
               (deactivation = NULL and activation = NULL)) \
               order by name \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  $i=0;
  while(@data = $dbh->dbnextrow)
  {
     my (@arrayValues);
     $permSetArray[$i] = \@arrayValues;
     my $arrayRef = $permSetArray[$i];
     push (@$arrayRef,$data[0]);
     push (@$arrayRef,$data[1]);
     push (@$arrayRef,$data[2]);
     #print "Putting data $data[0] and $data[1] and $data[2] into $arrayRef for row $i\n";
     $i=$i+1;
  }
  return @permSetArray;
}

sub wrapUserPermSet
{
  my ($user) =  @_;
  my (@permSetArray,$data);
  $dbh->dbcmd("select permsetID from dacs_main..userPermissionSet \
               where dacsUser = '$user' and \
               ((deactivation = NULL and commit_time = NULL) or \
               (deactivation = NULL and activation = NULL)) \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  while($data = $dbh->dbnextrow)
  {
      push (@permSetArray,$data);
  }
  return @permSetArray;
}

sub getNumEntities
{
   my ($data);
   $dbh->dbcmd("select count(*) from dacs_main..auth_entity \
                where \
                ((deactivation = NULL and commit_time = NULL) or \
                (deactivation = NULL and activation = NULL)) \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  $data = $dbh->dbnextrow;
  return ($data);
}

sub getNumSubscribed
{
   my ($data);
   $dbh->dbcmd("select count(*) from dacs_main..siteAe \
                where \
                ((deactivation = NULL and commit_time = NULL) or \
                (deactivation = NULL and activation = NULL)) \n");
  $dbh->dbsqlexec;
  $dbh->dbresults;
  $data = $dbh->dbnextrow;
  return ($data);
}

sub getUsageFilters
{
   my (@filterArray,@data);
   $dbh->dbcmd("select mount,item_open,mount_denied,item_denied \
                from dacs_main..usage_filter \
                where item_open = 1 and \
                deactivation = NULL and commit_time = NULL and \
                activation <> NULL \n");
   $dbh->dbsqlexec;
   $dbh->dbresults;
   $i=0;
   while(@data = $dbh->dbnextrow)
   {
      my (@arrayValues);
      $filterArray[$i] = \@arrayValues;
      my $arrayRef = $filterArray[$i];
      push (@$arrayRef,$data[0]);
      push (@$arrayRef,$data[1]);
      push (@$arrayRef,$data[2]);
      #print "Putting data $data[0] and $data[1] and $data[2] into $arrayRef for row $i\n";
      $i=$i+1;
   }
   return @filterArray;
}

sub checkConsolidationFeature
{
   my ($data);
   $dbh->dbcmd("select count(*) from dacs_main..common_configuration \
                where name = 'CONSOLIDATED_USAGE' and configValue = 'ENABLED' and \
                activation <> NULL and deactivation = NULL and \
                commit_time = NULL \n");
   $dbh->dbsqlexec;
   $dbh->dbresults;
   $data = $dbh->dbnextrow;
   #print "INFO: consolidationFeature is set to $data\n";
   return ($data);
}

sub getUserPositions
{
   my (@data,%positionHash);
   $dbh->dbcmd("select login,access_pos from dacs_main..dacsUser \
                where user_group <> '_SYSTEM_' and \
                ((deactivation = NULL and commit_time = NULL) or \
                (deactivation = NULL and activation = NULL)) \n");
   $dbh->dbsqlexec;
   $dbh->dbresults;
   while(@data = $dbh->dbnextrow)
   {
      $positionHash{$data[0]} = $data[1];
   }
   return %positionHash;
}

sub parseExceptionsFile
{
   my ($file) = @_;
   my @exemptFromNumAccesses;
   my @exemptFromPermset;
   if ( -e $file)
   {
      print "Opening file $file\n";
      open(EXCEPTION,"$file");
      while (<EXCEPTION>)
      {
         $line = $_;
         if (($line =~ m/(.+),(\d+),(\d+)/) && (!($line =~ m/^#/)))
         {
            $login=$1;
            $exemptAccessCheck=$2;
            $exemptPermsetCheck=$3;
            if ( $exemptAccessCheck == 1 )
            {
               push (@exemptFromNumAccesses,$login);
               #print("INFO: $login exempt from number of access check\n");
            }
            if ( $exemptPermsetCheck == 1 )
            {
               push (@exemptFromPermset,$login);
               #print("INFO: $login exempt from permset check\n");
            }
         }
      }
      close EXCEPTION;
      return (\@exemptFromNumAccesses, \@exemptFromPermset);
   }
   else
   {
       pp ("ERROR: Cannot open exceptions file $file\n");
   }
}
