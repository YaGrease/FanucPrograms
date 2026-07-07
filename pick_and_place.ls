/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 5318;
CREATE		= DATE 26-07-07  TIME 16:59:44;
MODIFIED	= DATE 26-07-07  TIME 16:59:44;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 238;
MEMORY_SIZE	= 5906;
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
  16:  PR[2,3:TMP_REPO_RCP]=PR[2,3:TMP_REPO_RCP]-R[21:PICKUP_CONSTANT]    ;
  17:L PR[2:TMP_REPO_RCP] 100mm/sec FINE    ;
  18:  WAIT    .05(sec) ;
  19:   ;
  20:  ! Ascend with Pin ;
  21:L PR[5:REPO_RCP_PSN] 100mm/sec FINE    ;
  22:   ;
  23:  ! Move safely to shroud ;
  24:  PR[20]=PR[5:REPO_RCP_PSN]    ;
  25:  PR[20,3]=PR[3,3:TMP_CAMERA]    ;
  26:  PR[20,1]=PR[3,1:TMP_CAMERA]    ;
  27:J PR[20] 100% FINE    ;
  28:J PR[3:TMP_CAMERA] 100% FINE    ;
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
  51:  WAIT    .05(sec) ;
  52:  CALL READ_SCORE    ;
  53:  IF R[54:ABOVE_THRESH]=1,JMP LBL[32] ;
  54:  IF R[57:CUR_SCORE]>=R[53:MINIMUM_THRESH],JMP LBL[31] ;
  55:  JMP LBL[34] ;
  56:   ;
  57:  ! Entered quality threshold ;
  58:  LBL[31] ;
  59:  R[54:ABOVE_THRESH]=1    ;
  60:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  61:  PR[22]=PR[21]    ;
  62:  JMP LBL[34] ;
  63:   ;
  64:  ! In quality threshold - NEW BEST ;
  65:  LBL[32] ;
  66:  IF R[57:CUR_SCORE]<=R[55:BEST_SCORE],JMP LBL[33] ;
  67:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  68:  PR[22]=PR[21]    ;
  69:  JMP LBL[34] ;
  70:   ;
  71:  ! Significant downturn check ;
  72:  LBL[33] ;
  73:  R[58:CUR_DROP]=R[55:BEST_SCORE]-R[57:CUR_SCORE]    ;
  74:  IF R[58:CUR_DROP]>R[56:DOWN_THRESH],JMP LBL[35] ;
  75:  JMP LBL[34] ;
  76:   ;
  77:  ! Iterate and call next step ;
  78:  LBL[34] ;
  79:  R[50:STEP_CNT]=R[50:STEP_CNT]+1    ;
  80:  IF R[50:STEP_CNT]>=R[51:MAX_STEP_CNT],JMP LBL[37] ;
  81:  PR[21,6]=PR[21,6]+R[52:TURN_PER_STEP]    ;
  82:  JMP LBL[30] ;
  83:   ;
  84:  ! Found Peak ;
  85:  LBL[35] ;
  86:L PR[22] 100mm/sec FINE    ;
  87:  JMP LBL[36] ;
  88:   ;
  89:  ! Fail Case: No Match ;
  90:  LBL[37] ;
  91:  JMP LBL[996] ;
  92:   ;
  93:  ! Done (don't forget to maintain ;
  94:  ! rotation values ;
  95:  LBL[36] ;
  96:  PR[6,6:MOD_RCP_PSN]=PR[22,6]    ;
  97:   ;
  98:  ! Move out of shroud ;
  99:  PR[20]=PR[3:TMP_CAMERA]    ;
 100:  PR[20,2]=PR[20,2]-R[23]    ;
 101:  PR[20,6]=PR[22,6]    ;
 102:J PR[20] 100% FINE    ;
 103:   ;
 104:  ! Move to Cable Module ;
 105:J PR[6:MOD_RCP_PSN] 100% FINE    ;
 106:   ;
 107:  ! Descend with receptacle ;
 108:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
 109:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
 110:L PR[4:TMP_MOD_RCP] 100mm/sec FINE    ;
 111:   ;
 112:  ! Ascend without receptacle ;
 113:L PR[6:MOD_RCP_PSN] 100mm/sec FINE    ;
 114:  ! Move safely back to shroud ;
 115:J PR[20] 100% FINE    ;
 116:  ! Check without receptacle ;
 117:  R[57:CUR_SCORE]=0    ;
 118:J PR[22] 100% FINE    ;
 119:  CALL READ_SCORE    ;
 120:  IF R[57:CUR_SCORE]=0,JMP LBL[38] ;
 121:  MESSAGE[PLACE FAILED CLEAR PART RESUME] ;
 122:  PAUSE ;
 123:   ;
 124:  !!! CHECK REPO STATUS START ;
 125:  LBL[38] ;
 126:  IF R[1:REPO_RCP_X]=22 AND R[2:REPO_RCP_Y]=20,JMP LBL[999] ;
 127:   ;
 128:  ! Not empty so update ;
 129:  R[1:REPO_RCP_X]=R[1:REPO_RCP_X]+1    ;
 130:  IF R[1:REPO_RCP_X]>22,JMP LBL[2] ;
 131:   ;
 132:  ! Update position x ;
 133:  PR[5,1:REPO_RCP_PSN]=PR[5,1:REPO_RCP_PSN]+R[3:REPO_RCP_UOFFSET]    ;
 134:  JMP LBL[1] ;
 135:   ;
 136:  ! Next row x overflow ;
 137:  LBL[2] ;
 138:  R[1:REPO_RCP_X]=1    ;
 139:  R[2:REPO_RCP_Y]=R[2:REPO_RCP_Y]+1    ;
 140:  PR[5,1:REPO_RCP_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 141:  PR[5,2:REPO_RCP_PSN]=PR[5,2:REPO_RCP_PSN]-R[3:REPO_RCP_UOFFSET]    ;
 142:  JMP LBL[1] ;
 143:   ;
 144:  ! Switched from receptacle repo ;
 145:  ! to receptacle repo ;
 146:  LBL[999] ;
 147:  R[1:REPO_RCP_X]=1    ;
 148:  R[2:REPO_RCP_Y]=1    ;
 149:  IF R[4:REPO_X]=2 AND R[18:REPO_Y]=2,JMP LBL[996] ;
 150:   ;
 151:  R[4:REPO_X]=R[4:REPO_X]+1    ;
 152:  IF R[4:REPO_X]>2,JMP LBL[7] ;
 153:   ;
 154:  ! next repository column ;
 155:  PR[9,1:REPO_PSN]=PR[9,1:REPO_PSN]+R[19:REPO_XOFFSET]    ;
 156:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 157:  JMP LBL[1] ;
 158:   ;
 159:  ! next repository row ;
 160:  LBL[7] ;
 161:  R[4:REPO_X]=1    ;
 162:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
 163:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 164:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-R[20:REPO_YOFFSET]    ;
 165:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 166:  JMP LBL[1] ;
 167:  !!! CHECK REPO STATUS END. ;
 168:   ;
 169:   ;
 170:   ;
 171:  !!! CHECK TO SEE CURRENT RECIPE S ;
 172:  LBL[1] ;
 173:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 174:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 175:   ;
 176:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 177:   ;
 178:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 179:  JMP LBL[4] ;
 180:   ;
 181:  LBL[5] ;
 182:  R[8:MOD_RCP_X]=1    ;
 183:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 184:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 185:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 186:  JMP LBL[4] ;
 187:  !!! CHECK TO SEE CURRENT RECIPE ;
 188:  !!! END ;
 189:   ;
 190:   ;
 191:   ;
 192:  !!! MODULE FULL, CHECK STATUS ;
 193:  !!! START ;
 194:  LBL[998] ;
 195:  R[11:RECIPE_IO_IDX]=1    ;
 196:  R[8:MOD_RCP_X]=1    ;
 197:  R[9:MOD_RCP_Y]=1    ;
 198:   ;
 199:  ! Check to see if Ice Tray Full ;
 200:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 201:   ;
 202:  ! Check if module row full ;
 203:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 204:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 205:   ;
 206:  ! Increment module column ;
 207:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 208:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 209:  JMP LBL[4] ;
 210:   ;
 211:  ! Increment module row and reset  ;
 212:  LBL[6] ;
 213:  R[5:MODULE_X]=1    ;
 214:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 215:  ! error no P[] allowed ;
 216:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 217:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]-R[14:MODULE_YOFFSET]    ;
 218:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 219:  JMP LBL[4] ;
 220:   ;
 221:  ! Switched from ice tray ;
 222:  ! to ice tray ;
 223:  LBL[997] ;
 224:  ! Check am I out of Ice Trays ;
 225:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 226:   ;
 227:  ! Increment Ice Tray and set mod ;
 228:  ! and mod_rcp equal ;
 229:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 230:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]-R[17:ICE_TRAY_YOFFSET]    ;
 231:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 232:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 233:  JMP LBL[4] ;
 234:  !!! MODULE FULL, CHECK STATUS ;
 235:  !!! END ;
 236:   ;
 237:  LBL[996] ;
 238:  END ;
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
