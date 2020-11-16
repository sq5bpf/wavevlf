# Example to plot file for vlfgraph data. 73! Jacek / SQ5BPF

set view map
set autoscale
set term png
set output "example1.png"
set xlabel "d [km]"   
set ylabel "f [Hz]"
set title "SQ5BPF: field strength at ionosphere height 80km; 200m antenna I=1A"
splot "example1.out" using 1:2:3 title "[uV/m]" with points palette

