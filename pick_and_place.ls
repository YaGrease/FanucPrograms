/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 5352;
CREATE		= DATE 26-07-09  TIME 17:51:10;
MODIFIED	= DATE 26-07-09  TIME 17:51:10;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 241;
MEMORY_SIZE	= 5928;
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
   2:  IF R[11:RECIPE_IO_IDX]=37,JMP LBL[998] ;
   3:  R[12:RECIPE_OUTPUT]=R[R[99]]    ;
   4:   ;
   5:  ! Checks to see if recipe does ;
   6:  ! not call for receptacle ;
   7:  IF R[12:RECIPE_OUTPUT]=0,JMP LBL[1] ;
   8:   ;
   9:  ! get out of shroud safely ;
  10:J PR[20] 100% CNT100    ;
  11:  ! Move to next pin ;
  12:J PR[5:REPO_RCP_PSN] 100% FINE    ;
  13:   ;
  14:  ! Descend to grab pin ;
  15:  PR[2:TMP_REPO_RCP]=PR[5:REPO_RCP_PSN]    ;
  16:  PR[2,3:TMP_REPO_RCP]=PR[2,3:TMP_REPO_RCP]-R[21:PICKUP_CONSTANT]    ;
  17:L PR[2:TMP_REPO_RCP] 100mm/sec FINE    ;
  18:   ;
  19:  ! Ascend with Pin ;
  20:L PR[5:REPO_RCP_PSN] 100mm/sec FINE    ;
  21:   ;
  22:  ! Move safely to shroud ;
  23:  PR[20]=PR[5:REPO_RCP_PSN]    ;
  24:  PR[20,3]=PR[3,3:TMP_CAMERA]    ;
  25:  PR[20,1]=PR[3,1:TMP_CAMERA]    ;
  26:J PR[20] 100% CNT100    ;
  27:J PR[3:TMP_CAMERA] 100% FINE    ;
  28:   ;
  29:   ;
  30:  ! initiate camera code ;
  31:  R[50:STEP_CNT]=0    ;
  32:  R[51:MAX_STEP_CNT]=47    ;
  33:  R[52:TURN_PER_STEP]=8    ;
  34:  R[53:MINIMUM_THRESH]=90    ;
  35:  R[54:ABOVE_THRESH]=0    ;
  36:  R[55:BEST_SCORE]=0    ;
  37:  R[56:DOWN_THRESH]=2    ;
  38:  R[57:CUR_SCORE]=0    ;
  39:  R[58:CUR_DROP]=0    ;
  40:  PR[21]=PR[3:TMP_CAMERA]    ;
  41:  PR[22]=PR[3:TMP_CAMERA]    ;
  42:   ;
  43:  CALL READ_SCORE    ;
  44:  IF R[57:CUR_SCORE]>0,JMP LBL[30] ;
  45:  MESSAGE[FAILED PICK] ;
  46:  PAUSE ;
  47:  ! FIND BEST ORIENTATION ;
  48:  ! Rotate to next step ;
  49:  LBL[30] ;
  50:L PR[21] 100mm/sec FINE    ;
  51:  WAIT    .02(sec) ;
  52:  CALL READ_SCORE    ;
  53:  IF R[57:CUR_SCORE]>R[55:BEST_SCORE],JMP LBL[31] ;
  54:  IF R[54:ABOVE_THRESH]=1,JMP LBL[33] ;
  55:  JMP LBL[34] ;
  56:   ;
  57:  ! Entered quality threshold ;
  58:  LBL[31] ;
  59:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  60:  PR[22]=PR[21]    ;
  61:  IF R[57:CUR_SCORE]>R[53:MINIMUM_THRESH],JMP LBL[32] ;
  62:  JMP LBL[34] ;
  63:   ;
  64:  ! In quality threshold - NEW BEST ;
  65:  LBL[32] ;
  66:  R[54:ABOVE_THRESH]=1    ;
  67:  JMP LBL[34] ;
  68:   ;
  69:  ! Significant downturn check ;
  70:  LBL[33] ;
  71:  R[58:CUR_DROP]=R[55:BEST_SCORE]-R[57:CUR_SCORE]    ;
  72:  IF R[58:CUR_DROP]>R[56:DOWN_THRESH],JMP LBL[35] ;
  73:  JMP LBL[34] ;
  74:   ;
  75:  ! Iterate and call next step ;
  76:  LBL[34] ;
  77:  R[50:STEP_CNT]=R[50:STEP_CNT]+1    ;
  78:  IF R[50:STEP_CNT]>=R[51:MAX_STEP_CNT],JMP LBL[37] ;
  79:  PR[21,6]=PR[21,6]+R[52:TURN_PER_STEP]    ;
  80:  JMP LBL[30] ;
  81:   ;
  82:  ! Found Peak or no match ;
  83:  LBL[35] ;
  84:J PR[22] 100% FINE    ;
  85:  JMP LBL[36] ;
  86:   ;
  87:  ! Fail Case: No Match ;
  88:  LBL[37] ;
  89:  MESSAGE[NO HIGH MATCH] ;
  90:J PR[22] 100% FINE    ;
  91:  JMP LBL[36] ;
  92:   ;
  93:  ! Done (don't forget to maintain ;
  94:  ! rotation values ;
  95:  LBL[36] ;
  96:  PR[6,6:MOD_RCP_PSN]=PR[22,6]    ;
  97:   ;
  98:   ;
  99:  ! Move out of shroud ;
 100:  PR[20]=PR[3:TMP_CAMERA]    ;
 101:  PR[20,2]=PR[20,2]-R[23]    ;
 102:  PR[20,6]=PR[22,6]    ;
 103:J PR[20] 100% FINE    ;
 104:   ;
 105:  ! Move to Cable Module ;
 106:J PR[6:MOD_RCP_PSN] 100% FINE    ;
 107:   ;
 108:  ! Descend with receptacle ;
 109:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
 110:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
 111:L PR[4:TMP_MOD_RCP] 100mm/sec FINE    ;
 112:   ;
 113:  ! Ascend without receptacle ;
 114:L PR[6:MOD_RCP_PSN] 100mm/sec FINE    ;
 115:  ! Move safely back to shroud ;
 116:J PR[20] 100% FINE    ;
 117:  ! Check without receptacle ;
 118:  R[57:CUR_SCORE]=0    ;
 119:J PR[22] 100% FINE    ;
 120:  CALL READ_SCORE    ;
 121:  IF R[57:CUR_SCORE]=0,JMP LBL[38] ;
 122:  MESSAGE[PLACE FAILED CLEAR PART RESUME] ;
 123:  PAUSE ;
 124:   ;
 125:  !!! CHECK REPO STATUS START ;
 126:  LBL[38] ;
 127:  IF R[1:REPO_RCP_X]=22 AND R[2:REPO_RCP_Y]=20,JMP LBL[999] ;
 128:   ;
 129:  ! Not empty so update ;
 130:  R[1:REPO_RCP_X]=R[1:REPO_RCP_X]+1    ;
 131:  IF R[1:REPO_RCP_X]>22,JMP LBL[2] ;
 132:   ;
 133:  ! Update position x ;
 134:  PR[5,1:REPO_RCP_PSN]=PR[5,1:REPO_RCP_PSN]+R[3:REPO_RCP_UOFFSET]    ;
 135:  JMP LBL[1] ;
 136:   ;
 137:  ! Next row x overflow ;
 138:  LBL[2] ;
 139:  R[1:REPO_RCP_X]=1    ;
 140:  R[2:REPO_RCP_Y]=R[2:REPO_RCP_Y]+1    ;
 141:  PR[5,1:REPO_RCP_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 142:  PR[5,2:REPO_RCP_PSN]=PR[5,2:REPO_RCP_PSN]-R[3:REPO_RCP_UOFFSET]    ;
 143:  JMP LBL[1] ;
 144:   ;
 145:  ! Switched from receptacle repo ;
 146:  ! to receptacle repo ;
 147:  LBL[999] ;
 148:  R[1:REPO_RCP_X]=1    ;
 149:  R[2:REPO_RCP_Y]=1    ;
 150:  IF R[4:REPO_X]=2 AND R[18:REPO_Y]=2,JMP LBL[996] ;
 151:   ;
 152:  R[4:REPO_X]=R[4:REPO_X]+1    ;
 153:  IF R[4:REPO_X]>2,JMP LBL[7] ;
 154:   ;
 155:  ! next repository column ;
 156:  PR[9,1:REPO_PSN]=PR[9,1:REPO_PSN]+R[19:REPO_XOFFSET]    ;
 157:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 158:  JMP LBL[1] ;
 159:   ;
 160:  ! next repository row ;
 161:  LBL[7] ;
 162:  R[4:REPO_X]=1    ;
 163:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
 164:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 165:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-R[20:REPO_YOFFSET]    ;
 166:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 167:  JMP LBL[1] ;
 168:  !!! CHECK REPO STATUS END. ;
 169:   ;
 170:   ;
 171:   ;
 172:  !!! CHECK TO SEE CURRENT RECIPE S ;
 173:  LBL[1] ;
 174:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 175:  R[99]=R[99]+1    ;
 176:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 177:   ;
 178:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 179:   ;
 180:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 181:  JMP LBL[4] ;
 182:   ;
 183:  LBL[5] ;
 184:  R[8:MOD_RCP_X]=1    ;
 185:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 186:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 187:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 188:  JMP LBL[4] ;
 189:  !!! CHECK TO SEE CURRENT RECIPE ;
 190:  !!! END ;
 191:   ;
 192:   ;
 193:   ;
 194:  !!! MODULE FULL, CHECK STATUS ;
 195:  !!! START ;
 196:  LBL[998] ;
 197:  R[11:RECIPE_IO_IDX]=1    ;
 198:  R[99]=101    ;
 199:  R[8:MOD_RCP_X]=1    ;
 200:  R[9:MOD_RCP_Y]=1    ;
 201:   ;
 202:  ! Check to see if Ice Tray Full ;
 203:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 204:   ;
 205:  ! Check if module row full ;
 206:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 207:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 208:   ;
 209:  ! Increment module column ;
 210:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 211:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 212:  JMP LBL[4] ;
 213:   ;
 214:  ! Increment module row and reset  ;
 215:  LBL[6] ;
 216:  R[5:MODULE_X]=1    ;
 217:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 218:  ! error no P[] allowed ;
 219:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 220:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]-R[14:MODULE_YOFFSET]    ;
 221:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 222:  JMP LBL[4] ;
 223:   ;
 224:  ! Switched from ice tray ;
 225:  ! to ice tray ;
 226:  LBL[997] ;
 227:  ! Check am I out of Ice Trays ;
 228:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 229:   ;
 230:  ! Increment Ice Tray and set mod ;
 231:  ! and mod_rcp equal ;
 232:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 233:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]-R[17:ICE_TRAY_YOFFSET]    ;
 234:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 235:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 236:  JMP LBL[4] ;
 237:  !!! MODULE FULL, CHECK STATUS ;
 238:  !!! END ;
 239:   ;
 240:  LBL[996] ;
 241:  END ;
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
