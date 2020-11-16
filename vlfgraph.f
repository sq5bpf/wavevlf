C    This is head.f, slightly modified to iterate over a range of
C    values, and generate output suitable for a graphing program.
C    Input values are read from the file graphvlf.in. Examples
C    for Gnuplot are also provided.  73! Jacek Lipkowski / SQ5BPF

      program ELF_VLF_PROPAGATION
C    simple  header program calling main subroutine VLFPM
C:   an example of input data and single result for the reference
C    and testing purposes, Piotr Mynarski, SQ7MPJ, October, 2010
C    input/output user data described in VLFPM subroutine
      implicit real*8 (a,b,d-h,o-y)
      implicit complex*16 (c,z)
      data zero,one,two,tys/0.0D0,1.0D0,2.0D0,1000.0D0/
      open(7,file='vlfgraph.in',status='old',access='sequential',
     &form='formatted')
C
      read(7,15) fmin
      read(7,15) fmax
      read(7,15) fstep
      read(7,15) h
 15   format(f10.3)
      read(7,15) ddmin
      read(7,15) ddmax
      read(7,15) ddstep
      read(7,16) N
      read(7,15) amp
      read(7,15) ds
 16   format(I4)
C      
      close(7)

      f=fmin
      dd=ddmin
      DO
      DO

      call vlfpm(f,h,dd,N,amp,ds,result)
      write(*,*) dd,' ',f,' ',result
      dd=dd+ddstep
      if (dd.gt.ddmax) exit
      end do

      f=f+fstep
      dd=ddmin
      if (f.gt.fmax) exit
      end do

      stop
      end


