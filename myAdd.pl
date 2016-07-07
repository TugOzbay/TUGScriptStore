

# like a for do loop in Perl

my @array = (1..10);		# Range 1 to 10


for (my $loop = 10; $loop >= 1; $loop--) 

  {

        if ($array[$loop]) 
        {
                my $adding = $array[$loop] + $loop;
                print "$array[$loop]  -> $loop -> $adding\n";
        }
  }
