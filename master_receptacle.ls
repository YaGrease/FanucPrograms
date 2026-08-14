/PROG  MASTER_RECEPTACLE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 2259;
CREATE		= DATE 26-08-07  TIME 10:03:38;
MODIFIED	= DATE 26-08-07  TIME 10:03:38;
FILE_NAME	= MASTER_R;
VERSION		= 0;
LINE_COUNT	= 83;
MEMORY_SIZE	= 2695;
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
   7:J P[5:STATIC_HOME] 100% CNT100    ;
   8:   ;
   9:  ! REGISTERS ;
  10:  R[1:REPO_RCP_X]=1    ;
  11:  R[2:REPO_RCP_Y]=1    ;
  12:  R[3:REPO_RCP_UOFFSET]=2.803    ;
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
  23:  R[13:MODULE_XOFFSET]=38.12    ;
  24:  R[14:MODULE_YOFFSET]=25.4    ;
  25:  R[16:ICE_TRAY_NUM]=1    ;
  26:  R[17:ICE_TRAY_YOFFSET]=107.886    ;
  27:  R[19:REPO_XOFFSET]=374.85    ;
  28:  R[20:REPO_YOFFSET]=108.001    ;
  29:  R[21:PICKUP_CONSTANT]=20.7    ;
  30:  R[22:RELEASE_CONSTANT]=20.2    ;
  31:  R[23:Y_OFFSET_SHROUD]=135.56    ;
  32:  R[24:PICK_CNT_ERR]=0    ;
  33:  R[25:PLACE_CNT_ERR]=0    ;
  34:  R[26:FAILED_PICK_CNT]=0    ;
  35:  R[27]=0    ;
  36:  R[28]=0    ;
  37:   ;
  38:  ! Position Registers ;
  39:  ! -use for calibration ;
  40:  PR[1:TMP_DATUM]=P[1:STATIC_DATUM]    ;
  41:   ;
  42:  ! Camera location load ;
  43:  PR[3:TMP_CAMERA]=P[3:STATIC_CAMERA]    ;
  44:   ;
  45:  ! Repository location load ;
  46:  PR[2:TMP_REPO_RCP]=P[2:STATIC_REPO_RCP]    ;
  47:  PR[5:REPO_RCP_PSN]=P[2:STATIC_REPO_RCP]    ;
  48:  PR[7:TMP_REPO_RCP]=P[2:STATIC_REPO_RCP]    ;
  49:  PR[9:REPO_PSN]=P[2:STATIC_REPO_RCP]    ;
  50:   ;
  51:  ! Module Location Load ;
  52:  PR[4:TMP_MOD_RCP]=P[4:STATIC_MOD_RCP]    ;
  53:  PR[6:MOD_RCP_PSN]=P[4:STATIC_MOD_RCP]    ;
  54:  PR[8:MOD_PSN]=P[4:STATIC_MOD_RCP]    ;
  55:  PR[10:TMP_MOD_RCP]=P[4:STATIC_MOD_RCP]    ;
  56:  PR[11:ICE_TRAY_PSN]=P[4:STATIC_MOD_RCP]    ;
  57:   ;
  58:  ! Error Location Load ;
  59:  PR[12:RELEASE_ONE]=P[6:STATIC_RLS_ONE]    ;
  60:  PR[13:RELEASE_TWO]=P[7:STATIC_RLS_TWO]    ;
  61:   ;
  62:  MESSAGE[ENTER RECIPE IN R[10]] ;
  63:  PAUSE ;
  64:   ;
  65:  ! Init data into R[100]-R[136] ;
  66:  R[99:RECIPE_IDX]=101    ;
  67:  R[98:RECIPE_LOWER_LIM]=0    ;
  68:  R[97:RECIPE_UPPER_LIM]=37    ;
  69:  R[96:RECIPE_LOCATION]=R[10:RECIPE_NUMBER   ]*37    ;
  70:  R[95:RECIPE_BASE]=100    ;
  71:  R[96:RECIPE_LOCATION]=R[95:RECIPE_BASE]+R[96:RECIPE_LOCATION]+3    ;
  72:  LBL[1] ;
  73:  IF R[98:RECIPE_LOWER_LIM]>=R[97:RECIPE_UPPER_LIM],JMP LBL[2] ;
  74:  R[R[95]]=R[R[96]]    ;
  75:  R[96:RECIPE_LOCATION]=R[96:RECIPE_LOCATION]+1    ;
  76:  R[95:RECIPE_BASE]=R[95:RECIPE_BASE]+1    ;
  77:  R[98:RECIPE_LOWER_LIM]=R[98:RECIPE_LOWER_LIM]+1    ;
  78:  JMP LBL[1] ;
  79:   ;
  80:   ;
  81:   ;
  82:  LBL[2] ;
  83:  CALL PICK_AND_PLACE    ;
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
	X =  -113.481003  mm,	Y =   165.654007  mm,	Z =    15.389000  mm,
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
	X =      .096000  mm,	Y =   184.095001  mm,	Z =    20.125000  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[5:"STATIC_HOME"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   100.000000  mm,	Y =   175.000000  mm,	Z =   250.000000  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[6:"STATIC_RLS_ONE"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   407.864990  mm,	Y =   200.850998  mm,	Z =   125.000000  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[7:"STATIC_RLS_TWO"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   425.929993  mm,	Y =   339.316986  mm,	Z =    28.601999  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
/END
