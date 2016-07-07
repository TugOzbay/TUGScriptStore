#!/usr/bin/perl
# Script to set the bindings for processes instances dependant upon hardware model

$pName=@ARGV[0];
$cpuList=@ARGV[1];

if ( $#ARGV < 0 )
{
   &usage;
}

# Arrays to define process binding for different hardware

@processToBind=("src_dist -instance 1","src_dist -instance 2","src_dist -instance 3","src_dist -instance 4","src_dist -instance 5","src_dist -instance 6","p2ps -instance 10","p2ps -instance 1","p2ps -instance 2","p2ps -instance 3","p2ps -instance 4","p2ps -instance 5","./rrcpd sink","./rrcpd source");

$interrupts=`cat /proc/interrupts | grep CPU`;
#print "Working with $interrupts\n";
if ($interrupts =~ /CPU99/)
{
   #@X5570=("0,8","4,12","2,10","6,14","1,9","5,13","0,8","4,12","2,10","6,14","1,9","5,13","3,11","7,15");
   @X5570=("5,13","4,12","2,10","6,14","1,9","5,13","0,8","4,12","2,10","6,14","1,9","5,13","1,5,3,7,9,13,11,15","7,15");
   @2690=("5,13","4,12","2,10","6,14","1,9","5,13","0,8","4,12","2,10","6,14","1,9","5,13","1,5,3,7,9,13,11,15","7,15");
   @X5660=("5,13","4,12","2,10","6,14","1,9","5,13","0,8","4,12","2,10","6,14","1,9","5,13","3,5","7,15");
}
else
{
   #@X5570=("0,8","4,12","2,10","6,14","1,9","5,13","0,8","4,12","2,10","6,14","1,9","5,13","3,11","7,15");
   @X5570=("5","4","2","6","1","5","0","4","2","6","1","5","3,5","7");
   @2690=("5","4","2","6","1","5","0","4","2","6","1","5","3,5","7");
   @X5660=("5","4","2","6","1","5","0","4","2","6","1","5","3,5","7");
}
@5160=("0","1","0","1","0","1","0","1","2","0","1","2","2","3");
@E5450=("0","1","2","3","4","5","0","1","2","3","4","5","6","7");

my(@cpuInfo);
my($cpuInfoFile)= "/proc/cpuinfo";
unless ( open(CPU, "<$cpuInfoFile") )
{ die("ERROR: Unable to read file '$cpuInfoFile' @ line ",__LINE__,"\nERRORTEXT: $!\n"); }
@cpuInfo = <CPU>;
unless( close(CPU) )
{ die("ERROR: Unable to close file '$cpuInfoFile' @ line ",__LINE__,"\nERRORTEXT: $!\n"); }

#my($value) = undef;
my($line) = undef;
my($cpuModel) = undef;
my($notfound) = 1;
my($i) = 0;
while ($#cpuInfo && $notfound)
{
        $line = $cpuInfo[$i++];
        #if( $line =~ s/^model name.*: +([A-Za-z0-9]+.*)$/$1/ )
        if( $line =~ m/^model name.*: .+CPU\s.+-(.+)\s.\s+@/ )
        {
                $cpuModel = $1;
                $notfound=0;
        }
        $#cpuInfo--;
}

print "INFO: Machine model number is ${cpuModel}\n";

$i=0;
$matchedProcess=0;
foreach $process (@processToBind)
{
   if ($process eq $pName)
   {
      #print "Working on array value $i with possibles $process @processToBind[$i] @X5570[$i] @X5160[$i] @E5450[$i] \n";
      $matchedProcess=1;
      #Lets try and get the bindings from our hardware array
      if ($cpuList eq "")
      {
         $cpuList=@$cpuModel[$i];
      }
   }
   $i=$i+1;
}

if (!($cpuList eq ""))
{
   &bindProcess($pName,$cpuList);
}
else
{
   print ("ERROR: Unable set bindings for process $pName\n");
   print ("This maybe because the hardware is not recognised, or the process is not in our known list.\nIf so please supply the bindings as a command line option\n");
   &usage;
}

#ppid=`ps -eo "%p:%a" | grep "$pName" | egrep -v "$pName[A-Za-z0-9_].*$" | grep -v "$0" | grep -v grep | cut -d':' -f1`

#for pid in `ps --no-headers -p $ppid -Lo spid`
#do
        #taskset -pc $cpuList $pid
#done

sub usage
{
  print("\n        Usage: $0 process [bindings] \n");
  print("\n        Bindings will be set according to hardware but will be overriden by comamnd line option\n");
  exit 1;
}

sub bindProcess
{
   my($pName,$binding) = @_;
   my(@bindings);
   $ppid=`ps -eo "%p:%a" | grep "$pName" | grep -v grep | grep -v "$0"`;
   if ($ppid =~ /(\d+):.+/)
   {
      $PID=$1;
   }
   #$ppid=`ps -eo "%p:%a" | grep "$pName" | grep -v grep | grep -v "$0" | cut -d':' -f1`;
   #$ppid=`ps -eo "%p:%a" | grep "$pName" | egrep -v "$pName[A-Za-z0-9_].*$" | grep -v "$0" | grep -v grep | cut -d':' -f1`;
   print ("INFO: Attempting to bind $pName pid $PID to cpu $binding\n");
   @PIDS=`ps --no-headers -p $PID -Lo spid`;
   @bindings=split(/,/,$binding);
#print ("bindings=@bindings\n");
   @cpus=@bindings;
   foreach $child (@PIDS)
   {
      chomp ($child);
#print ("Working on PID XX${child}XX\n");
      if ($#cpus==-1) { @cpus=@bindings; }
      $cpu=shift(@cpus);
      chomp ($cpu);
      print ("INFO: Attempting to bind $pName pid $child to cpu $cpu\n");
      `taskset -pc $cpu $child`;
      #print ("INFO: Attempting to bind $pName pid $child to cpu $binding\n");
      #`taskset -pc $binding $child`;
   }
}

