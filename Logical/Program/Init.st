

PROGRAM _INIT
	(* Insert code here *)
	doConvTop := TRUE;
	doConvBot := TRUE;
	AutomaticControl := TRUE;
	F_TRIG_0.CLK := MpAlarmXCheckReaction(gAlarmXCore, 'StopAll');

END_PROGRAM