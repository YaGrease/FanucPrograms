/PROG  TEST1
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 599;
CREATE		= DATE 26-05-05  TIME 17:00:38;
MODIFIED	= DATE 26-05-05  TIME 17:00:38;
FILE_NAME	= TEST1;
VERSION		= 0;
LINE_COUNT	= 3;
MEMORY_SIZE	= 959;
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
   1:J PR[1:TMP_DATUM] 100% FINE    ;
   2:J P[3] 100% FINE    ;
   3:   ;
/POS
P[1]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   -22.034184  mm,	Y =  -500.095459  mm,	Z =   227.467758  mm,
	W =  -180.000000 deg,	P =     0.000000 deg,	R =  -148.733963 deg
};
P[2]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   -12.034000  mm,	Y =  -500.095001  mm,	Z =   227.468002  mm,
	W =  -180.000000 deg,	P =     0.000000 deg,	R =  -148.733994 deg
};
P[3]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'L, 0, 0, 0',
	X =   270.000000  mm,	Y =   261.000000  mm,	Z =   266.000000  mm,
	W =  -180.000000 deg,	P =     0.000000 deg,	R =  -148.733994 deg
};
/END
