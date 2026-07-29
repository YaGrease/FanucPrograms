/PROG  MASTER_RECEPTACLE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 2227;
CREATE		= DATE 26-07-28  TIME 13:35:56;
MODIFIED	= DATE 26-07-28  TIME 13:35:56;
FILE_NAME	= MASTER_R;
VERSION		= 0;
LINE_COUNT	= 81;
MEMORY_SIZE	= 2671;
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
  35:   ;
  36:  ! Position Registers ;
  37:  ! -use for calibration ;
  38:  PR[1:TMP_DATUM]=P[1:STATIC_DATUM]    ;
  39:   ;
  40:  ! Camera location load ;
  41:  PR[3:TMP_CAMERA]=P[3:STATIC_CAMERA]    ;
  42:   ;
  43:  ! Repository location load ;
  44:  PR[2:TMP_REPO_RCP]=P[2:STATIC_REPO_RCP]    ;
  45:  PR[5:REPO_RCP_PSN]=P[2:STATIC_REPO_RCP]    ;
  46:  PR[7:TMP_REPO_RCP]=P[2:STATIC_REPO_RCP]    ;
  47:  PR[9:REPO_PSN]=P[2:STATIC_REPO_RCP]    ;
  48:   ;
  49:  ! Module Location Load ;
  50:  PR[4:TMP_MOD_RCP]=P[4:STATIC_MOD_RCP]    ;
  51:  PR[6:MOD_RCP_PSN]=P[4:STATIC_MOD_RCP]    ;
  52:  PR[8:MOD_PSN]=P[4:STATIC_MOD_RCP]    ;
  53:  PR[10:TMP_MOD_RCP]=P[4:STATIC_MOD_RCP]    ;
  54:  PR[11:ICE_TRAY_PSN]=P[4:STATIC_MOD_RCP]    ;
  55:   ;
  56:  ! Error Location Load ;
  57:  PR[12:RELEASE_ONE]=P[6:STATIC_RLS_ONE]    ;
  58:  PR[13:RELEASE_TWO]=P[7:STATIC_RLS_TWO]    ;
  59:   ;
  60:  MESSAGE[ENTER RECIPE IN R[10]] ;
  61:  PAUSE ;
  62:   ;
  63:  ! Init data into R[100]-R[136] ;
  64:  R[99:RECIPE_IDX]=101    ;
  65:  R[98:RECIPE_LOWER_LIM]=0    ;
  66:  R[97:RECIPE_UPPER_LIM]=37    ;
  67:  R[96:RECIPE_LOCATION]=R[10:RECIPE_NUMBER]*37    ;
  68:  R[95:RECIPE_BASE]=100    ;
  69:  R[96:RECIPE_LOCATION]=R[95:RECIPE_BASE]+R[96:RECIPE_LOCATION]+3    ;
  70:  LBL[1] ;
  71:  IF R[98:RECIPE_LOWER_LIM]>=R[97:RECIPE_UPPER_LIM],JMP LBL[2] ;
  72:  R[R[95]]=R[R[96]]    ;
  73:  R[96:RECIPE_LOCATION]=R[96:RECIPE_LOCATION]+1    ;
  74:  R[95:RECIPE_BASE]=R[95:RECIPE_BASE]+1    ;
  75:  R[98:RECIPE_LOWER_LIM]=R[98:RECIPE_LOWER_LIM]+1    ;
  76:  JMP LBL[1] ;
  77:   ;
  78:   ;
  79:   ;
  80:  LBL[2] ;
  81:  CALL PICK_AND_PLACE    ;
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
	X =   407.864990  mm,	Y =   200.850998  mm,	Z =   118.000000  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[7:"STATIC_RLS_TWO"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   428.390015  mm,	Y =   328.032013  mm,	Z =    63.390999  mm,
	W =   180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
/END
