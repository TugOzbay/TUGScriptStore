
open FILEHANDLE_IN, “< C:\Users\tugrul.ozbay.CJCIT\Documents\WORK\Perl\testfile”;

open FILEHANDLE_OUT, “< C:\Users\tugrul.ozbay.CJCIT\Documents\WORK\Perl\testfileOUT.log”;

while (< FILEHANDLE_IN>) {

if ($. == 5) 
   {
	system (“clear”);
	print FILEHANDLE_OUT “$_ \n”;
	print “$_ \n”;
	next;
   } 
else 
  {
	print FILEHANDLE_OUT “$_ \n”;
	print “$_ \n”;
  }

}
close FILEHANDLE_IN;
close FILEHANDLE_OUT;
