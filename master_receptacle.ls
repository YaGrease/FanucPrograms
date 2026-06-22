/PROG  MASTER_RECEPTACLE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 2286;
CREATE		= DATE 26-06-22  TIME 10:48:42;
MODIFIED	= DATE 26-06-22  TIME 10:48:42;
FILE_NAME	= MASTER_R;
VERSION		= 0;
LINE_COUNT	= 88;
MEMORY_SIZE	= 2702;
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
   7:  ! REGISTERS ;
   8:  R[1:REPO_RCP_X]=1    ;
   9:  R[2:REPO_RCP_Y]=1    ;
  10:  R[3:REPO_RCP_UOFFSET]=2.799    ;
  11:  R[4:REPO_X]=1    ;
  12:  R[18:REPO_Y]=1    ;
  13:  R[5:MODULE_X]=1    ;
  14:  R[15:MODULE_Y]=1    ;
  15:  R[6:MOD_RCP_XOFFSET]=3.2    ;
  16:  R[7:MOD_RCP_YOFFSET]=2.8    ;
  17:  R[8:MOD_RCP_X]=1    ;
  18:  R[9:MOD_RCP_Y]=1    ;
  19:  R[11:RECIPE_IO_IDX]=1    ;
  20:  R[12:RECIPE_OUTPUT]=0    ;
  21:  R[13:MODULE_XOFFSET]=38.1    ;
  22:  R[14:MODULE_YOFFSET]=25.4    ;
  23:  R[16:ICE_TRAY_NUM]=1    ;
  24:  R[17:ICE_TRAY_YOFFSET]=107.95    ;
  25:  R[19:REPO_XOFFSET]=374.649    ;
  26:  R[20:REPO_YOFFSET]=107.95    ;
  27:  R[21:PICKUP_CONSTANT]=19.265    ;
  28:  R[22:RELEASE_CONSTANT]=20.132    ;
  29:   ;
  30:  ! Position Registers ;
  31:  ! -use for calibration ;
  32:  PR[1:TMP_DATUM]=P[1:STATIC_DATUM]    ;
  33:   ;
  34:  ! -use by camera ;
  35:  PR[3:TMP_CAMERA]=P[3:STATIC_CAMERA]    ;
  36:   ;
  37:  ! -use by repository ;
  38:  PR[2:TMP_REPO_RCP]=P[2:STATIC_REPO_RCP]    ;
  39:  PR[5:REPO_RCP_PSN]=P[2:STATIC_REPO_RCP]    ;
  40:  PR[7:TMP_REPO_RCP]=P[2:STATIC_REPO_RCP]    ;
  41:  PR[9:REPO_PSN]=P[2:STATIC_REPO_RCP]    ;
  42:   ;
  43:  ! -use by module ;
  44:  PR[4:TMP_MOD_RCP]=P[4:STATIC_MOD_RCP]    ;
  45:  PR[6:MOD_RCP_PSN]=P[4:STATIC_MOD_RCP]    ;
  46:  PR[8:MOD_PSN]=P[4:STATIC_MOD_RCP]    ;
  47:  PR[10:TMP_MOD_RCP]=P[4:STATIC_MOD_RCP]    ;
  48:  PR[11:ICE_TRAY_PSN]=P[4:STATIC_MOD_RCP]    ;
  49:   ;
  50:   ;
  51:  MESSAGE[ENTER RECIPE IN R[10]] ;
  52:  PAUSE ;
  53:   ;
  54:  ! Init data into R[100]-R[136] ;
  55:  R[98]=0    ;
  56:  R[97]=37    ;
  57:  R[96]=R[10:RECIPE_NUMBER]*37    ;
  58:  R[95]=100    ;
  59:  R[96]=R[95]+R[96]+3    ;
  60:  LBL[1] ;
  61:  IF R[98]>=R[97],JMP LBL[2] ;
  62:  R[R[95]]=R[R[96]]    ;
  63:  R[96]=R[96]+1    ;
  64:  R[95]=R[95]+1    ;
  65:  R[98]=R[98]+1    ;
  66:  JMP LBL[1] ;
  67:   ;
  68:  LBL[2] ;
  69:  ! Go to Datum Point ;
  70:J P[1:STATIC_DATUM] 100% FINE    ;
  71:   ;
  72:  ! Descend onto Datum point ;
  73:  PR[1,3:TMP_DATUM]=PR[1,3:TMP_DATUM]-8    ;
  74:   ;
  75:L PR[1:TMP_DATUM] 40mm/sec FINE    ;
  76:   ;
  77:  ! Float the x and y ;
  78:  ! Compare actual vs expected and  ;
  79:  ! SOFTFLOAT ON ;
  80:  ! wait 0.5(sec) ;
  81:  ! PR[2:CORRECTION] = LPOS ;
  82:  ! SOFTFLOAT OFF ;
  83:  ! I will not use the correction y ;
  84:   ;
  85:  ! Ascend from the Datum point ;
  86:L P[1:STATIC_DATUM] 40mm/sec FINE    ;
  87:   ;
  88:  CALL PICK_AND_PLACE    ;
/POS
P[1:"STATIC_DATUM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =    50.971001  mm,	Y =   181.350006  mm,	Z =     9.258000  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[2:"STATIC_REPO_RCP"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =    -3.966000  mm,	Y =   171.309998  mm,	Z =    27.500000  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[3:"STATIC_CAMERA"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   259.316986  mm,	Y =   330.410004  mm,	Z =   165.720001  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[4:"STATIC_MOD_RCP"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   109.771004  mm,	Y =   189.729996  mm,	Z =    32.464001  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
/END
