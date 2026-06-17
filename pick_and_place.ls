/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 5006;
CREATE		= DATE 26-06-17  TIME 12:50:04;
MODIFIED	= DATE 26-06-17  TIME 12:50:04;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 230;
MEMORY_SIZE	= 5626;
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
  18:L PR[2:TMP_REPO_RCP] 100mm/sec FINE    ;
  19:  WAIT    .50(sec) ;
  20:   ;
  21:  ! Ascend with Pin ;
  22:L PR[5:REPO_RCP_PSN] 100mm/sec FINE    ;
  23:   ;
  24:  ! Move to camera (care for ;
  25:  ! collision) ;
  26:  PR[20]=PR[5:REPO_RCP_PSN]    ;
  27:  PR[20,3]=PR[3,3:TMP_CAMERA]    ;
  28:L PR[20] 100mm/sec CNT100    ;
  29:  PR[20]=PR[3:TMP_CAMERA]    ;
  30:J PR[3:TMP_CAMERA] 100% FINE    ;
  31:  PR[20,3]=PR[20,3]-45    ;
  32:L PR[20] 200mm/sec CNT100    ;
  33:L PR[3:TMP_CAMERA] 200mm/sec CNT100    ;
  34:L PR[20] 200mm/sec CNT100    ;
  35:L PR[3:TMP_CAMERA] 200mm/sec CNT100    ;
  36:  PR[3:TMP_CAMERA]=PR[3:TMP_CAMERA]    ;
  37:   ;
  38:  ! initiate camera code ;
  39:  R[50:STEP_CNT]=0    ;
  40:  R[51:MAX_STEP_CNT]=72    ;
  41:  R[52:TURN_PER_STEP]=5    ;
  42:  R[53:MINIMUM_THRESH]=90    ;
  43:  R[54:ABOVE_THRESH]=0    ;
  44:  R[55:BEST_SCORE]=0    ;
  45:  R[56:DOWN_THRESH]=2    ;
  46:  R[57:CUR_SCORE]=0    ;
  47:  R[58:CUR_DROP]=0    ;
  48:  PR[21]=PR[3:TMP_CAMERA]    ;
  49:  PR[22]=PR[3:TMP_CAMERA]    ;
  50:   ;
  51:  ! FIND BEST ORIENTATION ;
  52:  ! Rotate to next step ;
  53:  LBL[30] ;
  54:L PR[21] 200mm/sec FINE    ;
  55:  WAIT    .50(sec) ;
  56:  CALL READ_SCORE    ;
  57:  IF R[54:ABOVE_THRESH]=1,JMP LBL[32] ;
  58:  IF R[57:CUR_SCORE]>=R[53:MINIMUM_THRESH],JMP LBL[31] ;
  59:  JMP LBL[34] ;
  60:   ;
  61:  ! Entered quality threshold ;
  62:  LBL[31] ;
  63:  R[54:ABOVE_THRESH]=1    ;
  64:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  65:  PR[22]=PR[21]    ;
  66:  JMP LBL[34] ;
  67:   ;
  68:  ! In quality threshold - NEW BEST ;
  69:  LBL[32] ;
  70:  IF R[57:CUR_SCORE]<=R[55:BEST_SCORE],JMP LBL[33] ;
  71:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  72:  PR[22]=PR[21]    ;
  73:  JMP LBL[34] ;
  74:   ;
  75:  ! Significant downturn check ;
  76:  LBL[33] ;
  77:  R[58:CUR_DROP]=R[55:BEST_SCORE]-R[57:CUR_SCORE]    ;
  78:  IF R[58:CUR_DROP]>R[56:DOWN_THRESH],JMP LBL[35] ;
  79:  JMP LBL[34] ;
  80:   ;
  81:  ! Iterate and call next step ;
  82:  LBL[34] ;
  83:  R[50:STEP_CNT]=R[50:STEP_CNT]+1    ;
  84:  IF R[50:STEP_CNT]>=R[51:MAX_STEP_CNT],JMP LBL[37] ;
  85:  PR[21,6]=PR[21,6]+R[52:TURN_PER_STEP]    ;
  86:  JMP LBL[30] ;
  87:   ;
  88:  ! Found Peak ;
  89:  LBL[35] ;
  90:L PR[22] 200mm/sec CNT100    ;
  91:  JMP LBL[36] ;
  92:   ;
  93:  ! Fail Case: No Match ;
  94:  LBL[37] ;
  95:  JMP LBL[996] ;
  96:   ;
  97:  ! Done (don't forget to maintain ;
  98:  ! rotation values ;
  99:  LBL[36] ;
 100:  PR[6,6:MOD_RCP_PSN]=PR[22,6]    ;
 101:   ;
 102:  WAIT   3.00(sec) ;
 103:   ;
 104:  ! Move to Cable Module ;
 105:J PR[6:MOD_RCP_PSN] 100% FINE    ;
 106:   ;
 107:  ! Descend with receptacle ;
 108:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
 109:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
 110:L PR[4:TMP_MOD_RCP] 40mm/sec FINE    ;
 111:   ;
 112:  ! Ascend without receptacle ;
 113:L PR[6:MOD_RCP_PSN] 40mm/sec FINE    ;
 114:   ;
 115:   ;
 116:   ;
 117:  !!! CHECK REPO STATUS START ;
 118:  IF R[1:REPO_RCP_X]=22 AND R[2:REPO_RCP_Y]=20,JMP LBL[999] ;
 119:   ;
 120:  ! Not empty so update ;
 121:  R[1:REPO_RCP_X]=R[1:REPO_RCP_X]+1    ;
 122:  IF R[1:REPO_RCP_X]>22,JMP LBL[2] ;
 123:   ;
 124:  ! Update position x ;
 125:  PR[5,1:REPO_RCP_PSN]=PR[5,1:REPO_RCP_PSN]+R[3:REPO_RCP_UOFFSET]    ;
 126:  JMP LBL[1] ;
 127:   ;
 128:  ! Next row x overflow ;
 129:  LBL[2] ;
 130:  R[1:REPO_RCP_X]=1    ;
 131:  R[2:REPO_RCP_Y]=R[2:REPO_RCP_Y]+1    ;
 132:  PR[5,1:REPO_RCP_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 133:  PR[5,2:REPO_RCP_PSN]=PR[5,2:REPO_RCP_PSN]-R[3:REPO_RCP_UOFFSET]    ;
 134:  JMP LBL[1] ;
 135:   ;
 136:  ! Switched from receptacle repo ;
 137:  ! to receptacle repo ;
 138:  LBL[999] ;
 139:  R[1:REPO_RCP_X]=1    ;
 140:  R[2:REPO_RCP_Y]=1    ;
 141:  IF R[4:REPO_X]=2 AND R[18:REPO_Y]=2,JMP LBL[996] ;
 142:   ;
 143:  R[4:REPO_X]=R[4:REPO_X]+1    ;
 144:  IF R[4:REPO_X]>2,JMP LBL[7] ;
 145:   ;
 146:  ! next repository column ;
 147:  PR[9,1:REPO_PSN]=PR[9,1:REPO_PSN]+R[19:REPO_XOFFSET]    ;
 148:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 149:  JMP LBL[1] ;
 150:   ;
 151:  ! next repository row ;
 152:  LBL[7] ;
 153:  R[4:REPO_X]=1    ;
 154:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
 155:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 156:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]+R[20:REPO_YOFFSET]    ;
 157:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 158:  JMP LBL[1] ;
 159:  !!! CHECK REPO STATUS END. ;
 160:   ;
 161:   ;
 162:   ;
 163:  !!! CHECK TO SEE CURRENT RECIPE S ;
 164:  LBL[1] ;
 165:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 166:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 167:   ;
 168:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 169:   ;
 170:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 171:  JMP LBL[4] ;
 172:   ;
 173:  LBL[5] ;
 174:  R[8:MOD_RCP_X]=1    ;
 175:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 176:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 177:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 178:  JMP LBL[4] ;
 179:  !!! CHECK TO SEE CURRENT RECIPE ;
 180:  !!! END ;
 181:   ;
 182:   ;
 183:   ;
 184:  !!! MODULE FULL, CHECK STATUS ;
 185:  !!! START ;
 186:  LBL[998] ;
 187:  R[11:RECIPE_IO_IDX]=1    ;
 188:  R[8:MOD_RCP_X]=1    ;
 189:  R[9:MOD_RCP_Y]=1    ;
 190:   ;
 191:  ! Check to see if Ice Tray Full ;
 192:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 193:   ;
 194:  ! Check if module row full ;
 195:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 196:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 197:   ;
 198:  ! Increment module column ;
 199:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 200:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 201:  JMP LBL[4] ;
 202:   ;
 203:  ! Increment module row and reset  ;
 204:  LBL[6] ;
 205:  R[5:MODULE_X]=1    ;
 206:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 207:  PR[10:TMP_MOD_RCP]=P[4:FIRST_RCP]    ;
 208:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 209:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]+R[14:MODULE_YOFFSET]    ;
 210:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 211:  JMP LBL[4] ;
 212:   ;
 213:  ! Switched from ice tray ;
 214:  ! to ice tray ;
 215:  LBL[997] ;
 216:  ! Check am I out of Ice Trays ;
 217:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 218:   ;
 219:  ! Increment Ice Tray and set mod ;
 220:  ! and mod_rcp equal ;
 221:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 222:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]+R[17:ICE_TRAY_YOFFSET]    ;
 223:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 224:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 225:  JMP LBL[4] ;
 226:  !!! MODULE FULL, CHECK STATUS ;
 227:  !!! END ;
 228:   ;
 229:  LBL[996] ;
 230:  END ;
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
