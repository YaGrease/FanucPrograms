/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 5480;
CREATE		= DATE 26-06-23  TIME 16:56:10;
MODIFIED	= DATE 26-06-23  TIME 16:56:10;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 241;
MEMORY_SIZE	= 6056;
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
  15:  ! TODO: mess with dist and spd to ;
  16:  ! Descend to grab pin ;
  17:  PR[2:TMP_REPO_RCP]=PR[5:REPO_RCP_PSN]    ;
  18:  PR[2,3:TMP_REPO_RCP]=PR[2,3:TMP_REPO_RCP]-R[21:PICKUP_CONSTANT]    ;
  19:L PR[2:TMP_REPO_RCP] 100mm/sec FINE    ;
  20:  WAIT    .05(sec) ;
  21:   ;
  22:  ! Ascend with Pin ;
  23:L PR[5:REPO_RCP_PSN] 100mm/sec FINE    ;
  24:   ;
  25:  ! Move to camera (care for ;
  26:  ! collision) ;
  27:  ! solder dipping ;
  28:  !PR[20]=PR[5:REPO_RCP_PSN] ;
  29:  !PR[20,3]=PR[3,3:TMP_CAMERA] ;
  30:  !L PR[20] 200mm/sec CNT100 ;
  31:  !PR[20]=PR[3:TMP_CAMERA] ;
  32:J PR[3:TMP_CAMERA] 100% FINE    ;
  33:  !PR[20,3]=PR[20,3]-45 ;
  34:  !L PR[20] 200mm/sec CNT100 ;
  35:  !L PR[3:TMP_CAMERA] 200mm/sec CNT ;
  36:  !L PR[20] 200mm/sec CNT100 ;
  37:  !L PR[3:TMP_CAMERA] 200mm/sec CNT ;
  38:  !PR[3:TMP_CAMERA]=PR[3:TMP_CAMERA ;
  39:   ;
  40:  ! initiate camera code ;
  41:  R[50:STEP_CNT]=0    ;
  42:  R[51:MAX_STEP_CNT]=47    ;
  43:  R[52:TURN_PER_STEP]=8    ;
  44:  R[53:MINIMUM_THRESH]=90    ;
  45:  R[54:ABOVE_THRESH]=0    ;
  46:  R[55:BEST_SCORE]=0    ;
  47:  R[56:DOWN_THRESH]=2    ;
  48:  R[57:CUR_SCORE]=0    ;
  49:  R[58:CUR_DROP]=0    ;
  50:  PR[21]=PR[3:TMP_CAMERA]    ;
  51:  PR[22]=PR[3:TMP_CAMERA]    ;
  52:   ;
  53:  CALL READ_SCORE    ;
  54:  IF R[57:CUR_SCORE]>0,JMP LBL[30] ;
  55:  MESSAGE[FAILED PICK] ;
  56:  PAUSE ;
  57:  ! FIND BEST ORIENTATION ;
  58:  ! Rotate to next step ;
  59:  LBL[30] ;
  60:L PR[21] 100mm/sec FINE    ;
  61:  WAIT    .05(sec) ;
  62:  CALL READ_SCORE    ;
  63:  IF R[54:ABOVE_THRESH]=1,JMP LBL[32] ;
  64:  IF R[57:CUR_SCORE]>=R[53:MINIMUM_THRESH],JMP LBL[31] ;
  65:  JMP LBL[34] ;
  66:   ;
  67:  ! Entered quality threshold ;
  68:  LBL[31] ;
  69:  R[54:ABOVE_THRESH]=1    ;
  70:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  71:  PR[22]=PR[21]    ;
  72:  JMP LBL[34] ;
  73:   ;
  74:  ! In quality threshold - NEW BEST ;
  75:  LBL[32] ;
  76:  IF R[57:CUR_SCORE]<=R[55:BEST_SCORE],JMP LBL[33] ;
  77:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  78:  PR[22]=PR[21]    ;
  79:  JMP LBL[34] ;
  80:   ;
  81:  ! Significant downturn check ;
  82:  LBL[33] ;
  83:  R[58:CUR_DROP]=R[55:BEST_SCORE]-R[57:CUR_SCORE]    ;
  84:  IF R[58:CUR_DROP]>R[56:DOWN_THRESH],JMP LBL[35] ;
  85:  JMP LBL[34] ;
  86:   ;
  87:  ! Iterate and call next step ;
  88:  LBL[34] ;
  89:  R[50:STEP_CNT]=R[50:STEP_CNT]+1    ;
  90:  IF R[50:STEP_CNT]>=R[51:MAX_STEP_CNT],JMP LBL[37] ;
  91:  PR[21,6]=PR[21,6]+R[52:TURN_PER_STEP]    ;
  92:  JMP LBL[30] ;
  93:   ;
  94:  ! Found Peak ;
  95:  LBL[35] ;
  96:L PR[22] 100mm/sec FINE    ;
  97:  JMP LBL[36] ;
  98:   ;
  99:  ! Fail Case: No Match ;
 100:  LBL[37] ;
 101:  JMP LBL[996] ;
 102:   ;
 103:  ! Done (don't forget to maintain ;
 104:  ! rotation values ;
 105:  LBL[36] ;
 106:  PR[6,6:MOD_RCP_PSN]=PR[22,6]    ;
 107:   ;
 108:  ! Move to Cable Module ;
 109:J PR[6:MOD_RCP_PSN] 100% FINE    ;
 110:   ;
 111:  ! Descend with receptacle ;
 112:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
 113:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
 114:L PR[4:TMP_MOD_RCP] 100mm/sec FINE    ;
 115:   ;
 116:  ! Ascend without receptacle ;
 117:L PR[6:MOD_RCP_PSN] 100mm/sec FINE    ;
 118:   ;
 119:  ! Check without receptacle ;
 120:  R[57:CUR_SCORE]=0    ;
 121:J PR[22] 100% FINE    ;
 122:  CALL READ_SCORE    ;
 123:  IF R[57:CUR_SCORE]=0,JMP LBL[38] ;
 124:  MESSAGE[PLACE FAILED CLEAR PART RESUME] ;
 125:  PAUSE ;
 126:   ;
 127:  !!! CHECK REPO STATUS START ;
 128:  LBL[38] ;
 129:  IF R[1:REPO_RCP_X]=22 AND R[2:REPO_RCP_Y]=20,JMP LBL[999] ;
 130:   ;
 131:  ! Not empty so update ;
 132:  R[1:REPO_RCP_X]=R[1:REPO_RCP_X]+1    ;
 133:  IF R[1:REPO_RCP_X]>22,JMP LBL[2] ;
 134:   ;
 135:  ! Update position x ;
 136:  PR[5,1:REPO_RCP_PSN]=PR[5,1:REPO_RCP_PSN]+R[3:REPO_RCP_UOFFSET]    ;
 137:  JMP LBL[1] ;
 138:   ;
 139:  ! Next row x overflow ;
 140:  LBL[2] ;
 141:  R[1:REPO_RCP_X]=1    ;
 142:  R[2:REPO_RCP_Y]=R[2:REPO_RCP_Y]+1    ;
 143:  PR[5,1:REPO_RCP_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 144:  PR[5,2:REPO_RCP_PSN]=PR[5,2:REPO_RCP_PSN]-R[3:REPO_RCP_UOFFSET]    ;
 145:  JMP LBL[1] ;
 146:   ;
 147:  ! Switched from receptacle repo ;
 148:  ! to receptacle repo ;
 149:  LBL[999] ;
 150:  R[1:REPO_RCP_X]=1    ;
 151:  R[2:REPO_RCP_Y]=1    ;
 152:  IF R[4:REPO_X]=2 AND R[18:REPO_Y]=2,JMP LBL[996] ;
 153:   ;
 154:  R[4:REPO_X]=R[4:REPO_X]+1    ;
 155:  IF R[4:REPO_X]>2,JMP LBL[7] ;
 156:   ;
 157:  ! next repository column ;
 158:  PR[9,1:REPO_PSN]=PR[9,1:REPO_PSN]+R[19:REPO_XOFFSET]    ;
 159:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 160:  JMP LBL[1] ;
 161:   ;
 162:  ! next repository row ;
 163:  LBL[7] ;
 164:  R[4:REPO_X]=1    ;
 165:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
 166:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 167:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]-R[20:REPO_YOFFSET]    ;
 168:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 169:  JMP LBL[1] ;
 170:  !!! CHECK REPO STATUS END. ;
 171:   ;
 172:   ;
 173:   ;
 174:  !!! CHECK TO SEE CURRENT RECIPE S ;
 175:  LBL[1] ;
 176:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 177:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 178:   ;
 179:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 180:   ;
 181:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 182:  JMP LBL[4] ;
 183:   ;
 184:  LBL[5] ;
 185:  R[8:MOD_RCP_X]=1    ;
 186:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 187:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 188:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 189:  JMP LBL[4] ;
 190:  !!! CHECK TO SEE CURRENT RECIPE ;
 191:  !!! END ;
 192:   ;
 193:   ;
 194:   ;
 195:  !!! MODULE FULL, CHECK STATUS ;
 196:  !!! START ;
 197:  LBL[998] ;
 198:  R[11:RECIPE_IO_IDX]=1    ;
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
