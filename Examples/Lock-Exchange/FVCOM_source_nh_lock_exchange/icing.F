SUBROUTINE ICING(NOW)
  USE MOD_UTILS
  USE MOD_FORCE
  USE ALL_VARS
  USE MOD_TIME
  IMPLICIT NONE
  TYPE(TIME), INTENT(IN) :: NOW
  REAL(SP), PARAMETER :: Tfreeze = -1.75_SP 
  REAL(SP), DIMENSION(0:MT) :: ICING_WNDSPD

  IF(DBG_SET(DBG_LOG)) write(ipt,*) "Start Icing Update"

  ! GET THE FORCING DATA
  CALL UPDATE_ICING(NOW,ICING_SATMP,ICING_WNDX,ICING_WNDY)
  
  ICING_WNDSPD = sqrt(icing_wndy**2 + icing_wndx**2)
  ICING_WNDSPD(0) = 0.0_sp
  

  IF(DBG_SET(DBG_IO))THEN
     WRITE(IPT,*) "min/max(SAT)",MINVAL(ICING_SATMP(1:MT)),MAXVAL(ICING_SATMP(1:MT))
     WRITE(IPT,*) "min/max(WNDSPD)",MINVAL(ICING_WNDSPD(1:MT)),MAXVAL(ICING_WNDSPD(1:MT))
     WRITE(IPT,*) "min/max(T1(:,1))",MINVAL(T1(1:MT,1)),MAXVAL(T1(1:MT,1))
  END IF
  
  ICING_0kts = (Tfreeze - ICING_SATMP) /&
       (1.0_SP + 0.4_SP *(T1(:,1) -Tfreeze))
  
  WHERE (ICING_0kts < 0.0_SP) ICING_0kts = 0.0_SP

  ICING_10kts = (ICING_WNDSPD + 5.0_SP) * ICING_0kts

  ICING_0kts = ICING_0kts * ICING_WNDSPD
  

END SUBROUTINE ICING
