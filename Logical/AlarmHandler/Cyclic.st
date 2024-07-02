
(*
Psuedo code:

// check how many boxes have arrived?


if diTopBox:
	BoxArrived++:
if diBotBox:
	BoxArrived++;
if diUnload:
	BoxDeleivered++;

if lift called:
	start timer;
if enough time passed && diUnload not true:
	box failed TO be delivered;
	raise alarm;
ELSE IF diUnload is TRUE:
	reset timer;

8s for top
5s for bot

 *)


PROGRAM _CYCLIC

	MpAlarmXCore_0();
	MpAlarmXHistory_0();
	MpAlarmXAcknowledgeAll_0();
	MpAlarmXHistory_0.Language := ADR(AlarmLanguage);

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

	IF ConditionBotErr OR ConditionTopErr OR CauseError THEN
		IF NOT MpAlarmXCheckReaction(gAlarmXCore, 'StopAll') THEN
			MpAlarmXSet(gAlarmXCore, 'BoxLost');
		END_IF;
		gError := TRUE;
	END_IF;

	IF AcknowledgeAlarms THEN
		MpAlarmXAcknowledge(gAlarmXCore, 'BoxLost');
		MpAlarmXAcknowledge(gAlarmXCore, 'TestingAlarm');
	END_IF;

	IF CauseTestError THEN
		MpAlarmXSet(gAlarmXCore, 'TestingAlarm');
	END_IF;
	

	// IF AcknowledgeAllAlarms THEN
	// 	MpAlarmXAcknowledgeAll_0.Execute := TRUE;
	// 	MpAlarmXAcknowledgeAll_0();
	// END_IF;

	IF ResetAlarms THEN		
		MpAlarmXReset(gAlarmXCore, 'BoxLost');
		ConditionBotErr := FALSE;
		ConditionTopErr := FALSE;
		MpAlarmXReset(gAlarmXCore, 'TestingAlarm');
	END_IF;

	IF ClearHistory THEN
		MpAlarmXClearHistory(gAlarmXHistory);
	END_IF;

	BoxesReceived := BoxDeliveredCnt.CV;

END_PROGRAM
