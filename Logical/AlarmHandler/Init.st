

PROGRAM _INIT
	MpAlarmXCore_0.Enable := TRUE;
	MpAlarmXCore_0.MpLink := ADR(gAlarmXCore);

	MpAlarmXAcknowledgeAll_0.Enable := TRUE;
	MpAlarmXAcknowledgeAll_0.MpLink := ADR(gAlarmXCore);
	
	MpAlarmXHistory_0.Enable := TRUE;
	MpAlarmXHistory_0.MpLink := ADR(gAlarmXHistory);
	MpAlarmXHistory_0.DeviceName := ADR('Location');
	 
END_PROGRAM