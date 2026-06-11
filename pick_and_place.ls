/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 3836;
CREATE		= DATE 26-06-11  TIME 15:50:10;
MODIFIED	= DATE 26-06-11  TIME 15:50:10;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 165;
MEMORY_SIZE	= 4320;
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
   1:  LBL[4:PP_LOOP] ;
   2:   ;
   3:   ;
   4:  IF R[11:RECIPE_IO_IDX]=37,JMP LBL[998] ;
   5:  R[99]=R[11:RECIPE_IO_IDX]+100    ;
   6:  R[12:RECIPE_OUTPUT]=R[R[99]]    ;
   7:   ;
   8:  ! Checks to see if recipe does ;
   9:  ! not call for receptacle ;
  10:  IF R[12:RECIPE_OUTPUT]=0,JMP LBL[1] ;
  11:   ;
  12:  ! Move to next pin ;
  13:J PR[5:REPO_RCP_PSN] 100% FINE    ;
  14:   ;
  15:  ! Descend to grab pin ;
  16:  PR[2:TMP_REPO_RCP]=PR[5:REPO_RCP_PSN]    ;
  17:  PR[2,3:TMP_REPO_RCP]=PR[2,3:TMP_REPO_RCP]-R[21:PICKUP_CONSTANT]    ;
  18:L PR[2:TMP_REPO_RCP] 40mm/sec FINE    ;
  19:  WAIT    .50(sec) ;
  20:   ;
  21:  ! Ascend with Pin ;
  22:L PR[5:REPO_RCP_PSN] 40mm/sec FINE    ;
  23:   ;
  24:  ! Move to camera (care for ;
  25:  ! collision) ;
  26:  PR[20]=PR[5:REPO_RCP_PSN]    ;
  27:  PR[20,3]=PR[3,3:TMP_CAMERA]    ;
  28:L PR[20] 100mm/sec CNT100    ;
  29:  PR[20]=PR[3:TMP_CAMERA]    ;
  30:J PR[3:TMP_CAMERA] 100% FINE    ;
  31:  PR[20,3]=PR[20,3]-49    ;
  32:L PR[20] 100mm/sec CNT100    ;
  33:L PR[3:TMP_CAMERA] 200mm/sec CNT100    ;
  34:  PR[3:TMP_CAMERA]=PR[3:TMP_CAMERA]    ;
  35:  WAIT    .50(sec) ;
  36:   ;
  37:  ! Check orientation ;
  38:   ;
  39:  ! Move to Cable Module ;
  40:J PR[6:MOD_RCP_PSN] 100% FINE    ;
  41:   ;
  42:  ! Descend with receptacle ;
  43:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
  44:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
  45:L PR[4:TMP_MOD_RCP] 40mm/sec FINE    ;
  46:   ;
  47:  ! Ascend without receptacle ;
  48:L PR[6:MOD_RCP_PSN] 40mm/sec FINE    ;
  49:   ;
  50:   ;
  51:   ;
  52:  !!! CHECK REPO STATUS START ;
  53:  IF R[1:REPO_RCP_X]=22 AND R[2:REPO_RCP_Y]=20,JMP LBL[999] ;
  54:   ;
  55:  ! Not empty so update ;
  56:  R[1:REPO_RCP_X]=R[1:REPO_RCP_X]+1    ;
  57:  IF R[1:REPO_RCP_X]>22,JMP LBL[2] ;
  58:   ;
  59:  ! Update position x ;
  60:  PR[5,1:REPO_RCP_PSN]=PR[5,1:REPO_RCP_PSN]+R[3:REPO_RCP_UOFFSET]    ;
  61:  JMP LBL[1] ;
  62:   ;
  63:  ! Next row x overflow ;
  64:  LBL[2] ;
  65:  R[1:REPO_RCP_X]=1    ;
  66:  R[2:REPO_RCP_Y]=R[2:REPO_RCP_Y]+1    ;
  67:  PR[5,1:REPO_RCP_PSN]=PR[7,1:TMP_REPO_RCP]    ;
  68:  PR[5,2:REPO_RCP_PSN]=PR[5,2:REPO_RCP_PSN]-R[3:REPO_RCP_UOFFSET]    ;
  69:  JMP LBL[1] ;
  70:   ;
  71:  ! Switched from receptacle repo ;
  72:  ! to receptacle repo ;
  73:  LBL[999] ;
  74:  R[1:REPO_RCP_X]=1    ;
  75:  R[2:REPO_RCP_Y]=1    ;
  76:  IF R[4:REPO_X]=2 AND R[18:REPO_Y]=2,JMP LBL[996] ;
  77:   ;
  78:  R[4:REPO_X]=R[4:REPO_X]+1    ;
  79:  IF R[4:REPO_X]>2,JMP LBL[7] ;
  80:   ;
  81:  ! next repository column ;
  82:  PR[9,1:REPO_PSN]=PR[9,1:REPO_PSN]+R[19:REPO_XOFFSET]    ;
  83:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
  84:  JMP LBL[1] ;
  85:   ;
  86:  ! next repository row ;
  87:  LBL[7] ;
  88:  R[4:REPO_X]=1    ;
  89:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
  90:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]    ;
  91:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]+R[20:REPO_YOFFSET]    ;
  92:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
  93:  JMP LBL[1] ;
  94:  !!! CHECK REPO STATUS END. ;
  95:   ;
  96:   ;
  97:   ;
  98:  !!! CHECK TO SEE CURRENT RECIPE S ;
  99:  LBL[1] ;
 100:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 101:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 102:   ;
 103:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 104:   ;
 105:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 106:  JMP LBL[4] ;
 107:   ;
 108:  LBL[5] ;
 109:  R[8:MOD_RCP_X]=1    ;
 110:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 111:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 112:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 113:  JMP LBL[4] ;
 114:  !!! CHECK TO SEE CURRENT RECIPE ;
 115:  !!! END ;
 116:   ;
 117:   ;
 118:   ;
 119:  !!! MODULE FULL, CHECK STATUS ;
 120:  !!! START ;
 121:  LBL[998] ;
 122:  R[11:RECIPE_IO_IDX]=1    ;
 123:  R[8:MOD_RCP_X]=1    ;
 124:  R[9:MOD_RCP_Y]=1    ;
 125:   ;
 126:  ! Check to see if Ice Tray Full ;
 127:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 128:   ;
 129:  ! Check if module row full ;
 130:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 131:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 132:   ;
 133:  ! Increment module column ;
 134:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 135:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 136:  JMP LBL[4] ;
 137:   ;
 138:  ! Increment module row and reset  ;
 139:  LBL[6] ;
 140:  R[5:MODULE_X]=1    ;
 141:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 142:  PR[10:TMP_MOD_RCP]=P[4:FIRST_RCP]    ;
 143:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 144:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]+R[14:MODULE_YOFFSET]    ;
 145:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 146:  JMP LBL[4] ;
 147:   ;
 148:  ! Switched from ice tray ;
 149:  ! to ice tray ;
 150:  LBL[997] ;
 151:  ! Check am I out of Ice Trays ;
 152:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 153:   ;
 154:  ! Increment Ice Tray and set mod ;
 155:  ! and mod_rcp equal ;
 156:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 157:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]+R[17:ICE_TRAY_YOFFSET]    ;
 158:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 159:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 160:  JMP LBL[4] ;
 161:  !!! MODULE FULL, CHECK STATUS ;
 162:  !!! END ;
 163:   ;
 164:  LBL[996] ;
 165:  END ;
/POS
P[1:"DATUM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   424.654999  mm,	Y =   183.154999  mm,	Z =     0.000000  mm,
	W =  -180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[2:"FIRST_PIN"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   369.580994  mm,	Y =   174.535004  mm,	Z =     0.000000  mm,
	W =  -180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[3:"CAMERA"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   207.901993  mm,	Y =   332.035004  mm,	Z =    82.065002  mm,
	W =  -180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[4:"FIRST_RCP"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   108.552002  mm,	Y =   190.020996  mm,	Z =     0.000000  mm,
	W =  -180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
/END
