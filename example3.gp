# Example to plot file for vlfgraph data. 73! Jacek / SQ5BPF


set view map
set autoscale
set term png
set output "example3.png"
set xlabel "d [km]"   
set ylabel "fs [uV/m]"
set title "SQ5BPF: 8970Hz field strength, ionosphere height 80km; 200m antenna I=1A"
plot "example3.out" using 1:3 title "[uV/m]" with lines

