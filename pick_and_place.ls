/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 5378;
CREATE		= DATE 26-07-10  TIME 12:56:02;
MODIFIED	= DATE 26-07-10  TIME 12:56:02;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 245;
MEMORY_SIZE	= 5938;
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
   4:  ! Check for recipe reset ;
   5:  IF R[11:RECIPE_IO_IDX]=37,JMP LBL[998] ;
   6:  R[12:RECIPE_OUTPUT]=R[R[99]]    ;
   7:   ;
   8:  ! Checks next recipe output ;
   9:  IF R[12:RECIPE_OUTPUT]=0,JMP LBL[1] ;
  10:   ;
  11:  ! get out of shroud safely ;
  12:J PR[20] 100% CNT30    ;
  13:   ;
  14:  ! Move to next pin ;
  15:J PR[5:REPO_RCP_PSN] 100% FINE    ;
  16:   ;
  17:  ! Descend to grab pin ;
  18:  PR[2:TMP_REPO_RCP]=PR[5:REPO_RCP_PSN]    ;
  19:  PR[2,3:TMP_REPO_RCP]=PR[2,3:TMP_REPO_RCP]-R[21:PICKUP_CONSTANT]    ;
  20:L PR[2:TMP_REPO_RCP] 100mm/sec FINE    ;
  21:   ;
  22:  ! Ascend with Pin ;
  23:L PR[5:REPO_RCP_PSN] 100mm/sec FINE    ;
  24:   ;
  25:  ! Move safely to shroud ;
  26:  PR[20]=PR[5:REPO_RCP_PSN]    ;
  27:  PR[20,3]=PR[3,3:TMP_CAMERA]    ;
  28:  PR[20,1]=PR[3,1:TMP_CAMERA]    ;
  29:J PR[20] 100% CNT30    ;
  30:J PR[3:TMP_CAMERA] 100% FINE    ;
  31:   ;
  32:   ;
  33:   ;
  34:  ! initiate camera code ;
  35:  R[50:STEP_CNT]=0    ;
  36:  R[51:MAX_STEP_CNT]=47    ;
  37:  R[52:TURN_PER_STEP]=8    ;
  38:  R[53:MINIMUM_THRESH]=90    ;
  39:  R[54:ABOVE_THRESH]=0    ;
  40:  R[55:BEST_SCORE]=0    ;
  41:  R[56:DOWN_THRESH]=2    ;
  42:  R[57:CUR_SCORE]=0    ;
  43:  R[58:CUR_DROP]=0    ;
  44:  PR[21]=PR[3:TMP_CAMERA]    ;
  45:  PR[22]=PR[3:TMP_CAMERA]    ;
  46:   ;
  47:   ;
  48:  CALL READ_SCORE    ;
  49:  IF R[57:CUR_SCORE]>0,JMP LBL[30] ;
  50:  MESSAGE[FAILED PICK] ;
  51:  PAUSE ;
  52:  ! FIND BEST ORIENTATION ;
  53:  ! Rotate to next step ;
  54:  LBL[30] ;
  55:L PR[21] 100mm/sec FINE    ;
  56:  WAIT    .02(sec) ;
  57:  CALL READ_SCORE    ;
  58:  IF R[57:CUR_SCORE]>R[55:BEST_SCORE],JMP LBL[31] ;
  59:  IF R[54:ABOVE_THRESH]=1,JMP LBL[33] ;
  60:  JMP LBL[34] ;
  61:   ;
  62:  ! Entered quality threshold ;
  63:  LBL[31] ;
  64:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  65:  PR[22]=PR[21]    ;
  66:  IF R[57:CUR_SCORE]>R[53:MINIMUM_THRESH],JMP LBL[32] ;
  67:  JMP LBL[34] ;
  68:   ;
  69:  ! In quality threshold - NEW BEST ;
  70:  LBL[32] ;
  71:  R[54:ABOVE_THRESH]=1    ;
  72:  JMP LBL[34] ;
  73:   ;
  74:  ! Significant downturn check ;
  75:  LBL[33] ;
  76:  R[58:CUR_DROP]=R[55:BEST_SCORE]-R[57:CUR_SCORE]    ;
  77:  IF R[58:CUR_DROP]>R[56:DOWN_THRESH],JMP LBL[35] ;
  78:  JMP LBL[34] ;
  79:   ;
  80:  ! Iterate and call next step ;
  81:  LBL[34] ;
  82:  R[50:STEP_CNT]=R[50:STEP_CNT]+1    ;
  83:  IF R[50:STEP_CNT]>=R[51:MAX_STEP_CNT],JMP LBL[37] ;
  84:  PR[21,6]=PR[21,6]+R[52:TURN_PER_STEP]    ;
  85:  JMP LBL[30] ;
  86:   ;
  87:  ! Found Peak or no match ;
  88:  LBL[35] ;
  89:J PR[22] 100% CNT30    ;
  90:  JMP LBL[36] ;
  91:   ;
  92:  ! Fail Case: No Match ;
  93:  LBL[37] ;
  94:  MESSAGE[NO HIGH MATCH] ;
  95:J PR[22] 100% CNT30    ;
  96:  JMP LBL[36] ;
  97:   ;
  98:  ! Done (don't forget to maintain ;
  99:  ! rotation values ;
 100:  LBL[36] ;
 101:  PR[6,6:MOD_RCP_PSN]=PR[22,6]    ;
 102:   ;
 103:   ;
 104:  ! Move out of shroud ;
 105:  PR[20]=PR[3:TMP_CAMERA]    ;
 106:  PR[20,2]=PR[20,2]-R[23:Y_OFFSET_SHROUD]    ;
 107:  PR[20,6]=PR[22,6]    ;
 108:J PR[20] 100% CNT30    ;
 109:   ;
 110:  ! Move to Cable Module ;
 111:J PR[6:MOD_RCP_PSN] 100% FINE    ;
 112:   ;
 113:  ! Descend with receptacle ;
 114:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
 115:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
 116:L PR[4:TMP_MOD_RCP] 100mm/sec FINE    ;
 117:   ;
 118:  ! Ascend without receptacle ;
 119:L PR[6:MOD_RCP_PSN] 100mm/sec FINE    ;
 120:  ! Move safely back to shroud ;
 121:J PR[20] 100% CNT30    ;
 122:  ! Check without receptacle ;
 123:  R[57:CUR_SCORE]=0    ;
 124:J PR[22] 100% FINE    ;
 125:  CALL READ_SCORE    ;
 126:  IF R[57:CUR_SCORE]=0,JMP LBL[38] ;
 127:  MESSAGE[PLACE FAILED CLEAR PART RESUME] ;
 128:  PAUSE ;
 129:   ;
 130:  !!! CHECK REPO STATUS START ;
 131:  LBL[38] ;
 132:  IF R[1:REPO_RCP_X]=22 AND R[2:REPO_RCP_Y]=20,JMP LBL[999] ;
 133:   ;
 134:  ! Not empty so update ;
 135:  R[1:REPO_RCP_X]=R[1:REPO_RCP_X]+1    ;
 136:  IF R[1:REPO_RCP_X]>22,JMP LBL[2] ;
 137:   ;
 138:  ! Update position x ;
 139:  PR[5,1:REPO_RCP_PSN]=PR[5,1:REPO_RCP_PSN]+R[3:REPO_RCP_UOFFSET]    ;
 140:  JMP LBL[1] ;
 141:   ;
 142:  ! Next row x overflow ;
 143:  LBL[2] ;
 144:  R[1:REPO_RCP_X]=1    ;
 145:  R[2:REPO_RCP_Y]=R[2:REPO_RCP_Y]+1    ;
 146:  PR[5,1:REPO_RCP_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 147:  PR[5,2:REPO_RCP_PSN]=PR[5,2:REPO_RCP_PSN]-R[3:REPO_RCP_UOFFSET]    ;
 148:  JMP LBL[1] ;
 149:   ;
 150:  ! Switched from receptacle repo ;
 151:  ! to receptacle repo ;
 152:  LBL[999] ;
 153:  R[1:REPO_RCP_X]=1    ;
 154:  R[2:REPO_RCP_Y]=1    ;
 155:  IF R[4:REPO_X]=2 AND R[18:REPO_Y]=2,JMP LBL[996] ;
 156:   ;
 157:  R[4:REPO_X]=R[4:REPO_X]+1    ;
 158:  IF R[4:REPO_X]>2,JMP LBL[7] ;
 159:   ;
 160:  ! next repository column ;
 161:  PR[9,1:REPO_PSN]=PR[9,1:REPO_PSN]+R[19:REPO_XOFFSET]    ;
 162:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 163:  JMP LBL[1] ;
 164:   ;
 165:  ! next repository row ;
 166:  LBL[7] ;
 167:  R[4:REPO_X]=1    ;
 168:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
 169:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 170:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-R[20:REPO_YOFFSET]    ;
 171:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 172:  JMP LBL[1] ;
 173:  !!! CHECK REPO STATUS END. ;
 174:   ;
 175:   ;
 176:   ;
 177:  !!! CHECK TO SEE CURRENT RECIPE S ;
 178:  LBL[1] ;
 179:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 180:  R[99:RECIPE_IDX]=R[99:RECIPE_IDX]+1    ;
 181:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 182:   ;
 183:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 184:   ;
 185:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 186:  JMP LBL[4] ;
 187:   ;
 188:  LBL[5] ;
 189:  R[8:MOD_RCP_X]=1    ;
 190:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 191:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 192:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 193:  JMP LBL[4] ;
 194:  !!! CHECK TO SEE CURRENT RECIPE ;
 195:  !!! END ;
 196:   ;
 197:   ;
 198:   ;
 199:  !!! MODULE FULL, CHECK STATUS ;
 200:  !!! START ;
 201:  LBL[998] ;
 202:  R[11:RECIPE_IO_IDX]=1    ;
 203:  R[99:RECIPE_IDX]=101    ;
 204:  R[8:MOD_RCP_X]=1    ;
 205:  R[9:MOD_RCP_Y]=1    ;
 206:   ;
 207:  ! Check to see if Ice Tray Full ;
 208:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 209:   ;
 210:  ! Check if module row full ;
 211:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 212:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 213:   ;
 214:  ! Increment module column ;
 215:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 216:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 217:  JMP LBL[4] ;
 218:   ;
 219:  ! Increment module row and reset  ;
 220:  LBL[6] ;
 221:  R[5:MODULE_X]=1    ;
 222:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 223:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 224:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]-R[14:MODULE_YOFFSET]    ;
 225:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 226:  JMP LBL[4] ;
 227:   ;
 228:  ! Switched from ice tray ;
 229:  ! to ice tray ;
 230:  LBL[997] ;
 231:  ! Check am I out of Ice Trays ;
 232:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 233:   ;
 234:  ! Increment Ice Tray and set mod ;
 235:  ! and mod_rcp equal ;
 236:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 237:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]-R[17:ICE_TRAY_YOFFSET]    ;
 238:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 239:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 240:  JMP LBL[4] ;
 241:  !!! MODULE FULL, CHECK STATUS ;
 242:  !!! END ;
 243:   ;
 244:  LBL[996] ;
 245:  END ;
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
