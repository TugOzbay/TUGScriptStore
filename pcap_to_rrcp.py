#!/usr/bin/python
import os

# modify the -R options to filter on fields, the -r option for tcpdump filename
os.system('tshark -r tcpdump -R "ip.src == 10.4.0.133" -T fields -e frame.number -e frame.time -e ip.src -e udp.srcport -e ip.dst -e udp.dstport -e udp.length -e data.data  -E header=y -E separator=, -E quote=d -E occurrence=f > out.csv')

file_in = open('out.csv',"r")
file_out = open('RRCP.csv',"w")
file_out.write('pkt no. , time , src ip , src port , dst ip , dst port , length , node ID , opcode , seq no , len , msg no , n , m , npn , version , flag , seq_diff, msg_diff , npn_diff\n')
file_in.readline()

seq_prev = [0,0,0]

for line in file_in.readlines():
# line = file_in.readline()
	line = line.replace('"','')
	line_split = line.split(',')
	line_split[2] = line_split[2][6:] # truncate year from time string
	data = line_split[8].replace(':','') # remove : from data
	data_processed = []
	hex_start = 0
	for i in [4,4,4,4,4,2,2,8,4,4]:
		data_processed.append(data[hex_start:hex_start+i])
		hex_start+=i

	# convert hexes to decimal, calculate diff between sequence numbers
	data_processed[3] = str(int(data_processed[3],16))
	for i,j in zip([0,1,2],[2,4,7]):
		data_processed[j] = str(int(data_processed[j],16))
		data_processed.append(str( int(data_processed[j])-seq_prev[i]))
		seq_prev[i] = int(data_processed[j])
	
	line_out = line_split[0:1]+line_split[2:8]+data_processed
	line_out = " , ".join(line_out)+"\n"

	file_out.write(line_out)


file_out.close()
