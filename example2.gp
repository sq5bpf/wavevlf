# Example to plot file for vlfgraph data. 73! Jacek / SQ5BPF


set view map
set autoscale
set term png
set output "example2.png"
set xlabel "f [Hz]"   
set ylabel "fs [uV/m]"
set title "SQ5BPF: field strength at 904km distance, ionosphere height 80km; 200m antenna I=1A"
plot "example2.out" using 2:3 title "[uV/m]" with lines

