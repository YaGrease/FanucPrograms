/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 5872;
CREATE		= DATE 26-07-16  TIME 15:45:24;
MODIFIED	= DATE 26-07-16  TIME 15:45:24;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 271;
MEMORY_SIZE	= 6456;
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
  17:J PR[20] 100% CNT30    ;
  18:   ;
  19:  ! Move to next pin ;
  20:J PR[5:REPO_RCP_PSN] 100% FINE    ;
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
  33:  PR[20,1]=PR[3,1:TMP_CAMERA]    ;
  34:J PR[20] 100% CNT30    ;
  35:J PR[3:TMP_CAMERA] 100% FINE    ;
  36:   ;
  37:   ;
  38:   ;
  39:  ! initiate camera code ;
  40:  R[50:STEP_CNT]=0    ;
  41:  R[51:MAX_STEP_CNT]=47    ;
  42:  R[52:TURN_PER_STEP]=8    ;
  43:  R[53:MINIMUM_THRESH]=89    ;
  44:  R[54:ABOVE_THRESH]=0    ;
  45:  R[55:BEST_SCORE]=0    ;
  46:  R[56:DOWN_THRESH]=2    ;
  47:  R[57:CUR_SCORE]=0    ;
  48:  R[58:CUR_DROP]=0    ;
  49:  PR[21]=PR[3:TMP_CAMERA]    ;
  50:  PR[22]=PR[3:TMP_CAMERA]    ;
  51:   ;
  52:   ;
  53:  CALL READ_SCORE    ;
  54:  IF R[57:CUR_SCORE]>0,JMP LBL[30] ;
  55:  MESSAGE[FAILED PICK] ;
  56:  IF R[24:PICK_CNT_ERR]=2,JMP LBL[38] ;
  57:  R[24:PICK_CNT_ERR]=R[24:PICK_CNT_ERR]+1    ;
  58:  JMP LBL[24] ;
  59:   ;
  60:  ! FIND BEST ORIENTATION ;
  61:  ! Rotate to next step ;
  62:  LBL[30] ;
  63:  R[24:PICK_CNT_ERR]=0    ;
  64:L PR[21] 1000deg/sec FINE    ;
  65:  WAIT    .02(sec) ;
  66:  CALL READ_SCORE    ;
  67:  IF R[57:CUR_SCORE]>R[55:BEST_SCORE],JMP LBL[31] ;
  68:  IF R[54:ABOVE_THRESH]=1,JMP LBL[33] ;
  69:  JMP LBL[34] ;
  70:   ;
  71:  ! Entered quality threshold ;
  72:  LBL[31] ;
  73:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  74:  PR[22]=PR[21]    ;
  75:  IF R[57:CUR_SCORE]>R[53:MINIMUM_THRESH],JMP LBL[32] ;
  76:  JMP LBL[34] ;
  77:   ;
  78:  ! In quality threshold - NEW BEST ;
  79:  LBL[32] ;
  80:  R[54:ABOVE_THRESH]=1    ;
  81:  JMP LBL[34] ;
  82:   ;
  83:  ! Significant downturn check ;
  84:  LBL[33] ;
  85:  R[58:CUR_DROP]=R[55:BEST_SCORE]-R[57:CUR_SCORE]    ;
  86:  IF R[58:CUR_DROP]>R[56:DOWN_THRESH],JMP LBL[35] ;
  87:  JMP LBL[34] ;
  88:   ;
  89:  ! Iterate and call next step ;
  90:  LBL[34] ;
  91:  R[50:STEP_CNT]=R[50:STEP_CNT]+1    ;
  92:  IF R[50:STEP_CNT]>=R[51:MAX_STEP_CNT],JMP LBL[37] ;
  93:  PR[21,6]=PR[21,6]+R[52:TURN_PER_STEP]    ;
  94:  JMP LBL[30] ;
  95:   ;
  96:  ! Found Peak or no match ;
  97:  LBL[35] ;
  98:J PR[22] 100% CNT30    ;
  99:  JMP LBL[36] ;
 100:   ;
 101:  ! Fail Case: No Match ;
 102:  LBL[37] ;
 103:  MESSAGE[NO HIGH MATCH] ;
 104:J PR[22] 100% CNT30    ;
 105:  JMP LBL[36] ;
 106:   ;
 107:  ! Done (don't forget to maintain ;
 108:  ! rotation values ;
 109:  LBL[36] ;
 110:  PR[6,6:MOD_RCP_PSN]=PR[22,6]    ;
 111:   ;
 112:  ! Move out of shroud ;
 113:  PR[20]=PR[3:TMP_CAMERA]    ;
 114:  PR[20,2]=PR[20,2]-R[23:Y_OFFSET_SHROUD]    ;
 115:  PR[20,6]=PR[22,6]    ;
 116:  LBL[25] ;
 117:J PR[20] 100% CNT30    ;
 118:   ;
 119:  ! Move to Cable Module ;
 120:J PR[6:MOD_RCP_PSN] 100% FINE    ;
 121:   ;
 122:  ! Descend with receptacle ;
 123:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
 124:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
 125:L PR[4:TMP_MOD_RCP] 100mm/sec FINE    ;
 126:   ;
 127:  ! Ascend without receptacle ;
 128:L PR[6:MOD_RCP_PSN] 100mm/sec FINE    ;
 129:  ! Move safely back to shroud ;
 130:J PR[20] 100% CNT30    ;
 131:  ! Check without receptacle ;
 132:  R[57:CUR_SCORE]=0    ;
 133:J PR[22] 100% FINE    ;
 134:  CALL READ_SCORE    ;
 135:  IF R[57:CUR_SCORE]=0,JMP LBL[38] ;
 136:  IF R[25:PLACE_CNT_ERR]=2,JMP LBL[28] ;
 137:  R[25:PLACE_CNT_ERR]=R[25:PLACE_CNT_ERR]+1    ;
 138:  JMP LBL[25] ;
 139:   ;
 140:  LBL[28] ;
 141:  ! Put pin extraction code here. ;
 142:J PR[20] 100% CNT30    ;
 143:J PR[12:RELEASE_ONE] 100% CNT30    ;
 144:J PR[13:RELEASE_TWO] 100% CNT30    ;
 145:  MESSAGE[PLACE FAILED CLEAR PART RESUME] ;
 146:  PAUSE ;
 147:J PR[12:RELEASE_ONE] 100% CNT30    ;
 148:J PR[20] 100% CNT30    ;
 149:   ;
 150:   ;
 151:  !!! CHECK REPO STATUS START ;
 152:  LBL[38] ;
 153:  IF R[1:REPO_RCP_X]=22 AND R[2:REPO_RCP_Y]=20,JMP LBL[999] ;
 154:   ;
 155:  ! Not empty so update ;
 156:  R[1:REPO_RCP_X]=R[1:REPO_RCP_X]+1    ;
 157:  IF R[1:REPO_RCP_X]>22,JMP LBL[2] ;
 158:   ;
 159:  ! Update position x ;
 160:  PR[5,1:REPO_RCP_PSN]=PR[5,1:REPO_RCP_PSN]+R[3:REPO_RCP_UOFFSET]    ;
 161:  JMP LBL[1] ;
 162:   ;
 163:  ! Next row x overflow ;
 164:  LBL[2] ;
 165:  R[1:REPO_RCP_X]=1    ;
 166:  R[2:REPO_RCP_Y]=R[2:REPO_RCP_Y]+1    ;
 167:  PR[5,1:REPO_RCP_PSN]=PR[9,1:REPO_PSN]    ;
 168:  PR[5,2:REPO_RCP_PSN]=PR[5,2:REPO_RCP_PSN]-R[3:REPO_RCP_UOFFSET]    ;
 169:  JMP LBL[1] ;
 170:   ;
 171:  ! Switched from receptacle repo ;
 172:  ! to receptacle repo ;
 173:  LBL[999] ;
 174:  R[1:REPO_RCP_X]=1    ;
 175:  R[2:REPO_RCP_Y]=1    ;
 176:  IF R[4:REPO_X]=2 AND R[18:REPO_Y]=2,JMP LBL[996] ;
 177:   ;
 178:  R[4:REPO_X]=R[4:REPO_X]+1    ;
 179:  IF R[4:REPO_X]>2,JMP LBL[7] ;
 180:   ;
 181:  ! next repository column ;
 182:  PR[9,1:REPO_PSN]=PR[9,1:REPO_PSN]+R[19:REPO_XOFFSET]    ;
 183:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-.05    ;
 184:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 185:  JMP LBL[1] ;
 186:   ;
 187:  ! next repository row ;
 188:  LBL[7] ;
 189:  R[4:REPO_X]=1    ;
 190:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
 191:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]-.1    ;
 192:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-R[20:REPO_YOFFSET]    ;
 193:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 194:  JMP LBL[1] ;
 195:  !!! CHECK REPO STATUS END. ;
 196:   ;
 197:   ;
 198:   ;
 199:  !!! CHECK TO SEE CURRENT RECIPE S ;
 200:  LBL[1] ;
 201:  IF R[24:PICK_CNT_ERR]=2,JMP LBL[4] ;
 202:  IF R[25:PLACE_CNT_ERR]=2,JMP LBL[4] ;
 203:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 204:  R[99:RECIPE_IDX]=R[99:RECIPE_IDX]+1    ;
 205:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 206:   ;
 207:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 208:   ;
 209:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 210:  JMP LBL[4] ;
 211:   ;
 212:  LBL[5] ;
 213:  R[8:MOD_RCP_X]=1    ;
 214:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 215:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 216:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 217:  JMP LBL[4] ;
 218:  !!! CHECK TO SEE CURRENT RECIPE ;
 219:  !!! END ;
 220:   ;
 221:   ;
 222:   ;
 223:  !!! MODULE FULL, CHECK STATUS ;
 224:  !!! START ;
 225:  LBL[998] ;
 226:  R[11:RECIPE_IO_IDX]=1    ;
 227:  R[99:RECIPE_IDX]=101    ;
 228:  R[8:MOD_RCP_X]=1    ;
 229:  R[9:MOD_RCP_Y]=1    ;
 230:   ;
 231:  ! Check to see if Ice Tray Full ;
 232:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 233:   ;
 234:  ! Check if module row full ;
 235:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 236:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 237:   ;
 238:  ! Increment module column ;
 239:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 240:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 241:  JMP LBL[4] ;
 242:   ;
 243:  ! Increment module row and reset  ;
 244:  LBL[6] ;
 245:  R[5:MODULE_X]=1    ;
 246:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 247:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 248:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]-R[14:MODULE_YOFFSET]    ;
 249:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 250:  JMP LBL[4] ;
 251:   ;
 252:  ! Switched from ice tray ;
 253:  ! to ice tray ;
 254:  LBL[997] ;
 255:  ! Check am I out of Ice Trays ;
 256:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 257:   ;
 258:  ! Increment Ice Tray and set mod ;
 259:  ! and mod_rcp equal ;
 260:  R[5:MODULE_X]=1    ;
 261:  R[15:MODULE_Y]=1    ;
 262:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 263:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]-R[17:ICE_TRAY_YOFFSET]    ;
 264:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 265:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 266:  JMP LBL[4] ;
 267:  !!! MODULE FULL, CHECK STATUS ;
 268:  !!! END ;
 269:   ;
 270:  LBL[996] ;
 271:  END ;
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
