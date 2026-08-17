/PROG  READ_SCORE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Sub-program for ";
PROG_SIZE	= 886;
CREATE		= DATE 26-08-17  TIME 14:50:38;
MODIFIED	= DATE 26-08-17  TIME 14:50:38;
FILE_NAME	= READ_SCO;
VERSION		= 0;
LINE_COUNT	= 30;
MEMORY_SIZE	= 1270;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
LOCAL_REGISTERS	= 0,0,0;
/APPL
/APPL
/MN
   1:  ! READ_SCORE (Computer vision) ;
   2:   ;
   3:  ! Checks and scores based off of ;
   4:  ! precise orientation of the ;
   5:  ! receptacle ;
   6:  IF R[27:CAMERA_MODE]=1,JMP LBL[40] ;
   7:  VISION RUN_FIND 'RCP_FINDER'    ;
   8:  VISION GET_OFFSET 'RCP_FINDER' VR[1] JMP LBL[38] ;
   9:  JMP LBL[41] ;
  10:   ;
  11:  ! Checks and scores based off if ;
  12:  ! a pin is being held my the end  ;
  13:  ! effector or not. ;
  14:  LBL[40] ;
  15:  VISION RUN_FIND 'RCP_ERROR'    ;
  16:  VISION GET_OFFSET 'RCP_ERROR' VR[1] JMP LBL[38] ;
  17:   ;
  18:  ! Both vision processes pass the ;
  19:  ! retrieved data to a register ;
  20:  LBL[41] ;
  21:  R[57]=VR[1].MES[1] ;
  22:  JMP LBL[39] ;
  23:   ;
  24:  ! Fail case for when vision ;
  25:  ! processes fail to find and ;
  26:  ! sets to a default score of 0 ;
  27:  LBL[38] ;
  28:  R[57:CUR_SCORE]=0    ;
  29:   ;
  30:  LBL[39] ;
/POS
/END
