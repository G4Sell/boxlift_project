

(* 
Pseudo Code
	cases = [ConvTop, ConvBot]

	Case 1:
	if diConvTop == True:
		doConvTop = False;
		doLiftTop = True;
		Unload;
	Case 2:
	if diConvBot == True:
		doConvBot = False;
		doLiftBot = True;

			while diLiftUnload == False;
				doLiftUnload = True;

	if currently doing somehting
		place in queue
	

	*)

// VAR
// 	TYPE 
		// Conv : STRUCT
		// 	CmdType : ConvOutputs
		// 	Status : ConvInputs;			
		// END_STRUCT

		// ConvOutputs : STRUCT
		// 	doConvTop : BOOL := FALSE;
		// 	doConvBot : BOOL := FALSE;
		// END_STRUCT

		// ConvInputs : STRUCT
		// 	diConvBot : BOOL := FALSE;
		// 	diConvTop : BOOL := FALSE;
		// 	diBoxtUnload : BOOL := FALSE;
		// END_STRUCT

		// Lift : STRUCT
		// 	Cmd : LiftOutputs;
		// 	Status : LiftrInputs;
		// END_STRUCT

		// LiftOutputs : STRUCT
		// 	doLiftTop : BOOL := FALSE;
		// 	doLiftBot : BOOL := FALSE;
		// 	doConvLift : BOOL := FALSE;
		// 	doLiftUnload : BOOL := FALSE;
		// END_STRUCT

		// LiftInputs : STRUCT
		// 	diLiftBot : BOOL := FALSE;
		// 	diLiftTop : BOOL := FALSE;
		// 	diBoxLift : BOOL := FALSE;
		// 	diLiftUnload : BOOL := FALSE;
		// END_STRUCT

		// StatesEnum:
		// (
		// 	TOP_POSE,
		// 	BOT_POSE,
		// 	GET_BOX,
		// 	UNLOAD_POSE,
		// 	UNLOAD_BOX,
		// 	WAIT
		// );
// 	END_TYPE
// END_VAR

PROGRAM _CYCLIC	
	
	IF MpAlarmXCheckReaction(gAlarmXCore, 'StopAll') THEN
		Input := TRUE;
	ELSE
		Input := FALSE;
	END_IF;
	
	IF EDGEPOS(Input) THEN
		Conv.Cmd.doConvBot := FALSE;
		Conv.Cmd.doConvTop := FALSE;
		Lift.Cmd.doLiftBot := FALSE;
		Lift.Cmd.doLiftTop := FALSE;
		Lift.Cmd.doLiftUnload := FALSE;
		Lift.Cmd.doConvLift := FALSE;
		selectLift := gMain.State;
		
	ELSIF EDGENEG(Input) THEN
		Conv.Cmd.doConvTop := TRUE;
		Conv.Cmd.doConvBot := TRUE;
	END_IF;
	
	IF NOT MpAlarmXCheckReaction(gAlarmXCore, 'StopAll') THEN
		IF gMain.AutomaticControl THEN
			
			IF (Conv.Status.diConvTop AND NOT Lift.Status.diLiftTop) THEN
				NextPose := TOP_POSE;
				Conv.Cmd.doConvTop := FALSE;
			END_IF;
			
			IF (Conv.Status.diConvBot = TRUE AND NOT Lift.Status.diLiftBot) THEN
				NextPose := BOT_POSE;
				Conv.Cmd.doConvBot := FALSE;
			END_IF;

			IF EDGEPOS(gMain.Restart) THEN
				selectLift := WAIT;
				gMain.Restart := FALSE;
			END_IF;

			gMain.State := selectLift; 
			
			CASE selectLift OF
			
				WAIT:
					IF Conv.Status.diConvTop = TRUE THEN
							selectLift := TOP_POSE;
						Conv.Cmd.doConvTop := FALSE;
					ELSIF (Conv.Status.diConvBot = TRUE) THEN
						selectLift := BOT_POSE;
						Conv.Cmd.doConvBot := FALSE;
					END_IF;
				
				TOP_POSE:
					Lift.Cmd.doLiftTop := TRUE; 
					IF Lift.Status.diLiftTop THEN
						Lift.Cmd.doLiftTop := FALSE;
						Conv.Cmd.doConvTop := TRUE;
						selectLift := GET_BOX;
					END_IF;
				
				BOT_POSE:
					Lift.Cmd.doLiftBot := TRUE;
					IF Lift.Status.diLiftBot THEN
						Lift.Cmd.doLiftBot := FALSE;
						Conv.Cmd.doConvBot := TRUE;
						selectLift := GET_BOX;
					END_IF;
			
				GET_BOX:
					Lift.Cmd.doConvLift := TRUE;
					IF Lift.Status.diBoxLift = TRUE THEN //the box is succesfully loaded onto the lift
						Lift.Cmd.doConvLift := FALSE;
						selectLift := UNLOAD_POSE;
					END_IF;
			
				UNLOAD_POSE:
					Lift.Cmd.doLiftUnload := TRUE;
					IF Lift.Status.diLiftUnload THEN
						Lift.Cmd.doLiftUnload := FALSE;
						selectLift := UNLOAD_BOX;
					END_IF;
				
				UNLOAD_BOX:
					Lift.Cmd.doConvLift := TRUE;
					IF Conv.Status.diBoxUnload THEN
						Lift.Cmd.doConvLift := FALSE;
						selectLift := WAIT;
					END_IF;
			END_CASE;
		END_IF;
	END_IF;
END_PROGRAM
