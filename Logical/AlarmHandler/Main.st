
PROGRAM _INIT
	MpAlarmXCore_0.Enable := TRUE;
	MpAlarmXCore_0.MpLink := ADR(MpLinkBOXgAlarmXCore); 
	 
END_PROGRAM
	
(*
Psuedo code:

// check how many boxes have arrived?


IF diTopBox:
	BoxArrived++:
IF diBotBox:
	BoxArrived++;
IF diUnload:
	BoxDeleivered++;

IF lift called:
	start timer;
IF enough time passed && diUnload NOT TRUE:
	box failed TO be delivered;
	raise alarm;
else if diUnload is true:
	reset timer;

8s for top
5s for bot

 *)


PROGRAM _CYCLIC

	MpAlarmXCore_0();
	//MpAlarmXHistory_0.Language := AlarmLanguage;

	NewBox := diBoxBot OR diBoxTop;
	BoxArrivedCnt(CU:=NewBox);

	IF diBoxTop THEN
		GettingTop := TRUE;
	ELSIF diBoxBot THEN
		GettingBot := TRUE;
	END_IF;

	TON_0(IN:=GettingTop, PT:=T#13s);
	TON_1(IN:=GettingBot, PT:=T#13s);

	IF diBoxUnload THEN
		GettingTop := FALSE;
		GettingBot := FALSE;
	END_IF;
	
	BoxDeliveredCnt(CU:=diBoxUnload);

	ConditionTopErr := GettingTop AND TON_0.Q;
	ConditionBotErr := GettingBot AND TON_1.Q;

	IF ConditionBotErr OR ConditionTopErr THEN
		// MpAlarmXSet(MpLinkBOXgAlarmXCore, 'BoxLost');
		gError := TRUE;
	END_IF;

	BoxesReceived := BoxDeliveredCnt.CV;
	 
END_PROGRAM

PROGRAM _EXIT
	MpAlarmXCore_0.Enable := FALSE;
	MpAlarmXCore_0();
	 
END_PROGRAM

