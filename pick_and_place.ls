/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 5932;
CREATE		= DATE 26-07-17  TIME 12:08:32;
MODIFIED	= DATE 26-07-17  TIME 12:08:32;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 272;
MEMORY_SIZE	= 6512;
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
  35:J PR[20] 100% CNT28 ACC80    ;
  36:J PR[3:TMP_CAMERA] 100% FINE    ;
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
  66:  WAIT    .02(sec) ;
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
 115:  PR[20,2]=PR[20,2]-R[23:Y_OFFSET_SHROUD]    ;
 116:  PR[20,6]=PR[22,6]    ;
 117:  LBL[25] ;
 118:J PR[20] 100% CNT30 ACC50    ;
 119:   ;
 120:  ! Move to Cable Module (BEFORE FI ;
 121:J PR[6:MOD_RCP_PSN] 100% CNT10    ;
 122:   ;
 123:  ! Descend with receptacle ;
 124:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
 125:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
 126:L PR[4:TMP_MOD_RCP] 100mm/sec FINE    ;
 127:   ;
 128:  ! Ascend without receptacle ;
 129:L PR[6:MOD_RCP_PSN] 100mm/sec FINE    ;
 130:  ! Move safely back to shroud ;
 131:J PR[20] 100% CNT40    ;
 132:  ! Check without receptacle ;
 133:  R[57:CUR_SCORE]=0    ;
 134:J PR[22] 100% FINE    ;
 135:  CALL READ_SCORE    ;
 136:  IF R[57:CUR_SCORE]=0,JMP LBL[38] ;
 137:  IF R[25:PLACE_CNT_ERR]=2,JMP LBL[28] ;
 138:  R[25:PLACE_CNT_ERR]=R[25:PLACE_CNT_ERR]+1    ;
 139:  JMP LBL[25] ;
 140:   ;
 141:  LBL[28] ;
 142:  ! Put pin extraction code here. ;
 143:J PR[20] 100% CNT30    ;
 144:J PR[12:RELEASE_ONE] 100% CNT30    ;
 145:J PR[13:RELEASE_TWO] 100% CNT30    ;
 146:  MESSAGE[PLACE FAILED CLEAR PART RESUME] ;
 147:  PAUSE ;
 148:J PR[12:RELEASE_ONE] 100% CNT30    ;
 149:J PR[20] 100% CNT30    ;
 150:   ;
 151:   ;
 152:  !!! CHECK REPO STATUS START ;
 153:  LBL[38] ;
 154:  IF R[1:REPO_RCP_X]=22 AND R[2:REPO_RCP_Y]=20,JMP LBL[999] ;
 155:   ;
 156:  ! Not empty so update ;
 157:  R[1:REPO_RCP_X]=R[1:REPO_RCP_X]+1    ;
 158:  IF R[1:REPO_RCP_X]>22,JMP LBL[2] ;
 159:   ;
 160:  ! Update position x ;
 161:  PR[5,1:REPO_RCP_PSN]=PR[5,1:REPO_RCP_PSN]+R[3:REPO_RCP_UOFFSET]    ;
 162:  JMP LBL[1] ;
 163:   ;
 164:  ! Next row x overflow ;
 165:  LBL[2] ;
 166:  R[1:REPO_RCP_X]=1    ;
 167:  R[2:REPO_RCP_Y]=R[2:REPO_RCP_Y]+1    ;
 168:  PR[5,1:REPO_RCP_PSN]=PR[9,1:REPO_PSN]    ;
 169:  PR[5,2:REPO_RCP_PSN]=PR[5,2:REPO_RCP_PSN]-R[3:REPO_RCP_UOFFSET]    ;
 170:  JMP LBL[1] ;
 171:   ;
 172:  ! Switched from receptacle repo ;
 173:  ! to receptacle repo ;
 174:  LBL[999] ;
 175:  R[1:REPO_RCP_X]=1    ;
 176:  R[2:REPO_RCP_Y]=1    ;
 177:  IF R[4:REPO_X]=2 AND R[18:REPO_Y]=2,JMP LBL[996] ;
 178:   ;
 179:  R[4:REPO_X]=R[4:REPO_X]+1    ;
 180:  IF R[4:REPO_X]>2,JMP LBL[7] ;
 181:   ;
 182:  ! next repository column ;
 183:  PR[9,1:REPO_PSN]=PR[9,1:REPO_PSN]+R[19:REPO_XOFFSET]    ;
 184:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-.05    ;
 185:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 186:  JMP LBL[1] ;
 187:   ;
 188:  ! next repository row ;
 189:  LBL[7] ;
 190:  R[4:REPO_X]=1    ;
 191:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
 192:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]-.1    ;
 193:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-R[20:REPO_YOFFSET]    ;
 194:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 195:  JMP LBL[1] ;
 196:  !!! CHECK REPO STATUS END. ;
 197:   ;
 198:   ;
 199:   ;
 200:  !!! CHECK TO SEE CURRENT RECIPE S ;
 201:  LBL[1] ;
 202:  IF R[24:PICK_CNT_ERR]=2,JMP LBL[4] ;
 203:  IF R[25:PLACE_CNT_ERR]=2,JMP LBL[4] ;
 204:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 205:  R[99:RECIPE_IDX]=R[99:RECIPE_IDX]+1    ;
 206:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 207:   ;
 208:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 209:   ;
 210:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 211:  JMP LBL[4] ;
 212:   ;
 213:  LBL[5] ;
 214:  R[8:MOD_RCP_X]=1    ;
 215:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 216:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 217:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 218:  JMP LBL[4] ;
 219:  !!! CHECK TO SEE CURRENT RECIPE ;
 220:  !!! END ;
 221:   ;
 222:   ;
 223:   ;
 224:  !!! MODULE FULL, CHECK STATUS ;
 225:  !!! START ;
 226:  LBL[998] ;
 227:  R[11:RECIPE_IO_IDX]=1    ;
 228:  R[99:RECIPE_IDX]=101    ;
 229:  R[8:MOD_RCP_X]=1    ;
 230:  R[9:MOD_RCP_Y]=1    ;
 231:   ;
 232:  ! Check to see if Ice Tray Full ;
 233:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 234:   ;
 235:  ! Check if module row full ;
 236:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 237:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 238:   ;
 239:  ! Increment module column ;
 240:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 241:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 242:  JMP LBL[4] ;
 243:   ;
 244:  ! Increment module row and reset  ;
 245:  LBL[6] ;
 246:  R[5:MODULE_X]=1    ;
 247:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 248:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 249:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]-R[14:MODULE_YOFFSET]    ;
 250:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 251:  JMP LBL[4] ;
 252:   ;
 253:  ! Switched from ice tray ;
 254:  ! to ice tray ;
 255:  LBL[997] ;
 256:  ! Check am I out of Ice Trays ;
 257:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 258:   ;
 259:  ! Increment Ice Tray and set mod ;
 260:  ! and mod_rcp equal ;
 261:  R[5:MODULE_X]=1    ;
 262:  R[15:MODULE_Y]=1    ;
 263:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 264:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]-R[17:ICE_TRAY_YOFFSET]    ;
 265:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 266:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 267:  JMP LBL[4] ;
 268:  !!! MODULE FULL, CHECK STATUS ;
 269:  !!! END ;
 270:   ;
 271:  LBL[996] ;
 272:  END ;
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
