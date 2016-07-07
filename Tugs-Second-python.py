#! python
# TUGS PLAYING WITH a ROTA SCRIPT
# Author 	: Tugrul Ozbay
# version 	: 0.0.1
# 
# python work rota script
#
#
# DATE TIME SECTION
#
import datetime
import time
#
#
## time now
print "Time percent H:M:S: ", (time.strftime("%H:%M:%S"))
now = time.strftime("%c")
## date and time representation
print "Current Date percent c : " + time.strftime("%c")
## Only date representation
print "Current date percent x : " + time.strftime("%x")
## Only time representation
print "Current Time percent big X : " + time.strftime("%X")
## Display current date and time from now variable 
print ("Current NOW percent s : %s"  % now )
#
#
dt = time.strftime("%c")
print dt
#
#
#
class DateRange:
    def __init__(self, start, end):
        self.start = start
        self.end   = end

class Shift:
    def __init__(self, range, min, Dave):
        self.range = range
        self.min_workers = min
        self.Dave_workers = Dave

tue_9th_10pm = dt(2014, 1, 9,   22, 0)
wed_10th_4am = dt(2014, 1, 10,   4, 0)
wed_10th_10am = dt(2014, 1, 10, 10, 0)

shift_1_times = Range(tue_9th_10pm, wed_10th_4am)
shift_2_times = Range(wed_10th_4am, wed_10th_10am)
shift_3_times = Range(wed_10th_10am, wed_10th_2pm)

shift_1 = Shift(shift_1_times, 2,3)  # allows 3, requires 2, but only 2 available
shift_2 = Shift(shift_2_times, 2,2)  # allows 2
shift_3 = Shift(shift_3_times, 2,3)  # allows 3, requires 2, 3 available

shifts = ( shift_1, shift_2, shift_3 )

Tug_avail = [ shift_1, shift_2 ]
Brian_avail = [ shift_1, shift_3 ]
Sam_avail = [ shift_2 ]
Paul_avail = [ shift_2 ]
Flynn_avail = [ shift_2, shift_3 ]
Dave_avail = [ shift_3 ]
Ajay_avail = [ shift_3 ]

Tug = Worker('Tug', Tug_avail)
Brian = Worker('Brian', Brian_avail)
Sam = Worker('Sam', Sam_avail)
Flynn = Worker('Flynn', Flynn_avail)
Dave = Worker('Dave', Dave_avail)
Paul = Worker('Paul', Paul_avail)
Ajay = Worker('Ajay', Ajay_avail)

workers = ( Tug, Brian, Sam, Flynn, Dave, Paul, Ajay )

