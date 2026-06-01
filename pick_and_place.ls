/PROG  PICK_AND_PLACE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 5646;
CREATE		= DATE 26-05-13  TIME 14:11:58;
MODIFIED	= DATE 26-05-13  TIME 14:11:58;
FILE_NAME	= PICK_AND;
VERSION		= 0;
LINE_COUNT	= 265;
MEMORY_SIZE	= 6378;
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
   3:  ! Verifies which module slot ;
   4:  IF R[11:RECIPE_IO_IDX]<>1,JMP LBL[101] ;
   5:  R[12:RECIPE_OUTPUT]=(R[101]) ;
   6:  LBL[101] ;
   7:  IF R[11:RECIPE_IO_IDX]<>2,JMP LBL[102] ;
   8:  R[12:RECIPE_OUTPUT]=(R[102]) ;
   9:  LBL[102] ;
  10:  IF R[11:RECIPE_IO_IDX]<>3,JMP LBL[103] ;
  11:  R[12:RECIPE_OUTPUT]=(R[103]) ;
  12:  LBL[103] ;
  13:  IF R[11:RECIPE_IO_IDX]<>4,JMP LBL[104] ;
  14:  R[12:RECIPE_OUTPUT]=(R[104]) ;
  15:  LBL[104] ;
  16:  IF R[11:RECIPE_IO_IDX]<>5,JMP LBL[105] ;
  17:  R[12:RECIPE_OUTPUT]=(R[105]) ;
  18:  LBL[105] ;
  19:  IF R[11:RECIPE_IO_IDX]<>6,JMP LBL[106] ;
  20:  R[12:RECIPE_OUTPUT]=(R[106]) ;
  21:  LBL[106] ;
  22:  IF R[11:RECIPE_IO_IDX]<>7,JMP LBL[107] ;
  23:  R[12:RECIPE_OUTPUT]=(R[107]) ;
  24:  LBL[107] ;
  25:  IF R[11:RECIPE_IO_IDX]<>8,JMP LBL[108] ;
  26:  R[12:RECIPE_OUTPUT]=(R[108]) ;
  27:  LBL[108] ;
  28:  IF R[11:RECIPE_IO_IDX]<>9,JMP LBL[109] ;
  29:  R[12:RECIPE_OUTPUT]=(R[109]) ;
  30:  LBL[109] ;
  31:  IF R[11:RECIPE_IO_IDX]<>10,JMP LBL[110] ;
  32:  R[12:RECIPE_OUTPUT]=(R[110]) ;
  33:  LBL[110] ;
  34:  IF R[11:RECIPE_IO_IDX]<>11,JMP LBL[111] ;
  35:  R[12:RECIPE_OUTPUT]=(R[111]) ;
  36:  LBL[111] ;
  37:  IF R[11:RECIPE_IO_IDX]<>12,JMP LBL[112] ;
  38:  R[12:RECIPE_OUTPUT]=(R[112]) ;
  39:  LBL[112] ;
  40:  IF R[11:RECIPE_IO_IDX]<>13,JMP LBL[113] ;
  41:  R[12:RECIPE_OUTPUT]=(R[113]) ;
  42:  LBL[113] ;
  43:  IF R[11:RECIPE_IO_IDX]<>14,JMP LBL[114] ;
  44:  R[12:RECIPE_OUTPUT]=(R[114]) ;
  45:  LBL[114] ;
  46:  IF R[11:RECIPE_IO_IDX]<>15,JMP LBL[115] ;
  47:  R[12:RECIPE_OUTPUT]=(R[115]) ;
  48:  LBL[115] ;
  49:  IF R[11:RECIPE_IO_IDX]<>16,JMP LBL[116] ;
  50:  R[12:RECIPE_OUTPUT]=(R[116]) ;
  51:  LBL[116] ;
  52:  IF R[11:RECIPE_IO_IDX]<>17,JMP LBL[117] ;
  53:  R[12:RECIPE_OUTPUT]=(R[117]) ;
  54:  LBL[117] ;
  55:  IF R[11:RECIPE_IO_IDX]<>18,JMP LBL[118] ;
  56:  R[12:RECIPE_OUTPUT]=(R[118]) ;
  57:  LBL[118] ;
  58:  IF R[11:RECIPE_IO_IDX]<>19,JMP LBL[119] ;
  59:  R[12:RECIPE_OUTPUT]=(R[119]) ;
  60:  LBL[119] ;
  61:  IF R[11:RECIPE_IO_IDX]<>20,JMP LBL[120] ;
  62:  R[12:RECIPE_OUTPUT]=(R[120]) ;
  63:  LBL[120] ;
  64:  IF R[11:RECIPE_IO_IDX]<>21,JMP LBL[121] ;
  65:  R[12:RECIPE_OUTPUT]=(R[121]) ;
  66:  LBL[121] ;
  67:  IF R[11:RECIPE_IO_IDX]<>22,JMP LBL[122] ;
  68:  R[12:RECIPE_OUTPUT]=(R[122]) ;
  69:  LBL[122] ;
  70:  IF R[11:RECIPE_IO_IDX]<>23,JMP LBL[123] ;
  71:  R[12:RECIPE_OUTPUT]=(R[123]) ;
  72:  LBL[123] ;
  73:  IF R[11:RECIPE_IO_IDX]<>24,JMP LBL[124] ;
  74:  R[12:RECIPE_OUTPUT]=(R[124]) ;
  75:  LBL[124] ;
  76:  IF R[11:RECIPE_IO_IDX]<>25,JMP LBL[125] ;
  77:  R[12:RECIPE_OUTPUT]=(R[125]) ;
  78:  LBL[125] ;
  79:  IF R[11:RECIPE_IO_IDX]<>26,JMP LBL[126] ;
  80:  R[12:RECIPE_OUTPUT]=(R[126]) ;
  81:  LBL[126] ;
  82:  IF R[11:RECIPE_IO_IDX]<>27,JMP LBL[127] ;
  83:  R[12:RECIPE_OUTPUT]=(R[127]) ;
  84:  LBL[127] ;
  85:  IF R[11:RECIPE_IO_IDX]<>28,JMP LBL[128] ;
  86:  R[12:RECIPE_OUTPUT]=(R[128]) ;
  87:  LBL[128] ;
  88:  IF R[11:RECIPE_IO_IDX]<>29,JMP LBL[129] ;
  89:  R[12:RECIPE_OUTPUT]=(R[129]) ;
  90:  LBL[129] ;
  91:  IF R[11:RECIPE_IO_IDX]<>30,JMP LBL[130] ;
  92:  R[12:RECIPE_OUTPUT]=(R[130]) ;
  93:  LBL[130] ;
  94:  IF R[11:RECIPE_IO_IDX]<>31,JMP LBL[131] ;
  95:  R[12:RECIPE_OUTPUT]=(R[131]) ;
  96:  LBL[131] ;
  97:  IF R[11:RECIPE_IO_IDX]<>32,JMP LBL[132] ;
  98:  R[12:RECIPE_OUTPUT]=(R[132]) ;
  99:  LBL[132] ;
 100:  IF R[11:RECIPE_IO_IDX]<>33,JMP LBL[133] ;
 101:  R[12:RECIPE_OUTPUT]=(R[133]) ;
 102:  LBL[133] ;
 103:  IF R[11:RECIPE_IO_IDX]<>34,JMP LBL[134] ;
 104:  R[12:RECIPE_OUTPUT]=(R[134]) ;
 105:  LBL[134] ;
 106:  IF R[11:RECIPE_IO_IDX]<>35,JMP LBL[135] ;
 107:  R[12:RECIPE_OUTPUT]=(R[135]) ;
 108:  LBL[135] ;
 109:  IF R[11:RECIPE_IO_IDX]<>36,JMP LBL[136] ;
 110:  R[12:RECIPE_OUTPUT]=(R[136]) ;
 111:  LBL[136] ;
 112:  IF R[11:RECIPE_IO_IDX]=37,JMP LBL[998] ;
 113:   ;
 114:   ;
 115:  ! Checks to see if recipe does ;
 116:  ! not call for receptacle ;
 117:  IF R[12:RECIPE_OUTPUT]=0,JMP LBL[1] ;
 118:   ;
 119:  ! Move to next pin ;
 120:J PR[5:REPO_RCP_PSN] 100% FINE    ;
 121:   ;
 122:  ! Descend to grab pin ;
 123:  PR[2:TMP_REPO_RCP]=PR[5:REPO_RCP_PSN]    ;
 124:  PR[2,3:TMP_REPO_RCP]=PR[2,3:TMP_REPO_RCP]-R[21:PICKUP_CONSTANT]    ;
 125:L PR[2:TMP_REPO_RCP] 20mm/sec FINE    ;
 126:  WAIT    .50(sec) ;
 127:   ;
 128:  ! Ascend with Pin ;
 129:L PR[5:REPO_RCP_PSN] 20mm/sec FINE    ;
 130:   ;
 131:  ! Move to camera (care for ;
 132:  ! collision) ;
 133:J PR[3:TMP_CAMERA] 100% FINE    ;
 134:  PR[3:TMP_CAMERA]=PR[3:TMP_CAMERA]    ;
 135:  WAIT    .50(sec) ;
 136:   ;
 137:  ! Check orientation ;
 138:   ;
 139:  ! Move to Cable Module ;
 140:J PR[6:MOD_RCP_PSN] 100% FINE    ;
 141:   ;
 142:  ! Descend with receptacle ;
 143:  PR[4:TMP_MOD_RCP]=PR[6:MOD_RCP_PSN]    ;
 144:  PR[4,3:TMP_MOD_RCP]=PR[4,3:TMP_MOD_RCP]-R[22:RELEASE_CONSTANT]    ;
 145:L PR[4:TMP_MOD_RCP] 20mm/sec FINE    ;
 146:   ;
 147:  ! Ascend without receptacle ;
 148:L PR[6:MOD_RCP_PSN] 20mm/sec FINE    ;
 149:   ;
 150:   ;
 151:   ;
 152:  !!! CHECK REPO STATUS START ;
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
 167:  PR[5,1:REPO_RCP_PSN]=PR[7,1:TMP_REPO_RCP]    ;
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
 183:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 184:  JMP LBL[1] ;
 185:   ;
 186:  ! next repository row ;
 187:  LBL[7] ;
 188:  R[4:REPO_X]=1    ;
 189:  R[18:REPO_Y]=R[18:REPO_Y]+1    ;
 190:  PR[9,1:REPO_PSN]=PR[7,1:TMP_REPO_RCP]    ;
 191:  PR[9,2:REPO_PSN]=PR[9,2:REPO_PSN]+R[20:REPO_YOFFSET]    ;
 192:  PR[5:REPO_RCP_PSN]=PR[9:REPO_PSN]    ;
 193:  JMP LBL[1] ;
 194:  !!! CHECK REPO STATUS END. ;
 195:   ;
 196:   ;
 197:   ;
 198:  !!! CHECK TO SEE CURRENT RECIPE S ;
 199:  LBL[1] ;
 200:  R[11:RECIPE_IO_IDX]=R[11:RECIPE_IO_IDX]+1    ;
 201:  R[8:MOD_RCP_X]=R[8:MOD_RCP_X]+1    ;
 202:   ;
 203:  IF R[8:MOD_RCP_X]>6,JMP LBL[5] ;
 204:   ;
 205:  PR[6,1:MOD_RCP_PSN]=PR[6,1:MOD_RCP_PSN]+R[6:MOD_RCP_XOFFSET]    ;
 206:  JMP LBL[4] ;
 207:   ;
 208:  LBL[5] ;
 209:  R[8:MOD_RCP_X]=1    ;
 210:  R[9:MOD_RCP_Y]=R[9:MOD_RCP_Y]+1    ;
 211:  PR[6,1:MOD_RCP_PSN]=PR[8,1:MOD_PSN]    ;
 212:  PR[6,2:MOD_RCP_PSN]=PR[6,2:MOD_RCP_PSN]-R[7:MOD_RCP_YOFFSET]    ;
 213:  JMP LBL[4] ;
 214:  !!! CHECK TO SEE CURRENT RECIPE ;
 215:  !!! END ;
 216:   ;
 217:   ;
 218:   ;
 219:  !!! MODULE FULL, CHECK STATUS ;
 220:  !!! START ;
 221:  LBL[998] ;
 222:  R[11:RECIPE_IO_IDX]=1    ;
 223:  R[8:MOD_RCP_X]=1    ;
 224:  R[9:MOD_RCP_Y]=1    ;
 225:   ;
 226:  ! Check to see if Ice Tray Full ;
 227:  IF R[5:MODULE_X]=6 AND R[15:MODULE_Y]=4,JMP LBL[997] ;
 228:   ;
 229:  ! Check if module row full ;
 230:  R[5:MODULE_X]=R[5:MODULE_X]+1    ;
 231:  IF R[5:MODULE_X]>6,JMP LBL[6] ;
 232:   ;
 233:  ! Increment module column ;
 234:  PR[8,1:MOD_PSN]=PR[8,1:MOD_PSN]+R[13:MODULE_XOFFSET]    ;
 235:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 236:  JMP LBL[4] ;
 237:   ;
 238:  ! Increment module row and reset  ;
 239:  LBL[6] ;
 240:  R[5:MODULE_X]=1    ;
 241:  R[15:MODULE_Y]=R[15:MODULE_Y]+1    ;
 242:  PR[10:TMP_MOD_RCP]=P[4:FIRST_RCP]    ;
 243:  PR[8,1:MOD_PSN]=PR[10,1:TMP_MOD_RCP]    ;
 244:  PR[8,2:MOD_PSN]=PR[8,2:MOD_PSN]+R[14:MODULE_YOFFSET]    ;
 245:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 246:  JMP LBL[4] ;
 247:   ;
 248:  ! Switched from ice tray ;
 249:  ! to ice tray ;
 250:  LBL[997] ;
 251:  ! Check am I out of Ice Trays ;
 252:  IF R[16:ICE_TRAY_NUM]=2,JMP LBL[996] ;
 253:   ;
 254:  ! Increment Ice Tray and set mod ;
 255:  ! and mod_rcp equal ;
 256:  R[16:ICE_TRAY_NUM]=R[16:ICE_TRAY_NUM]+1    ;
 257:  PR[11,2:ICE_TRAY_PSN]=PR[11,2:ICE_TRAY_PSN]+R[17:ICE_TRAY_YOFFSET]    ;
 258:  PR[8:MOD_PSN]=PR[11:ICE_TRAY_PSN]    ;
 259:  PR[6:MOD_RCP_PSN]=PR[8:MOD_PSN]    ;
 260:  JMP LBL[4] ;
 261:  !!! MODULE FULL, CHECK STATUS ;
 262:  !!! END ;
 263:   ;
 264:  LBL[996] ;
 265:  END ;
/POS
P[1:"DATUM"]{
   GP1:
	UF : 3, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   424.654999  mm,	Y =   183.154999  mm,	Z =     0.000000  mm,
	W =  -180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[2:"FIRST_PIN"]{
   GP1:
	UF : 3, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   369.580994  mm,	Y =   174.535004  mm,	Z =     0.000000  mm,
	W =  -180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[3:"CAMERA"]{
   GP1:
	UF : 3, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   207.901993  mm,	Y =   332.035004  mm,	Z =    82.065002  mm,
	W =  -180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
P[4:"FIRST_RCP"]{
   GP1:
	UF : 3, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   108.552002  mm,	Y =   190.020996  mm,	Z =     0.000000  mm,
	W =  -180.000000 deg,	P =     0.000000 deg,	R =     0.000000 deg
};
/END
