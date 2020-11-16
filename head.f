
      program ELF_VLF_PROPAGATION
C    simple  header program calling main subroutine VLFPM
C:   an example of input data and single result for the reference
C    and testing purposes, Piotr Mynarski, SQ7MPJ, October, 2010
C    input/output user data described in VLFPM subroutine
      implicit real*8 (a,b,d-h,o-y)
      implicit complex*16 (c,z)
      data zero,one,two,tys/0.0D0,1.0D0,2.0D0,1000.0D0/
      open(7,file='fort.7',status='old',access='sequential',
     &form='formatted')
      open(8,file='fort.8',status='new',access='sequential',
     &form='formatted')
C
      read(7,15) f
      read(7,15) h
 15   format(f10.3)
      read(7,15) dd
      read(7,16) N
      read(7,15) amp
      read(7,15) ds
 16   format(I4)
C      
      call vlfpm(f,h,dd,N,amp,ds,result)
      write(8,50) result
 50   format(4x,'Effective Field [microV/m] = ',E17.8)
      close(8)
      close(7)
      stop
      end


