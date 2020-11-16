# makefile for wavevlf, with some additional demos 
# 73! Jacek Lipkowski / SQ5BPF
#
#
# Pick your favourite fortran compiler here, vlfgraph doesn't compile under f77 currently.
#FC=f77
FC=f95
OPT=-O2

default: wavevlf vlfgraph

wavevlf: head.f propvlf.f
	$(FC) $(OPT) head.f propvlf.f -o wavevlf

vlfgraph: vlfgraph.f propvlf.f
	$(FC) $(OPT) vlfgraph.f propvlf.f -o vlfgraph

#graph
test: wavevlf DANE.DAT
	@cp DANE.DAT fort.7
	@rm -f fort.8
	@./wavevlf && echo "calculated results: `cat fort.8`" && echo "should be close to: `cat OUT.DAT`"

clean:
	rm -f *~ example[123].png example[123].out vlfgraph wavevlf fort.[78]

graphs: example1.png example2.png example3.png

# this should really be done via some macros, but i'm lazy now :) --sq5bpf
example1.out: vlfgraph example1.in example1.gp
	cp example1.in vlfgraph.in && ./vlfgraph > example1.out

example2.out: vlfgraph example2.in example2.gp
	cp example2.in vlfgraph.in && ./vlfgraph > example2.out

example3.out: vlfgraph example3.in example3.gp
	cp example3.in vlfgraph.in && ./vlfgraph > example3.out

example1.png: example1.out example1.gp
	gnuplot example1.gp
	
example2.png: example2.out example2.gp
	gnuplot example2.gp
	
example3.png: example3.out example3.gp
	gnuplot example3.gp
	
