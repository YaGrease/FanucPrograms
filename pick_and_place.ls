/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 6086;
CREATE		= DATE 26-07-28  TIME 13:35:38;
MODIFIED	= DATE 26-07-28  TIME 13:35:38;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 279;
MEMORY_SIZE	= 6638;
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
   1:  ! Main driving loop ;
   2:  LBL[4:PP_LOOP] ;
   3:   ;
   4:  ! Reset Error Checking ;
   5:  R[24:PICK_CNT_ERR]=0    ;
   6:  R[25:PLACE_CNT_ERR]=0    ;
   7:   ;
   8:  ! Check for recipe reset ;
   9:  IF R[11:RECIPE_IO_IDX]=37,JMP LBL[998] ;
  10:  R[12:RECIPE_OUTPUT]=R[R[99]]    ;
  11:   ;
  12:  ! Checks next recipe output ;
  13:  IF R[12:RECIPE_OUTPUT]=0,JMP LBL[1] ;
  14:   ;
  15:  LBL[24] ;
  16:  ! get out of shroud safely ;
  17:J PR[20] 100% CNT30 ACC50    ;
  18:   ;
  19:  ! Move to next pin (FINE BEFORE) ;
  20:J PR[5:REPO_RCP_PSN] 100% CNT50 ACC50    ;
  21:   ;
  22:  ! Descend to grab pin ;
  23:  PR[2:TMP_REPO_RCP]=PR[5:REPO_RCP_PSN]    ;
  24:  PR[2,3:TMP_REPO_RCP]=PR[2,3:TMP_REPO_RCP]-R[21:PICKUP_CONSTANT]    ;
  25:L PR[2:TMP_REPO_RCP] 100mm/sec FINE    ;
  26:   ;
  27:  ! Ascend with Pin ;
  28:L PR[5:REPO_RCP_PSN] 100mm/sec FINE    ;
  29:   ;
  30:  ! Move safely to shroud ;
  31:  PR[20]=PR[5:REPO_RCP_PSN]    ;
  32:  PR[20,3]=PR[3,3:TMP_CAMERA]    ;
  33:  PR[20,1]=PR[3,1:TMP_CAMERA]-25    ;
  34:  ! (FINE BEFORE) ;
  35:J PR[20] 100% CNT25 ACC70    ;
  36:J PR[3:TMP_CAMERA] 100% FINE ACC50    ;
  37:   ;
  38:   ;
  39:   ;
  40:  ! initiate camera code ;
  41:  R[50:STEP_CNT]=0    ;
  42:  R[51:MAX_STEP_CNT]=47    ;
  43:  R[52:TURN_PER_STEP]=8    ;
  44:  R[53:MINIMUM_THRESH]=88    ;
  45:  R[54:ABOVE_THRESH]=0    ;
  46:  R[55:BEST_SCORE]=0    ;
  47:  R[56:DOWN_THRESH]=2    ;
  48:  R[57:CUR_SCORE]=0    ;
  49:  R[58:CUR_DROP]=0    ;
  50:  PR[21]=PR[3:TMP_CAMERA]    ;
  51:  PR[22]=PR[3:TMP_CAMERA]    ;
  52:   ;
  53:   ;
  54:  CALL READ_SCORE    ;
  55:  IF R[57:CUR_SCORE]>0,JMP LBL[30] ;
  56:  R[26:FAILED_PICK_CNT]=R[26:FAILED_PICK_CNT]+1    ;
  57:  MESSAGE[FAILED PICK] ;
  58:  IF R[24:PICK_CNT_ERR]=2,JMP LBL[38] ;
  59:  R[24:PICK_CNT_ERR]=R[24:PICK_CNT_ERR]+1    ;
  60:  JMP LBL[24] ;
  61:   ;
  62:  ! FIND BEST ORIENTATION ;
  63:  ! Rotate to next step ;
  64:  LBL[30] ;
  65:  R[24:PICK_CNT_ERR]=0    ;
  66:L PR[21] 2000deg/sec FINE    ;
  67:  WAIT    .08(sec) ;
  68:  CALL READ_SCORE    ;
  69:  IF R[57:CUR_SCORE]>R[55:BEST_SCORE],JMP LBL[31] ;
  70:  IF R[54:ABOVE_THRESH]=1,JMP LBL[33] ;
  71:  JMP LBL[34] ;
  72:   ;
  73:  ! Entered quality threshold ;
  74:  LBL[31] ;
  75:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  76:  PR[22]=PR[21]    ;
  77:  IF R[57:CUR_SCORE]>R[53:MINIMUM_THRESH],JMP LBL[32] ;
  78:  JMP LBL[34] ;
  79:   ;
  80:  ! In quality threshold - NEW BEST ;
  81:  LBL[32] ;
  82:  R[54:ABOVE_THRESH]=1    ;
  83:  JMP LBL[34] ;
  84:   ;
  85:  ! Significant downturn check ;
  86:  LBL[33] ;
  87:  R[58:CUR_DROP]=R[55:BEST_SCORE]-R[57:CUR_SCORE]    ;
  88:  IF R[58:CUR_DROP]>R[56:DOWN_THRESH],JMP LBL[35] ;
  89:  JMP LBL[34] ;
  90:   ;
  91:  ! Iterate and call next step ;
  92:  LBL[34] ;
  93:  R[50:STEP_CNT]=R[50:STEP_CNT]+1    ;
  94:  IF R[50:STEP_CNT]>=R[51:MAX_STEP_CNT],JMP LBL[37] ;
  95:  PR[21,6]=PR[21,6]+R[52:TURN_PER_STEP]    ;
  96:  JMP LBL[30] ;
  97:   ;
  98:  ! Found Peak or no match ;
  99:  LBL[35] ;
 100:J PR[22] 100% CNT100 ACC70    ;
 101:  JMP LBL[36] ;
 102:   ;
 103:  ! Fail Case: No Match ;
 104:  LBL[37] ;
 105:  MESSAGE[NO HIGH MATCH] ;
 106:J PR[22] 100% CNT100 ACC70    ;
 107:  JMP LBL[36] ;
 108:   ;
 109:  ! Done (don't forget to maintain ;
 110:  ! rotation values ;
 111:  LBL[36] ;
 112:  PR[6,6:MOD_RCP_PSN]=PR[22,6]    ;
 113:   ;
 114:  ! Move out of shroud ;
 115:  PR[20]=PR[3:TMP_CAMERA]    ;
 116:  PR[20,1]=PR[20,1]-25    ;
 117:  PR[20,2]=PR[20,2]-R[23:Y_OFFSET_SHROUD]    ;
 118:  PR[20,6]=PR[22,6]    ;
 119:  LBL[25] ;
 120:J PR[20] 100% CNT30 ACC50    ;
 121:   ;
 122:  ! Move to Cable Module (BEFORE FI ;
 123:J PR[6:MOD_RCP_PSN] 100% CNT10 ACC70    ;
 124:   ;
 125:  ! Descend with receptacle ;
 126:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
 127:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
 128:L PR[4:TMP_MOD_RCP] 100mm/sec FINE    ;
 129:   ;
 130:  ! Ascend without receptacle ;
 131:L PR[6:MOD_RCP_PSN] 100mm/sec FINE    ;
 132:  ! Move safely back to shroud ;
 133:J PR[20] 100% CNT30 ACC70    ;
 134:  ! Check without receptacle ;
 135:  R[57:CUR_SCORE]=0    ;
 136:J PR[22] 100% FINE ACC70    ;
 137:  CALL READ_SCORE    ;
 138:  IF R[57:CUR_SCORE]=0,JMP LBL[39] ;
 139:  IF R[25:PLACE_CNT_ERR]=2,JMP LBL[28] ;
 140:  R[22:RELEASE_CONSTANT]=R[22:RELEASE_CONSTANT]+.1    ;
 141:  R[25:PLACE_CNT_ERR]=R[25:PLACE_CNT_ERR]+1    ;
 142:  JMP LBL[25] ;
 143:   ;
 144:  LBL[28] ;
 145:  ! Put pin extraction code here. ;
 146:J PR[20] 100% CNT30 ACC70    ;
 147:J PR[12:RELEASE_ONE] 100% CNT30 ACC70    ;
 148:J PR[13:RELEASE_TWO] 100% CNT30 ACC70    ;
 149:  MESSAGE[PLACE FAILED CLEAR PART RESUME] ;
 150:  PAUSE ;
 151:J PR[12:RELEASE_ONE] 100% CNT30 ACC70    ;
 152:J PR[20] 100% CNT30 ACC70    ;
 153:  JMP LBL[38] ;
 154:   ;
 155:  LBL[39] ;
 156:  R[25:PLACE_CNT_ERR]=0    ;
 157:   ;
 158:  !!! CHECK REPO STATUS START ;
 159:  LBL[38] ;
 160:  R[22:RELEASE_CONSTANT]=20.2    ;
 161:  IF R[1:REPO_RCP_X]=22 AND R[2:REPO_RCP_Y]=20,JMP LBL[999] ;
 162:   ;
 163:  ! Not empty so update ;
 164:  R[1:REPO_RCP_X]=R[1:REPO_RCP_X]+1    ;
 165:  IF R[1:REPO_RCP_X]>22,JMP LBL[2] ;
 166:   ;
 167:  ! Update position x ;
 168:  PR[5,1:REPO_RCP_PSN]=PR[5,1:REPO_RCP_PSN]+R[3:REPO_RCP_UOFFSET]    ;
 169:  JMP LBL[1] ;
 170:   ;
 171:  ! Next row x overflow ;
 172:  LBL[2] ;
 173:  R[1:REPO_RCP_X]=1    ;
 174:  R[2:REPO_RCP_Y]=R[2:REPO_RCP_Y]+1    ;
 175:  PR[5,1:REPO_RCP_PSN]=PR[9,1:REPO_PSN]    ;
 176:  PR[5,2:REPO_RCP_PSN]=PR[5,2:REPO_RCP_PSN]-R[3:REPO_RCP_UOFFSET]    ;
 177:  JMP LBL[1] ;
 178:   ;
 179:  ! Switched from receptacle repo ;
 180:  ! to receptacle repo ;
 181:  LBL[999] ;
 182:  R[1:REPO_RCP_X]=1    ;
 183:  R[2:REPO_RCP_Y]=1    ;
 184:  IF R[4:REPO_X]=2 AND R[18:REPO_Y]=2,JMP LBL[996] ;
 185:   ;
 186:  R[4:REPO_X]=R[4:REPO_X]+1    ;
 187:  IF R[4:REPO_X]>2,JMP LBL[7] ;
 188:   ;
 189:  ! next repository column ;
 190:  PR[9,1:REPO_PSN]=PR[9,1:REPO_PSN]+R[19:REPO_XOFFSET]    ;
 191:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-.05    ;
 192:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 193:  JMP LBL[1] ;
 194:   ;
 195:  ! next repository row ;
 196:  LBL[7] ;
 197:  R[4:REPO_X]=1    ;
 198:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
 199:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]-.1    ;
 200:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-R[20:REPO_YOFFSET]    ;
 201:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 202:  JMP LBL[1] ;
 203:  !!! CHECK REPO STATUS END. ;
 204:   ;
 205:   ;
 206:   ;
 207:  !!! CHECK TO SEE CURRENT RECIPE S ;
 208:  LBL[1] ;
 209:  IF R[24:PICK_CNT_ERR]=2,JMP LBL[4] ;
 210:  IF R[25:PLACE_CNT_ERR]=2,JMP LBL[4] ;
 211:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 212:  R[99:RECIPE_IDX]=R[99:RECIPE_IDX]+1    ;
 213:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 214:   ;
 215:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 216:   ;
 217:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 218:  JMP LBL[4] ;
 219:   ;
 220:  LBL[5] ;
 221:  R[8:MOD_RCP_X]=1    ;
 222:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 223:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 224:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 225:  JMP LBL[4] ;
 226:  !!! CHECK TO SEE CURRENT RECIPE ;
 227:  !!! END ;
 228:   ;
 229:   ;
 230:   ;
 231:  !!! MODULE FULL, CHECK STATUS ;
 232:  !!! START ;
 233:  LBL[998] ;
 234:  R[11:RECIPE_IO_IDX]=1    ;
 235:  R[99:RECIPE_IDX]=101    ;
 236:  R[8:MOD_RCP_X]=1    ;
 237:  R[9:MOD_RCP_Y]=1    ;
 238:   ;
 239:  ! Check to see if Ice Tray Full ;
 240:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 241:   ;
 242:  ! Check if module row full ;
 243:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 244:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 245:   ;
 246:  ! Increment module column ;
 247:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 248:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 249:  JMP LBL[4] ;
 250:   ;
 251:  ! Increment module row and reset  ;
 252:  LBL[6] ;
 253:  R[5:MODULE_X]=1    ;
 254:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 255:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 256:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]-R[14:MODULE_YOFFSET]    ;
 257:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 258:  JMP LBL[4] ;
 259:   ;
 260:  ! Switched from ice tray ;
 261:  ! to ice tray ;
 262:  LBL[997] ;
 263:  ! Check am I out of Ice Trays ;
 264:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 265:   ;
 266:  ! Increment Ice Tray and set mod ;
 267:  ! and mod_rcp equal ;
 268:  R[5:MODULE_X]=1    ;
 269:  R[15:MODULE_Y]=1    ;
 270:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 271:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]-R[17:ICE_TRAY_YOFFSET]    ;
 272:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 273:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 274:  JMP LBL[4] ;
 275:  !!! MODULE FULL, CHECK STATUS ;
 276:  !!! END ;
 277:   ;
 278:  LBL[996] ;
 279:  END ;
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
