
      subroutine vlfpm(f,h,dd,N,amp,ds,res)
C     earth-ionosphere waveguide propagation model
C     based on eqns (5.2 - 5.11)  of D. Lowenfels paper
C     E(z) of TEM mode in a spherical waveguide cavity 
C     programme by Piotr Mlynarski, SQ7MPJ, May-June, 2010
C     on input:
C     f:   frequency in Hertz
C     h:   ionosphere height in kilometers
C     dd: distance between transmitter and receiver in kilometers
C     N: number of summation terms in the procedure of calculating
C Legendre polynomial of a complex degree - should be around 1000 
C     max. value of N=2000
C     amp:  antenna current in Amp
C     ds: antenna vertical length in meters
C     on output:
C     res: effective E field in microVolts/m
C
      implicit real*8 (a,b,d-h,o-y)
      implicit complex*16 (c,z)
      data zero,one,two,tys/0.0D0,1.0D0,2.0D0,1000.0D0/
      data epsi,reat/8.854D0,6370.0D0/
C     E(z) [microVolt/m]
      pi = datan(1.0D0)*4.0D0
      theta = dd/reat
      call eigenu(f,cnu)
      c1 = cnu*(cnu + one)
C     doesn't with gfortran --sq5bpf  ciu = CMPLX(zero,one)
      ciu = CMPLX(0.0D0,1.0D0)
      call polnu(theta,cnu,zpoly,wmod,N)
      call zesnu(cnu,csp)
      c5 = zpoly/csp
      c6 = ciu*c1
      zesp = c5*c6
      d1 = DBLE(zesp)
      d2 = IMAG(zesp)
      d3 = DSQRT(d1*d1 + d2*d2)
      d4 = reat/tys
      d5 = 4.0D0*d4*d4*epsi
      d33 = d3/f
      d44 = ds/h
      d55 = (amp*tys)/d5
      res = d33*d44*d55
      return
      end


      subroutine eigenu(f,zwyn)
      implicit real*8 (a,b,d-h,o-y)
      implicit complex*16 (c,z)
      data zero,one,two/0.0D0,1.0D0,2.0D0/
      data tys/1000.0D0/
C     frequency in Hz
      pi = datan(1.0D0)*4.0D0
      f11 = f/tys
      elam = 299792.5D0/f11
      elam1 = elam/tys/tys
      ek = (two*pi)/elam1
      alf = atten(f)
      vce = velo(f)
      wsk = ek*alf
      vcc = one/vce
      uro = -5.49D0*alf/f
      zss = CMPLX(vcc,uro)
      zss = zss*wsk
      zs2 = 4.0D0*zss*zss + one
      zsroo = sqrt(zs2)
      zwyn = (zsroo - one)/two
      return
      end

      subroutine polnu(theta,cnu,zpoly,wmod,N)
C     calculation of the Legendre Function of complex degree
C     by Piotr Mlynarski, SQ7MPJ,  May, 2010
C     zonal harmonic series expansion based on a paper:
C     D.L. Jones & C.P. Burke; J.Phys. A: Math; 23,3159-3168(1990)
C
      implicit real*8 (a,b,d-h,o-y)
      implicit complex*16 (c,z)
      dimension pn(0:2000)
      data zero,one,two,three,tol1/0.0D0,1.0D0,2.0D0,3.0D0,1.0D-05/
      pi = datan(1.0D0)*4.0D0
      cnu1 = pi*cnu
      dx = DBLE(cnu1)
      dy = DIMAG(cnu1)
      wre = DSIN(dx)*DCOSH(dy)
      wim = DCOS(dx)*DSINH(dy)
      cxy = CMPLX(wre,wim)
      cxy = cxy/pi
      w1 = DSIN(theta)
      w1 = 4.0D0/(w1*w1)
      x = DCOS(theta)
      call lgr(N,x,pn)
C problems compiling with gfortran     z1 = CMPLX(one,zero)
C      z2 = CMPLX(two,zero)
C      z3 = CMPLX(three,zero)
      z1 = CMPLX(1.0D0,0.0D0)
      z2 = CMPLX(2.0D0,0.0D0)
      z3 = CMPLX(3.0D0,0.0D0)
      c1 = cnu*(cnu + z1)
C     doesn't compile with gfortran      csum = CMPLX(zero,zero)
      csum = CMPLX(0.0D0,0.0D0)
C
      do 11 k = 0,N
      cpop = csum
      k1 = 2*k + 1
      k2 = k*(k + 1)
      rk1 = dble(k1)
      rk2 = dble(k2)
      up = rk1*PN(k)
C       zr = CMPLX(rk2,zero)
      zr = CMPLX(rk2,0.0D0)
      zn1 = zr + (cnu -z1)*(cnu + z2)
      ca = zr - (cnu - z2)*(cnu - z1)
      cb = zr - c1
      cc = zr - (cnu + z2)*(cnu + z3)
      csum = csum + zn1*up/(ca*cb*cc)
 11    continue
      zpoly = cxy*w1*csum
      d1 = DBLE(zpoly)
      d2 =DIMAG(zpoly)
      wmod = dsqrt(d1*d1 + d2*d2)
      return
      end
      SUBROUTINE LGR(N,X,PN)
      IMPLICIT REAL*8 (P,X)
      DIMENSION PN(0:N)
      PN(0)=1.0D0
      PN(1)=X
      P0=1.0D0
      P1=X
      DO 10 K=2,N
      PF=(2.0D0*K-1.0D0)/K*X*P1-(K-1.0D0)/K*P0
      PN(K)=PF
      P0=P1
10         P1=PF
      RETURN
      END


      subroutine zesnu(zin,zout)
      implicit real*8 (a,b,d-h,o-y)
      implicit complex*16 (c,z)
      pi = datan(1.0D0)*4.0D0
      cnu1 = pi*zin
      dx = DBLE(cnu1)
      dy = DIMAG(cnu1)
      wre = DSIN(dx)*DCOSH(dy)
      wim = DCOS(dx)*DSINH(dy)
      zout = CMPLX(wre,wim)
      return
      end

      real*8 function atten(f)
      implicit real*8 (a-h,o-z)
C     frequency  f in Hz
      dimension apoly(12)
      data zero,one/0.0D0,1.0D0/
      data ami1,ami2,a0,ten/2.2598D0,1.316D0,0.203966D0,10.0D0/
      data apoly/0.540817D0,0.537105D0,3.477203D0,0.612539D0,
     &-6.846465D0,-2.910078D0,4.911758D0,2.341272D0,-1.553159D0,
     &-0.738223D0,0.183969D0,0.08399D0/
C
      argum = DLOG10(f)
      ft = (argum - ami1)/ami2
      fac = zero
      w = one
      do 5 i = 1,12
      w = w*ft
      fac = fac + apoly(i)*w
 5    continue
      fac = fac + a0
      atten = ten**fac
      return
      end
      real*8 function velo(f)
      implicit real*8 (a-h,o-z)
C     frequency in Hz
      dimension bpoly(9)
      data start,tau,zero,one/4000.0D0,1500.0D0,0.0D0,1.0D0/
      data bmi1,bmi2,b0/1.7519D0,1.1181D0,0.8161356D0/
      data bpoly/0.0527641D0,-0.0137582D0,0.0755177D0,-0.0305358D0,
     &-0.0458421D0,0.0427126D0,0.0245402D0,-0.0109618D0,-0.0050278D0/
C polynomial fit of attenuation parameter alfa
      fob = f
      if(f.GT.start) fob = start
      arg = DLOG10(fob)
      ft = (arg - bmi1)/bmi2
      sum = zero
      w = one
      do 4 i = 1,9
      w = w*ft
      sum = sum + bpoly(i)*w
 4    continue
      velo = sum + b0
      if(f.GT.start) then
              wc40 = velo
              wyk = (f - start)/tau
              ce = DEXP(-wyk)
              wc41 = (wc40 - one)*ce + one
              velo = wc41
      endif
      return
      end


