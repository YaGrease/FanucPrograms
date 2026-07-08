/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 5334;
CREATE		= DATE 26-07-08  TIME 14:09:24;
MODIFIED	= DATE 26-07-08  TIME 14:09:24;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 239;
MEMORY_SIZE	= 5918;
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
  10:J PR[20] 100% FINE    ;
  11:  ! Move to next pin ;
  12:J PR[5:REPO_RCP_PSN] 100% FINE    ;
  13:   ;
  14:  ! TODO: mess with dist and spd to ;
  15:  ! Descend to grab pin ;
  16:  PR[2:TMP_REPO_RCP]=PR[5:REPO_RCP_PSN]    ;
  17:  PR[2,3:TMP_REPO_RCP]=PR[2,3:TMP_REPO_RCP]-R[21:PICKUP_CONSTANT]    ;
  18:L PR[2:TMP_REPO_RCP] 100mm/sec FINE    ;
  19:  WAIT    .05(sec) ;
  20:   ;
  21:  ! Ascend with Pin ;
  22:L PR[5:REPO_RCP_PSN] 100mm/sec FINE    ;
  23:   ;
  24:  ! Move safely to shroud ;
  25:  PR[20]=PR[5:REPO_RCP_PSN]    ;
  26:  PR[20,3]=PR[3,3:TMP_CAMERA]    ;
  27:  PR[20,1]=PR[3,1:TMP_CAMERA]    ;
  28:J PR[20] 100% FINE    ;
  29:J PR[3:TMP_CAMERA] 100% FINE    ;
  30:   ;
  31:  ! initiate camera code ;
  32:  R[50:STEP_CNT]=0    ;
  33:  R[51:MAX_STEP_CNT]=47    ;
  34:  R[52:TURN_PER_STEP]=8    ;
  35:  R[53:MINIMUM_THRESH]=90    ;
  36:  R[54:ABOVE_THRESH]=0    ;
  37:  R[55:BEST_SCORE]=0    ;
  38:  R[56:DOWN_THRESH]=2    ;
  39:  R[57:CUR_SCORE]=0    ;
  40:  R[58:CUR_DROP]=0    ;
  41:  PR[21]=PR[3:TMP_CAMERA]    ;
  42:  PR[22]=PR[3:TMP_CAMERA]    ;
  43:   ;
  44:  CALL READ_SCORE    ;
  45:  IF R[57:CUR_SCORE]>0,JMP LBL[30] ;
  46:  MESSAGE[FAILED PICK] ;
  47:  PAUSE ;
  48:  ! FIND BEST ORIENTATION ;
  49:  ! Rotate to next step ;
  50:  LBL[30] ;
  51:L PR[21] 100mm/sec FINE    ;
  52:  WAIT    .05(sec) ;
  53:  CALL READ_SCORE    ;
  54:  IF R[54:ABOVE_THRESH]=1,JMP LBL[32] ;
  55:  IF R[57:CUR_SCORE]>=R[53:MINIMUM_THRESH],JMP LBL[31] ;
  56:  JMP LBL[34] ;
  57:   ;
  58:  ! Entered quality threshold ;
  59:  LBL[31] ;
  60:  R[54:ABOVE_THRESH]=1    ;
  61:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  62:  PR[22]=PR[21]    ;
  63:  JMP LBL[34] ;
  64:   ;
  65:  ! In quality threshold - NEW BEST ;
  66:  LBL[32] ;
  67:  IF R[57:CUR_SCORE]<=R[55:BEST_SCORE],JMP LBL[33] ;
  68:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  69:  PR[22]=PR[21]    ;
  70:  JMP LBL[34] ;
  71:   ;
  72:  ! Significant downturn check ;
  73:  LBL[33] ;
  74:  R[58:CUR_DROP]=R[55:BEST_SCORE]-R[57:CUR_SCORE]    ;
  75:  IF R[58:CUR_DROP]>R[56:DOWN_THRESH],JMP LBL[35] ;
  76:  JMP LBL[34] ;
  77:   ;
  78:  ! Iterate and call next step ;
  79:  LBL[34] ;
  80:  R[50:STEP_CNT]=R[50:STEP_CNT]+1    ;
  81:  IF R[50:STEP_CNT]>=R[51:MAX_STEP_CNT],JMP LBL[37] ;
  82:  PR[21,6]=PR[21,6]+R[52:TURN_PER_STEP]    ;
  83:  JMP LBL[30] ;
  84:   ;
  85:  ! Found Peak ;
  86:  LBL[35] ;
  87:L PR[22] 100mm/sec FINE    ;
  88:  JMP LBL[36] ;
  89:   ;
  90:  ! Fail Case: No Match ;
  91:  LBL[37] ;
  92:  JMP LBL[996] ;
  93:   ;
  94:  ! Done (don't forget to maintain ;
  95:  ! rotation values ;
  96:  LBL[36] ;
  97:  PR[6,6:MOD_RCP_PSN]=PR[22,6]    ;
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
 175:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 176:   ;
 177:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 178:   ;
 179:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 180:  JMP LBL[4] ;
 181:   ;
 182:  LBL[5] ;
 183:  R[8:MOD_RCP_X]=1    ;
 184:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 185:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 186:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 187:  JMP LBL[4] ;
 188:  !!! CHECK TO SEE CURRENT RECIPE ;
 189:  !!! END ;
 190:   ;
 191:   ;
 192:   ;
 193:  !!! MODULE FULL, CHECK STATUS ;
 194:  !!! START ;
 195:  LBL[998] ;
 196:  R[11:RECIPE_IO_IDX]=1    ;
 197:  R[8:MOD_RCP_X]=1    ;
 198:  R[9:MOD_RCP_Y]=1    ;
 199:   ;
 200:  ! Check to see if Ice Tray Full ;
 201:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 202:   ;
 203:  ! Check if module row full ;
 204:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 205:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 206:   ;
 207:  ! Increment module column ;
 208:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 209:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 210:  JMP LBL[4] ;
 211:   ;
 212:  ! Increment module row and reset  ;
 213:  LBL[6] ;
 214:  R[5:MODULE_X]=1    ;
 215:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 216:  ! error no P[] allowed ;
 217:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 218:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]-R[14:MODULE_YOFFSET]    ;
 219:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 220:  JMP LBL[4] ;
 221:   ;
 222:  ! Switched from ice tray ;
 223:  ! to ice tray ;
 224:  LBL[997] ;
 225:  ! Check am I out of Ice Trays ;
 226:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 227:   ;
 228:  ! Increment Ice Tray and set mod ;
 229:  ! and mod_rcp equal ;
 230:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 231:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]-R[17:ICE_TRAY_YOFFSET]    ;
 232:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 233:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 234:  JMP LBL[4] ;
 235:  !!! MODULE FULL, CHECK STATUS ;
 236:  !!! END ;
 237:   ;
 238:  LBL[996] ;
 239:  END ;
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
