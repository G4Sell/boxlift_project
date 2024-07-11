
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

	NewBox := SystemManagement.InputSignals.diBoxBot OR SystemManagement.InputSignals.diBoxTop;
	SystemManagement.BoxCounter.BoxArrivedCnt(CU := NewBox);

	IF gMain.State = TOP_POSE THEN
		SystemManagement.CurrentActions.GettingTop := TRUE;
	ELSIF gMain.State = BOT_POSE THEN
		SystemManagement.CurrentActions.GettingBot := TRUE;
	END_IF;

	ErrorManagement.TimerCounter.TON_0(IN:=SystemManagement.CurrentActions.GettingTop, PT:=T#13s);
	ErrorManagement.TimerCounter.TON_1(IN:=SystemManagement.CurrentActions.GettingBot, PT:=T#13s);

	IF SystemManagement.InputSignals.diBoxUnload THEN
		SystemManagement.CurrentActions.GettingTop := FALSE;
		SystemManagement.CurrentActions.GettingBot := FALSE;
	END_IF;
	
	SystemManagement.BoxCounter.BoxDeliveredCnt(CU:=SystemManagement.InputSignals.diBoxUnload);
	
	ErrorManagement.Conditions.ConditionTopErr := SystemManagement.CurrentActions.GettingTop AND ErrorManagement.TimerCounter.TON_0.Q;
	ErrorManagement.Conditions.ConditionBotErr := SystemManagement.CurrentActions.GettingBot AND ErrorManagement.TimerCounter.TON_1.Q;

	IF ErrorManagement.Conditions.ConditionTopErr OR ErrorManagement.Conditions.ConditionBotErr OR ErrorManagement.ErrorCommands.CauseError THEN
		IF NOT MpAlarmXCheckReaction(gAlarmXCore, 'StopAll') THEN
			MpAlarmXSet(gAlarmXCore, 'BoxLost');
		END_IF;
		gMain.Error := TRUE;
		gMain.State := WAIT;
	END_IF;

	IF ErrorManagement.ErrorCommands.AcknowledgeAlarms THEN
		MpAlarmXAcknowledge(gAlarmXCore, 'BoxLost');
		MpAlarmXAcknowledge(gAlarmXCore, 'TestingAlarm');
	END_IF;

	IF ErrorManagement.ErrorCommands.CauseTestError THEN
		MpAlarmXSet(gAlarmXCore, 'TestingAlarm');
	END_IF;

	IF ErrorManagement.ErrorCommands.ResetAlarms THEN		
		MpAlarmXReset(gAlarmXCore, 'BoxLost');
		MpAlarmXReset(gAlarmXCore, 'TestingAlarm');
		SystemManagement.CurrentActions.GettingBot := FALSE;
		SystemManagement.CurrentActions.GettingBot := FALSE;
		gMain.Restart := TRUE;
	END_IF;

	IF ErrorManagement.ErrorCommands.ClearHistory THEN
		MpAlarmXClearHistory(gAlarmXHistory);
	END_IF;

	SystemManagement.BoxCounter.BoxesReceived := SystemManagement.BoxCounter.BoxDeliveredCnt.CV;

END_PROGRAM
