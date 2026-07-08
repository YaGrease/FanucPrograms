/PROG  MASTER_RECEPTACLE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 2465;
CREATE		= DATE 26-07-08  TIME 14:49:12;
MODIFIED	= DATE 26-07-08  TIME 14:49:12;
FILE_NAME	= MASTER_R;
VERSION		= 0;
LINE_COUNT	= 91;
MEMORY_SIZE	= 2869;
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
   1:  ! MASTER_RECEPTACLE ;
   2:   ;
   3:  ! FRAME ;
   4:  UFRAME_NUM=1 ;
   5:  UTOOL_NUM=1 ;
   6:   ;
   7:J P[5:STATIC_HOME] 100% FINE    ;
   8:   ;
   9:  ! REGISTERS ;
  10:  R[1:REPO_RCP_X]=1    ;
  11:  R[2:REPO_RCP_Y]=1    ;
  12:  R[3:REPO_RCP_UOFFSET]=2.799    ;
  13:  R[4:REPO_X]=1    ;
  14:  R[18:REPO_Y]=1    ;
  15:  R[5:MODULE_X]=1    ;
  16:  R[15:MODULE_Y]=1    ;
  17:  R[6:MOD_RCP_XOFFSET]=3.2    ;
  18:  R[7:MOD_RCP_YOFFSET]=2.8    ;
  19:  R[8:MOD_RCP_X]=1    ;
  20:  R[9:MOD_RCP_Y]=1    ;
  21:  R[11:RECIPE_IO_IDX]=1    ;
  22:  R[12:RECIPE_OUTPUT]=0    ;
  23:  R[13:MODULE_XOFFSET]=38.1    ;
  24:  R[14:MODULE_YOFFSET]=25.4    ;
  25:  R[16:ICE_TRAY_NUM]=1    ;
  26:  R[17:ICE_TRAY_YOFFSET]=107.95    ;
  27:  R[19:REPO_XOFFSET]=374.649    ;
  28:  R[20:REPO_YOFFSET]=107.95    ;
  29:  R[21:PICKUP_CONSTANT]=20    ;
  30:  R[22:RELEASE_CONSTANT]=20.225    ;
  31:  R[23]=126.56    ;
  32:   ;
  33:  ! Position Registers ;
  34:  ! -use for calibration ;
  35:  PR[1:TMP_DATUM]=P[1:STATIC_DATUM]    ;
  36:   ;
  37:  ! -use by camera ;
  38:  PR[3:TMP_CAMERA]=P[3:STATIC_CAMERA]    ;
  39:   ;
  40:  ! -use by repository ;
  41:  PR[2:TMP_REPO_RCP]=P[2:STATIC_REPO_RCP]    ;
  42:  PR[5:REPO_RCP_PSN]=P[2:STATIC_REPO_RCP]    ;
  43:  PR[7:TMP_REPO_RCP]=P[2:STATIC_REPO_RCP]    ;
  44:  PR[9:REPO_PSN]=P[2:STATIC_REPO_RCP]    ;
  45:   ;
  46:  ! -use by module ;
  47:  PR[4:TMP_MOD_RCP]=P[4:STATIC_MOD_RCP]    ;
  48:  PR[6:MOD_RCP_PSN]=P[4:STATIC_MOD_RCP]    ;
  49:  PR[8:MOD_PSN]=P[4:STATIC_MOD_RCP]    ;
  50:  PR[10:TMP_MOD_RCP]=P[4:STATIC_MOD_RCP]    ;
  51:  PR[11:ICE_TRAY_PSN]=P[4:STATIC_MOD_RCP]    ;
  52:   ;
  53:   ;
  54:  MESSAGE[ENTER RECIPE IN R[10]] ;
  55:  PAUSE ;
  56:   ;
  57:  ! Init data into R[100]-R[136] ;
  58:  R[98]=0    ;
  59:  R[97]=37    ;
  60:  R[96]=R[10:RECIPE_NUMBER]*37    ;
  61:  R[95]=100    ;
  62:  R[96]=R[95]+R[96]+3    ;
  63:  LBL[1] ;
  64:  IF R[98]>=R[97],JMP LBL[2] ;
  65:  R[R[95]]=R[R[96]]    ;
  66:  R[96]=R[96]+1    ;
  67:  R[95]=R[95]+1    ;
  68:  R[98]=R[98]+1    ;
  69:  JMP LBL[1] ;
  70:   ;
  71:  LBL[2] ;
  72:  ! Go to Datum Point ;
  73:  !J P[1:STATIC_DATUM] 100% FINE ;
  74:   ;
  75:  ! Descend onto Datum point ;
  76:  !PR[1,3:TMP_DATUM]=PR[1,3:TMP_DAT ;
  77:   ;
  78:  !L PR[1:TMP_DATUM] 40mm/sec FINE ;
  79:   ;
  80:  ! Float the x and y ;
  81:  ! Compare actual vs expected and  ;
  82:  ! SOFTFLOAT ON ;
  83:  ! wait 0.5(sec) ;
  84:  ! PR[2:CORRECTION] = LPOS ;
  85:  ! SOFTFLOAT OFF ;
  86:  ! I will not use the correction y ;
  87:   ;
  88:  ! Ascend from the Datum point ;
  89:  !L P[1:STATIC_DATUM] 40mm/sec FIN ;
  90:   ;
  91:  CALL PICK_AND_PLACE    ;
/POS
P[1:"STATIC_DATUM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   -58.777000  mm,	Y =   175.552002  mm,	Z =    -2.949000  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[2:"STATIC_REPO_RCP"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =  -113.431000  mm,	Y =   165.684006  mm,	Z =    15.389000  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[3:"STATIC_CAMERA"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   105.653999  mm,	Y =   325.851013  mm,	Z =   144.367996  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[4:"STATIC_MOD_RCP"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =     -.096000  mm,	Y =   184.095001  mm,	Z =    20.125000  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[5:"STATIC_HOME"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   100.000000  mm,	Y =   175.000000  mm,	Z =   250.000000  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
/END
