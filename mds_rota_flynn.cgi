#!/usr/bin/perl.5.10
#
#
#       creator         Flynn Gardener
#       Created         28 May 2009
#       Reason          Create web rota because I'm bored of searching for the spreadsheet
#
#       Rev 1           Start

### pragma
use strict ;
use warnings ;

### load mods
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);      # CGI me up
use Sys::Hostname;
use Date::Calc qw(Today Day_of_Week Days_in_Month
                    Month_to_Text Day_of_Week_Abbreviation
                    );
                    
### vars                    
my  ( $first_monday, $count2, $catch_choice, $bg_col, $choice, $mon_adam, $mon_dinkar, $mon_simon, $mon_paul, $mon_raja, $mon_oncall, $ad_rez, $din_rez, $sim_rez, $paul_rez, $raja_rez, $on_rez, $bank_hol, $td_one, $td_two, $td_three, $td_four, $td_five, $td_six, $td_seven, $week_day_count, $adam, $dinkar, $simon, $raja, $oncall, $adamcount, $paul, $dinkarcount, $simoncount, $paulcount, $oncallcount, $rajacount, @monday_count, $month, $year, $query, $count, $num_month, @BH_2009, @BH_2010, @BH_2011, @BH_2012 ) ;

my $query = new CGI;

    print $query->header, start_html({
        -title => 'Rota Creation',
        -author => 'flynn.gardener@uk.bnpparibas.com',
        -style => {
        -src => '../test_area/menu.css'
        },
        -script => {
        -language => 'javascript',
        -src => "../js_files/mypop.js"
        }
        });

    open (MENU, "<./menu.txt");
    while (<MENU>){
        print $_;
    }
    close (MENU);

    print "<H2>Market Data Infrastructure Rota</H2>\n";
    print $query->startform;
    print   $query->popup_menu('month',['January','February','March','April','May','June','July','August','September','October','November','December'],'January') ;
    print   $query->popup_menu('year',['2009','2010','2011','2012'],'2010');
    print $query->submit('form_1','Submit Information');
    print $query->endform;
    print "<HR>\n";

    $query->import_names('Q');
    if ($Q::form_1) {
        $year = $Q::year ;
        $month = $Q::month ;		
        print $query->startform;

        @BH_2009 = ("1 January", "10 April", "13 April", "4 May", "25 May", "31 August", "25 December", "28 December") ;
        @BH_2010 = ("1 January", "2 April", "5 April", "3 May", "31 May", "30 August", "27 December", "28 December") ;
        @BH_2011 = ("3 January", "22 April", "25 April", "29 April", "2 May", "30 May", "29 August", "26 December", "27 December") ;
        @BH_2012 = ("2 January", "6 April", "9 April", "7 May", "4 June", "5 June", "27 August", "25 December", "26 December") ;
        
        my ( $days_in_month, $num_month ) = month_year ( $month, $year ) ;

        print "<H1>$month - $year</H1>" ;
        print ("<table><tbody><td valign=top><b><table  border=1><tbody><b>\n") ;
        
        if ( -e "/storage/.rota_files/.$year$month" ) {
            print ("<tr align=center><small><td width=100><td width=100>Adam<td width=100>Dinkar<td width=100>Simon<td width=100>Paul<td width=100>Raja<td width=100>On Call</td>") ;

            open (ROTAIN, "\< /storage/\.rota_files/\.$year$month") ;
            my @f = <ROTAIN> ;
            close (ROTAIN) ;

            $count = 1 ;
            $adam = "Adam" ;
            $dinkar = "Dinkar" ;
            $simon = "Simon" ;
            $paul = "Paul" ;
            $raja = "Raja" ;
            $oncall = "Oncall" ;

            my $monday_array_count =  @f ;

            if ( $monday_array_count > 5 ) {
                while ( $count != $days_in_month +1 ) {
                    $td_one = (split / /, $f[$count-1]) [0] ;
                    $td_two = (split / /, $f[$count-1]) [1] ;
                    $td_three = (split / /, $f[$count-1]) [2] ;
                    $td_four = (split / /, $f[$count-1]) [3] ;
                    $td_five = (split / /, $f[$count-1]) [4] ;
                    $td_six = (split / /, $f[$count-1]) [5] ;
                    chomp ($td_seven = (split / /, $f[$count-1]) [6]) ;

                    $adamcount = join("", $adam, $count) ;
                    $dinkarcount = join("", $dinkar, $count) ;
                    $simoncount = join("", $simon, $count) ;
                    $paulcount = join("", $paul, $count) ;
                    $rajacount = join("", $raja, $count) ;
                    $oncallcount = join("", $oncall, $count) ;

                    $week_day_count = Day_of_Week($year, $num_month, $td_one) ;
                    $bank_hol = join(' ', $count, $month) ;

                    if ( $year == 2009 && $bank_hol ~~ @BH_2009 )  {
                        print ("<tr align=center bgcolor=FF9900><td width=100>$count<td width=100><td width=100><td width=100><td width=100><td width=100><td width=100>") ;
                        print   $query->popup_menu("$oncallcount",['Adam','Dinkar','Simon','Paul','Raja'],"$td_seven") ;
                        print ("</td>") ;
                    } elsif ( $year == 2010 && $bank_hol ~~ @BH_2010 )  {
                        print ("<tr align=center bgcolor=FF9900><td width=100>$count<td width=100><td width=100><td width=100><td width=100><tdwidth=100></td>") ;
                    } elsif ( $year == 2011 && $bank_hol ~~ @BH_2011 )  {
                        print ("<tr align=center bgcolor=FF9900><td width=100>$count<td width=100><td width=100><td width=100><td width=100><tdwidth=100></td>") ;
                    } elsif ( $year == 2012 && $bank_hol ~~ @BH_2012 )  {
                        print ("<tr align=center bgcolor=FF9900><td width=100>$count<td width=100><td width=100><td width=100><td width=100><tdwidth=100></td>") ;
                    } elsif ( $week_day_count == 1 || $week_day_count == 2 || $week_day_count == 3 || $week_day_count == 4 || $week_day_count == 5  ) {
                        $bg_col = colour_me ( $td_two ) ;
                        print ("<tr align=center bold><small><td width=100>$td_one<td $bg_col width=100>") ;
                        print   $query->popup_menu("$adamcount", ['Early','Mids','Late','Holiday','Training','Buisness','Sick','R-shift'],"$td_two") ;
                        $bg_col = colour_me ( $td_three ) ;
                        print ("<td $bg_col width=100>") ;
                        print   $query->popup_menu("$dinkarcount",['Early','Mids','Late','Holiday','Training','Buisness','Sick','R-shift'],"$td_three") ;
                        $bg_col = colour_me ( $td_four ) ;
                        print ("<td $bg_col width=100>") ;
                        print   $query->popup_menu("$simoncount",['Early','Mids','Late','Holiday','Training','Buisness','Sick','R-shift'],"$td_four") ;
                        $bg_col = colour_me ( $td_five ) ;
                        print ("<td $bg_col width=100>") ;
                        print   $query->popup_menu("$paulcount",['Early','Mids','Late','Holiday','Training','Buisness','Sick','R-shift'],"$td_five") ;
                        $bg_col = colour_me ( $td_six ) ;
                        print ("<td $bg_col width=100>") ;
                        print   $query->popup_menu("$rajacount",['Early','Mids','Late','Holiday','Training','Buisness','Sick','R-shift'],"$td_six") ;
                        $bg_col = colour_me ( $td_seven ) ;
                        print ("<td $bg_col width=100>") ;
                        print   $query->popup_menu("$oncallcount",['Adam','Dinkar','Simon','Paul','Raja'],"$td_seven") ;
                        print ("</td>") ;
                    } elsif ( $week_day_count == 6 || $week_day_count == 7) {
                        print ("<tr align=center bgcolor=6699CC><td width=100>$count<td width=100><td width=100><td width=100><td width=100><td width=100><td width=100>") ;
                        print   $query->popup_menu("$oncallcount",['Adam','Dinkar','Simon','Paul','Raja'],"$td_seven") ;
                        print ("</td>") ;
                    }
                    $catch_choice = 1 ;
                    $count ++ ;
                }
            }
            print "<input type=\"hidden\" name=\"monday\" value=\"@monday_count\">" ;
            print "<input type=\"hidden\" name=\"month\" value=\"$month\">" ;
            print "<input type=\"hidden\" name=\"year\" value=\"$year\">" ;
            print "<input type=\"hidden\" name=\"choice\" value=\"$catch_choice\">" ;
        } else {
            $count = 1 ;
            $adam = "Adam" ;
            $dinkar = "Dinkar" ;
            $simon = "Simon" ;
            $paul = "Paul" ;
            $raja = "Raja" ;
            $oncall = "Oncall" ;
            
            print ("<tr align=center><small><td width=100><td width=100>Adam<td width=100>Dinkar<td width=100>Simon<td width=100>Paul<td width=100>Raja<td width=100>On Call</td>") ;
            
            while ( $count != $days_in_month +1 ) {
                my $week_day_count = Day_of_Week($year, $num_month, $count) ;
                my $bank_holiday = join(' ', $count, $month) ;
                
                if ( $week_day_count == 1 ) {
                    $adamcount = join("", $adam, $count) ;
                    $dinkarcount = join("", $dinkar, $count) ;
                    $simoncount = join("", $simon, $count) ;
                    $paulcount = join("", $paul, $count) ;
                    $rajacount = join("", $raja, $count) ;
                    $oncallcount = join("", $oncall, $count) ;

                    print ("<tr align=center bold><small><td width=100>$count<td width=100>") ;
                    print   $query->popup_menu("$adamcount",['Early','Mids','Late','Holiday','Training','Buisness','Sick','R-shift'],"Early") ;
                    print ("<td width=100>") ;
                    print   $query->popup_menu("$dinkarcount",['Early','Mids','Late','Holiday','Training','Buisness','Sick','R-shift'],"Early") ;
                    print ("<td width=100>") ;
                    print   $query->popup_menu("$simoncount",['Early','Mids','Late','Holiday','Training','Buisness','Sick','R-shift'],"Early") ;
                    print ("<td width=100>") ;
                    print   $query->popup_menu("$paulcount",['Early','Mids','Late','Holiday','Training','Buisness','Sick','R-shift'],"Early") ;
                    print ("<td width=100>") ;
                    print   $query->popup_menu("$rajacount",['Early','Mids','Late','Holiday','Training','Buisness','Sick','R-shift'],"Early") ;
                    print ("<td width=100>") ;
                    print   $query->popup_menu("$oncallcount",['Adam','Dinkar','Simon','Paul','Raja'],"Early") ;
                    print ("</td></tr>") ;
                    
                    push (@monday_count, $count) ;
                    $catch_choice = 2 ;
                }
                $count++ ;
            }

            print "<input type=\"hidden\" name=\"monday\" value=\"@monday_count\">" ;
            print "<input type=\"hidden\" name=\"month\" value=\"$month\">" ;
            print "<input type=\"hidden\" name=\"year\" value=\"$year\">" ;
            print "<input type=\"hidden\" name=\"choice\" value=\"$catch_choice\">" ;
        }

        print $query->submit(-name=>'test1',
        -value=>'Submit Information');
    }
print $query->endform;
######### End of form

catch_data() ; ### Get the info

sub catch_data
{
	
    $query->import_names('R');
    if ($R::test1) {
        $catch_choice = param('choice') ;
        if ( $catch_choice == 1 ) {
            $month = param('month') ;
            $year = param('year') ;
            
            my ( $days_in_month, $num_month ) = month_year ( $month, $year ) ;
            open (ROTA, "\> /storage/\.rota_files/\.$year$month") || die "blah blah $!" ;
            
            my $monday = param('monday') ;
            @monday_count = (split / /, $monday) ;

            $count = 1 ;
            $adam = "Adam" ;
            $dinkar = "Dinkar" ;
            $simon = "Simon" ;
            $paul = "Paul" ;
            $raja = "Raja" ;
            $oncall = "Oncall" ;

            while ( $count != $days_in_month +1 ) {
                $mon_adam = join("", $adam, $count) ;
                $mon_dinkar = join("", $dinkar, $count) ;
                $mon_simon = join("", $simon, $count) ;
                $mon_paul = join("", $paul, $count) ;
                $mon_raja = join("", $raja, $count) ;
                $mon_oncall = join("", $oncall, $count) ;

                $ad_rez = $query->param("$mon_adam") ;
                $din_rez = $query->param("$mon_dinkar") ;
                $sim_rez = $query->param("$mon_simon") ;
                $paul_rez = $query->param("$mon_paul") ;
                $raja_rez = $query->param("$mon_raja") ;
                $on_rez = $query->param("$mon_oncall") ;	

                print ROTA "$count $ad_rez $din_rez $sim_rez $paul_rez $raja_rez $on_rez\n" ;
                $count++ ;
            }
            close (ROTA) ;
        } elsif ( $catch_choice == 2 ) {
            $month = param('month') ;
            $year = param('year') ;
            
            my ( $days_in_month, $num_month ) = month_year ( $month, $year ) ;
            open (ROTA, "\> /storage/\.rota_files/\.$year$month") || die "blah blah $!" ;
            
            my $monday = param('monday') ;
            @monday_count = (split / /, $monday) ;
            $first_monday = $monday_count[0] ;
			$count = 1 ;
            $count2 = 1 ;
            $adam = "Adam" ;
            $dinkar = "Dinkar" ;
            $simon = "Simon" ;
            $paul = "Paul" ;
            $raja = "Raja" ;
            $oncall = "Oncall" ;
            
            while ( $count != $days_in_month +1 ) {
                $week_day_count = Day_of_Week($year, $num_month, $count) ;
                $bank_hol = join(' ', $count, $month) ;
                
                if ( ( $week_day_count > 1 ) && ( $count < $first_monday ) ) {
                    print ROTA "$count Early Early Early Early Early Adam\n" ; 
                    $count++ ;
                } else {
                    if ( $week_day_count == 1 ) {
                        $mon_adam = join("", $adam, $count ) ;
                        $mon_dinkar = join("", $dinkar, $count ) ;
                        $mon_simon = join("", $simon, $count ) ;
                        $mon_paul = join("", $paul, $count ) ;
                        $mon_raja = join("", $raja, $count ) ;
                        $mon_oncall = join("", $oncall, $count ) ;
                        
                        $ad_rez = $query->param("$mon_adam") ;
                        $din_rez = $query->param("$mon_dinkar") ;
                        $sim_rez = $query->param("$mon_simon") ;
                        $paul_rez = $query->param("$mon_paul") ;
                        $raja_rez = $query->param("$mon_raja") ;
                        $on_rez = $query->param("$mon_oncall") ;

                        print ROTA "$count $ad_rez $din_rez $sim_rez $paul_rez $raja_rez $on_rez\n" ;
                        $count++ ;
                    } else {
                        print ROTA "$count $ad_rez $din_rez $sim_rez $paul_rez $raja_rez $on_rez\n" ;
                        $count++ ;
                    }   
                }      
            }
      close (ROTA) ;
        }
    } 
} ### end end

#### Apply HTML colours
sub colour_me
{

	$choice = $_[0] ;

    my $early = "bgcolor=CCFFFF" ;
    my $mids = "bgcolor=99CCFF" ;
    my $lates = "bgcolor=3399FF" ;
    my $hols = "bgcolor=FF9933" ;
    my $train = "bgcolor=CCFF66" ;
    my $buis = "bgcolor=99FF66" ;
    my $sick = "bgcolor=FF0000" ;
    my $rshift = "bgcolor=FF99FF" ;

	if ( $choice eq "Early" ) {  
		return ($early) ;
	} elsif ( $choice eq "Mids" ) {
		return ($mids) ;
	} elsif ( $choice eq "Late" ) {
		return ($lates) ;
	} elsif ( $choice eq "Holiday" ) {
		return ($hols) ;
	} elsif ( $choice eq "Training" ) {
		return ($train) ;
	} elsif ( $choice eq "Buisness" ) {
		return ($buis) ;
	} elsif ( $choice eq "Sick" ) {
		return ($sick) ;
	} elsif ( $choice eq "R-shift" ) {
		return ($rshift) ;
	}

} ### end sub colour

####### Find date stats
sub month_year
{


my $month = $_[0] ;
my $year = $_[1] ;

my %months_of_year = (
January         =>      1,
February        =>      2,
March           =>      3,
April           =>      4,
May             =>      5,
June            =>      6,
July            =>      7,
August          =>      8,
September       =>      9,
October         =>      10,
November        =>      11,
December        =>      12,
);


my $num_month = $months_of_year{"$month"};

my $total_days_of_month = Days_in_Month($year, $num_month) ;

return ( $total_days_of_month, $num_month );
} ### end sub date stats

### work out month before
sub month_before
{

	my $num_month = $_[0] ;
	my $year = $_[1] ;

	my %months_of_year = (
		1	=>	'January',
		2	=>	'February',
		3	=>	'March',
		4	=>	'April',
		5	=>	'May',
		6	=>	'June',
		7	=>	'July',
		8	=>	'August',
		9	=>	'September',
		10	=>	'October',
		11	=>	'November',
		12	=>	'December',
		);

	$num_month-- ;

	if ( $num_month < 1 ) {
		$num_month = 12 ; 
		$year-- ;
	}

	my $month_string = $months_of_year{"$num_month"};

	return ($month_string, $year) ;

} ### end sub month_before


