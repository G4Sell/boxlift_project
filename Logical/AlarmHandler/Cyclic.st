
//********************************************************************* 
// Author: Gustav Forsell
// Created: 2024-07-12
// Description: This program implements a box delivery system from two conveyors to a lift.
//********************************************************************


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

	// Initialize the alarm system
	MpAlarmXCore_0();
	MpAlarmXHistory_0();
	MpAlarmXAcknowledgeAll_0();
	MpAlarmXHistory_0.Language := ADR(AlarmLanguage);

	NewBox := SystemManagement.InputSignals.diBoxBot OR SystemManagement.InputSignals.diBoxTop;
	SystemManagement.BoxCounter.BoxArrivedCnt(CU := NewBox);

	// check current task 
	IF gMain.State = TOP_POSE THEN
		SystemManagement.CurrentActions.GettingTop := TRUE;
	ELSIF gMain.State = BOT_POSE THEN
		SystemManagement.CurrentActions.GettingBot := TRUE;
	END_IF;

	// initialize timers
	ErrorManagement.TimerCounter.TON_0(IN:=SystemManagement.CurrentActions.GettingTop, PT:=T#13s);
	ErrorManagement.
	
	// reset timers if the box has arrived
	IF SystemManagement.InputSignals.diBoxUnload THEN
		SystemManagement.CurrentActions.GettingTop := FALSE;
		SystemManagement.CurrentActions.GettingBot := FALSE;
	END_IF;
	
	// check if the box has been delivered
	SystemManagement.BoxCounter.BoxDeliveredCnt(CU:=SystemManagement.InputSignals.diBoxUnload);
	
	// check if the box has been delivered in time
	ErrorManagement.Conditions.ConditionTopErr := SystemManagement.CurrentActions.GettingTop AND ErrorManagement.TimerCounter.TON_0.Q;
	ErrorManagement.Conditions.ConditionBotErr := SystemManagement.CurrentActions.GettingBot AND ErrorManagement.TimerCounter.TON_1.Q;

	// check if there are any errors and if so set alarm
	IF ErrorManagement.Conditions.ConditionTopErr OR ErrorManagement.Conditions.ConditionBotErr OR ErrorManagement.ErrorCommands.CauseError THEN
		IF NOT MpAlarmXCheckReaction(gAlarmXCore, 'StopAll') THEN
			MpAlarmXSet(gAlarmXCore, 'BoxLost');
		END_IF;
		gMain.Error := TRUE;
		gMain.State := WAIT;
	END_IF;

	// variables which acknowledges the alarms (only for testing)
	IF ErrorManagement.ErrorCommands.AcknowledgeAlarms THEN
		MpAlarmXAcknowledge(gAlarmXCore, 'BoxLost');
		MpAlarmXAcknowledge(gAlarmXCore, 'TestingAlarm');
	END_IF;

	// variable which causes an alarms (only for testing)
	IF ErrorManagement.ErrorCommands.CauseTestError THEN
		MpAlarmXSet(gAlarmXCore, 'TestingAlarm');
	END_IF;

	// variables which resets the alarms
	IF ErrorManagement.ErrorCommands.ResetAlarms THEN		
		MpAlarmXReset(gAlarmXCore, 'BoxLost');
		MpAlarmXReset(gAlarmXCore, 'TestingAlarm');
		SystemManagement.CurrentActions.GettingBot := FALSE;
		SystemManagement.CurrentActions.GettingBot := FALSE;
		gMain.Restart := TRUE;
	END_IF;

	// variables which clears the alarm history
	IF ErrorManagement.ErrorCommands.ClearHistory THEN
		MpAlarmXClearHistory(gAlarmXHistory);
	END_IF;

	SystemManagement.BoxCounter.BoxesReceived := SystemManagement.BoxCounter.BoxDeliveredCnt.CV;

END_PROGRAM
