/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 5322;
CREATE		= DATE 26-06-19  TIME 16:49:12;
MODIFIED	= DATE 26-06-19  TIME 16:49:12;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 234;
MEMORY_SIZE	= 5926;
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
  20:  WAIT    .50(sec) ;
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
  42:  R[51:MAX_STEP_CNT]=45    ;
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
  53:  ! FIND BEST ORIENTATION ;
  54:  ! Rotate to next step ;
  55:  LBL[30] ;
  56:L PR[21] 200mm/sec FINE    ;
  57:  WAIT    .50(sec) ;
  58:  CALL READ_SCORE    ;
  59:  IF R[54:ABOVE_THRESH]=1,JMP LBL[32] ;
  60:  IF R[57:CUR_SCORE]>=R[53:MINIMUM_THRESH],JMP LBL[31] ;
  61:  JMP LBL[34] ;
  62:   ;
  63:  ! Entered quality threshold ;
  64:  LBL[31] ;
  65:  R[54:ABOVE_THRESH]=1    ;
  66:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  67:  PR[22]=PR[21]    ;
  68:  JMP LBL[34] ;
  69:   ;
  70:  ! In quality threshold - NEW BEST ;
  71:  LBL[32] ;
  72:  IF R[57:CUR_SCORE]<=R[55:BEST_SCORE],JMP LBL[33] ;
  73:  R[55:BEST_SCORE]=R[57:CUR_SCORE]    ;
  74:  PR[22]=PR[21]    ;
  75:  JMP LBL[34] ;
  76:   ;
  77:  ! Significant downturn check ;
  78:  LBL[33] ;
  79:  R[58:CUR_DROP]=R[55:BEST_SCORE]-R[57:CUR_SCORE]    ;
  80:  IF R[58:CUR_DROP]>R[56:DOWN_THRESH],JMP LBL[35] ;
  81:  JMP LBL[34] ;
  82:   ;
  83:  ! Iterate and call next step ;
  84:  LBL[34] ;
  85:  R[50:STEP_CNT]=R[50:STEP_CNT]+1    ;
  86:  IF R[50:STEP_CNT]>=R[51:MAX_STEP_CNT],JMP LBL[37] ;
  87:  PR[21,6]=PR[21,6]+R[52:TURN_PER_STEP]    ;
  88:  JMP LBL[30] ;
  89:   ;
  90:  ! Found Peak ;
  91:  LBL[35] ;
  92:L PR[22] 200mm/sec FINE    ;
  93:  JMP LBL[36] ;
  94:   ;
  95:  ! Fail Case: No Match ;
  96:  LBL[37] ;
  97:  JMP LBL[996] ;
  98:   ;
  99:  ! Done (don't forget to maintain ;
 100:  ! rotation values ;
 101:  LBL[36] ;
 102:  PR[6,6:MOD_RCP_PSN]=PR[22,6]    ;
 103:   ;
 104:  WAIT   3.00(sec) ;
 105:   ;
 106:  ! Move to Cable Module ;
 107:J PR[6:MOD_RCP_PSN] 100% FINE    ;
 108:   ;
 109:  ! Descend with receptacle ;
 110:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
 111:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
 112:L PR[4:TMP_MOD_RCP] 100mm/sec FINE    ;
 113:   ;
 114:  ! Ascend without receptacle ;
 115:L PR[6:MOD_RCP_PSN] 100mm/sec FINE    ;
 116:   ;
 117:   ;
 118:  ! TODO: GO back to camera an ;
 119:  ! d check if removed if not stop ;
 120:   ;
 121:  !!! CHECK REPO STATUS START ;
 122:  IF R[1:REPO_RCP_X]=22 AND R[2:REPO_RCP_Y]=20,JMP LBL[999] ;
 123:   ;
 124:  ! Not empty so update ;
 125:  R[1:REPO_RCP_X]=R[1:REPO_RCP_X]+1    ;
 126:  IF R[1:REPO_RCP_X]>22,JMP LBL[2] ;
 127:   ;
 128:  ! Update position x ;
 129:  PR[5,1:REPO_RCP_PSN]=PR[5,1:REPO_RCP_PSN]+R[3:REPO_RCP_UOFFSET]    ;
 130:  JMP LBL[1] ;
 131:   ;
 132:  ! Next row x overflow ;
 133:  LBL[2] ;
 134:  R[1:REPO_RCP_X]=1    ;
 135:  R[2:REPO_RCP_Y]=R[2:REPO_RCP_Y]+1    ;
 136:  PR[5,1:REPO_RCP_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 137:  PR[5,2:REPO_RCP_PSN]=PR[5,2:REPO_RCP_PSN]-R[3:REPO_RCP_UOFFSET]    ;
 138:  JMP LBL[1] ;
 139:   ;
 140:  ! Switched from receptacle repo ;
 141:  ! to receptacle repo ;
 142:  LBL[999] ;
 143:  R[1:REPO_RCP_X]=1    ;
 144:  R[2:REPO_RCP_Y]=1    ;
 145:  IF R[4:REPO_X]=2 AND R[18:REPO_Y]=2,JMP LBL[996] ;
 146:   ;
 147:  R[4:REPO_X]=R[4:REPO_X]+1    ;
 148:  IF R[4:REPO_X]>2,JMP LBL[7] ;
 149:   ;
 150:  ! next repository column ;
 151:  PR[9,1:REPO_PSN]=PR[9,1:REPO_PSN]+R[19:REPO_XOFFSET]    ;
 152:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 153:  JMP LBL[1] ;
 154:   ;
 155:  ! next repository row ;
 156:  LBL[7] ;
 157:  R[4:REPO_X]=1    ;
 158:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
 159:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 160:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]+R[20:REPO_YOFFSET]    ;
 161:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 162:  JMP LBL[1] ;
 163:  !!! CHECK REPO STATUS END. ;
 164:   ;
 165:   ;
 166:   ;
 167:  !!! CHECK TO SEE CURRENT RECIPE S ;
 168:  LBL[1] ;
 169:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 170:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 171:   ;
 172:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 173:   ;
 174:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 175:  JMP LBL[4] ;
 176:   ;
 177:  LBL[5] ;
 178:  R[8:MOD_RCP_X]=1    ;
 179:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 180:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 181:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 182:  JMP LBL[4] ;
 183:  !!! CHECK TO SEE CURRENT RECIPE ;
 184:  !!! END ;
 185:   ;
 186:   ;
 187:   ;
 188:  !!! MODULE FULL, CHECK STATUS ;
 189:  !!! START ;
 190:  LBL[998] ;
 191:  R[11:RECIPE_IO_IDX]=1    ;
 192:  R[8:MOD_RCP_X]=1    ;
 193:  R[9:MOD_RCP_Y]=1    ;
 194:   ;
 195:  ! Check to see if Ice Tray Full ;
 196:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 197:   ;
 198:  ! Check if module row full ;
 199:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 200:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 201:   ;
 202:  ! Increment module column ;
 203:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 204:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 205:  JMP LBL[4] ;
 206:   ;
 207:  ! Increment module row and reset  ;
 208:  LBL[6] ;
 209:  R[5:MODULE_X]=1    ;
 210:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 211:  PR[10:TMP_MOD_RCP]=P[4:FIRST_RCP]    ;
 212:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 213:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]+R[14:MODULE_YOFFSET]    ;
 214:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 215:  JMP LBL[4] ;
 216:   ;
 217:  ! Switched from ice tray ;
 218:  ! to ice tray ;
 219:  LBL[997] ;
 220:  ! Check am I out of Ice Trays ;
 221:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 222:   ;
 223:  ! Increment Ice Tray and set mod ;
 224:  ! and mod_rcp equal ;
 225:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 226:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]+R[17:ICE_TRAY_YOFFSET]    ;
 227:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 228:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 229:  JMP LBL[4] ;
 230:  !!! MODULE FULL, CHECK STATUS ;
 231:  !!! END ;
 232:   ;
 233:  LBL[996] ;
 234:  END ;
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
