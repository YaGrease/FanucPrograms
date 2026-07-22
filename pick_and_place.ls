/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 6048;
CREATE		= DATE 26-07-21  TIME 14:30:52;
MODIFIED	= DATE 26-07-21  TIME 14:30:52;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 278;
MEMORY_SIZE	= 6604;
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
  20:J PR[5:REPO_RCP_PSN] 100% CNT50    ;
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
  36:J PR[3:TMP_CAMERA] 100% FINE ACC70    ;
  37:   ;
  38:   ;
  39:   ;
  40:  ! initiate camera code ;
  41:  R[50:STEP_CNT]=0    ;
  42:  R[51:MAX_STEP_CNT]=47    ;
  43:  R[52:TURN_PER_STEP]=8    ;
  44:  R[53:MINIMUM_THRESH]=89    ;
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
  56:  MESSAGE[FAILED PICK] ;
  57:  IF R[24:PICK_CNT_ERR]=2,JMP LBL[38] ;
  58:  R[24:PICK_CNT_ERR]=R[24:PICK_CNT_ERR]+1    ;
  59:  JMP LBL[24] ;
  60:   ;
  61:  ! FIND BEST ORIENTATION ;
  62:  ! Rotate to next step ;
  63:  LBL[30] ;
  64:  R[24:PICK_CNT_ERR]=0    ;
  65:L PR[21] 1500deg/sec FINE    ;
  66:  WAIT    .05(sec) ;
  67:  CALL READ_SCORE    ;
  68:  IF R[57:CUR_SCORE]>R[55:BEST_SCORE],JMP LBL[31] ;
  69:  IF R[54:ABOVE_THRESH]=1,JMP LBL[33] ;
  70:  JMP LBL[34] ;
  71:   ;
  72:  ! Entered quality threshold ;
  73:  LBL[31] ;
  74:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  75:  PR[22]=PR[21]    ;
  76:  IF R[57:CUR_SCORE]>R[53:MINIMUM_THRESH],JMP LBL[32] ;
  77:  JMP LBL[34] ;
  78:   ;
  79:  ! In quality threshold - NEW BEST ;
  80:  LBL[32] ;
  81:  R[54:ABOVE_THRESH]=1    ;
  82:  JMP LBL[34] ;
  83:   ;
  84:  ! Significant downturn check ;
  85:  LBL[33] ;
  86:  R[58:CUR_DROP]=R[55:BEST_SCORE]-R[57:CUR_SCORE]    ;
  87:  IF R[58:CUR_DROP]>R[56:DOWN_THRESH],JMP LBL[35] ;
  88:  JMP LBL[34] ;
  89:   ;
  90:  ! Iterate and call next step ;
  91:  LBL[34] ;
  92:  R[50:STEP_CNT]=R[50:STEP_CNT]+1    ;
  93:  IF R[50:STEP_CNT]>=R[51:MAX_STEP_CNT],JMP LBL[37] ;
  94:  PR[21,6]=PR[21,6]+R[52:TURN_PER_STEP]    ;
  95:  JMP LBL[30] ;
  96:   ;
  97:  ! Found Peak or no match ;
  98:  LBL[35] ;
  99:J PR[22] 100% CNT100    ;
 100:  JMP LBL[36] ;
 101:   ;
 102:  ! Fail Case: No Match ;
 103:  LBL[37] ;
 104:  MESSAGE[NO HIGH MATCH] ;
 105:J PR[22] 100% CNT100    ;
 106:  JMP LBL[36] ;
 107:   ;
 108:  ! Done (don't forget to maintain ;
 109:  ! rotation values ;
 110:  LBL[36] ;
 111:  PR[6,6:MOD_RCP_PSN]=PR[22,6]    ;
 112:   ;
 113:  ! Move out of shroud ;
 114:  PR[20]=PR[3:TMP_CAMERA]    ;
 115:  PR[20,1]=PR[20,1]-25    ;
 116:  PR[20,2]=PR[20,2]-R[23:Y_OFFSET_SHROUD]    ;
 117:  PR[20,6]=PR[22,6]    ;
 118:  LBL[25] ;
 119:J PR[20] 100% CNT30 ACC50    ;
 120:   ;
 121:  ! Move to Cable Module (BEFORE FI ;
 122:J PR[6:MOD_RCP_PSN] 100% CNT10    ;
 123:   ;
 124:  ! Descend with receptacle ;
 125:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
 126:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
 127:L PR[4:TMP_MOD_RCP] 100mm/sec FINE    ;
 128:   ;
 129:  ! Ascend without receptacle ;
 130:L PR[6:MOD_RCP_PSN] 100mm/sec FINE    ;
 131:  ! Move safely back to shroud ;
 132:J PR[20] 100% CNT30 ACC70    ;
 133:  ! Check without receptacle ;
 134:  R[57:CUR_SCORE]=0    ;
 135:J PR[22] 100% FINE ACC70    ;
 136:  CALL READ_SCORE    ;
 137:  IF R[57:CUR_SCORE]=0,JMP LBL[39] ;
 138:  IF R[25:PLACE_CNT_ERR]=2,JMP LBL[28] ;
 139:  R[22:RELEASE_CONSTANT]=R[22:RELEASE_CONSTANT]+.1    ;
 140:  R[25:PLACE_CNT_ERR]=R[25:PLACE_CNT_ERR]+1    ;
 141:  JMP LBL[25] ;
 142:   ;
 143:  LBL[28] ;
 144:  ! Put pin extraction code here. ;
 145:J PR[20] 100% CNT30    ;
 146:J PR[12:RELEASE_ONE] 100% CNT30    ;
 147:J PR[13:RELEASE_TWO] 100% CNT30    ;
 148:  MESSAGE[PLACE FAILED CLEAR PART RESUME] ;
 149:  PAUSE ;
 150:J PR[12:RELEASE_ONE] 100% CNT30    ;
 151:J PR[20] 100% CNT30    ;
 152:  JMP LBL[38] ;
 153:   ;
 154:  LBL[39] ;
 155:  R[25:PLACE_CNT_ERR]=0    ;
 156:   ;
 157:  !!! CHECK REPO STATUS START ;
 158:  LBL[38] ;
 159:  R[22:RELEASE_CONSTANT]=20.2    ;
 160:  IF R[1:REPO_RCP_X]=22 AND R[2:REPO_RCP_Y]=20,JMP LBL[999] ;
 161:   ;
 162:  ! Not empty so update ;
 163:  R[1:REPO_RCP_X]=R[1:REPO_RCP_X]+1    ;
 164:  IF R[1:REPO_RCP_X]>22,JMP LBL[2] ;
 165:   ;
 166:  ! Update position x ;
 167:  PR[5,1:REPO_RCP_PSN]=PR[5,1:REPO_RCP_PSN]+R[3:REPO_RCP_UOFFSET]    ;
 168:  JMP LBL[1] ;
 169:   ;
 170:  ! Next row x overflow ;
 171:  LBL[2] ;
 172:  R[1:REPO_RCP_X]=1    ;
 173:  R[2:REPO_RCP_Y]=R[2:REPO_RCP_Y]+1    ;
 174:  PR[5,1:REPO_RCP_PSN]=PR[9,1:REPO_PSN]    ;
 175:  PR[5,2:REPO_RCP_PSN]=PR[5,2:REPO_RCP_PSN]-R[3:REPO_RCP_UOFFSET]    ;
 176:  JMP LBL[1] ;
 177:   ;
 178:  ! Switched from receptacle repo ;
 179:  ! to receptacle repo ;
 180:  LBL[999] ;
 181:  R[1:REPO_RCP_X]=1    ;
 182:  R[2:REPO_RCP_Y]=1    ;
 183:  IF R[4:REPO_X]=2 AND R[18:REPO_Y]=2,JMP LBL[996] ;
 184:   ;
 185:  R[4:REPO_X]=R[4:REPO_X]+1    ;
 186:  IF R[4:REPO_X]>2,JMP LBL[7] ;
 187:   ;
 188:  ! next repository column ;
 189:  PR[9,1:REPO_PSN]=PR[9,1:REPO_PSN]+R[19:REPO_XOFFSET]    ;
 190:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-.05    ;
 191:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 192:  JMP LBL[1] ;
 193:   ;
 194:  ! next repository row ;
 195:  LBL[7] ;
 196:  R[4:REPO_X]=1    ;
 197:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
 198:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]-.1    ;
 199:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-R[20:REPO_YOFFSET]    ;
 200:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 201:  JMP LBL[1] ;
 202:  !!! CHECK REPO STATUS END. ;
 203:   ;
 204:   ;
 205:   ;
 206:  !!! CHECK TO SEE CURRENT RECIPE S ;
 207:  LBL[1] ;
 208:  IF R[24:PICK_CNT_ERR]=2,JMP LBL[4] ;
 209:  IF R[25:PLACE_CNT_ERR]=2,JMP LBL[4] ;
 210:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 211:  R[99:RECIPE_IDX]=R[99:RECIPE_IDX]+1    ;
 212:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 213:   ;
 214:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 215:   ;
 216:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 217:  JMP LBL[4] ;
 218:   ;
 219:  LBL[5] ;
 220:  R[8:MOD_RCP_X]=1    ;
 221:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 222:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 223:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 224:  JMP LBL[4] ;
 225:  !!! CHECK TO SEE CURRENT RECIPE ;
 226:  !!! END ;
 227:   ;
 228:   ;
 229:   ;
 230:  !!! MODULE FULL, CHECK STATUS ;
 231:  !!! START ;
 232:  LBL[998] ;
 233:  R[11:RECIPE_IO_IDX]=1    ;
 234:  R[99:RECIPE_IDX]=101    ;
 235:  R[8:MOD_RCP_X]=1    ;
 236:  R[9:MOD_RCP_Y]=1    ;
 237:   ;
 238:  ! Check to see if Ice Tray Full ;
 239:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 240:   ;
 241:  ! Check if module row full ;
 242:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 243:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 244:   ;
 245:  ! Increment module column ;
 246:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 247:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 248:  JMP LBL[4] ;
 249:   ;
 250:  ! Increment module row and reset  ;
 251:  LBL[6] ;
 252:  R[5:MODULE_X]=1    ;
 253:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 254:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 255:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]-R[14:MODULE_YOFFSET]    ;
 256:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 257:  JMP LBL[4] ;
 258:   ;
 259:  ! Switched from ice tray ;
 260:  ! to ice tray ;
 261:  LBL[997] ;
 262:  ! Check am I out of Ice Trays ;
 263:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 264:   ;
 265:  ! Increment Ice Tray and set mod ;
 266:  ! and mod_rcp equal ;
 267:  R[5:MODULE_X]=1    ;
 268:  R[15:MODULE_Y]=1    ;
 269:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 270:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]-R[17:ICE_TRAY_YOFFSET]    ;
 271:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 272:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 273:  JMP LBL[4] ;
 274:  !!! MODULE FULL, CHECK STATUS ;
 275:  !!! END ;
 276:   ;
 277:  LBL[996] ;
 278:  END ;
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
