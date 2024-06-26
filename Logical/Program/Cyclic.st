

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



PROGRAM _CYCLIC	
	
	IF NOT ManualControl THEN

		IF (diConvTop AND NOT diLiftTop) THEN
			NextPose := TOP_POSE;
			doConvTop := FALSE;
		END_IF;
		
		IF (diConvBot = TRUE AND NOT diLiftBot) THEN
			NextPose := BOT_POSE;
			doConvBot := FALSE;
		END_IF;
		
		CASE selectLift OF
		
			WAIT:
				IF (diConvTop = TRUE) THEN
					selectLift := TOP_POSE;
					doConvTop := FALSE;
				ELSIF (diConvBot = TRUE) THEN
					selectLift := BOT_POSE;
					doConvBot := FALSE;
				END_IF;
			
			TOP_POSE:
				doLiftTop := TRUE; 
				IF (diLiftTop = TRUE) THEN
					doLiftTop := FALSE;
					doConvTop := TRUE;
					selectLift := GET_BOX;
				END_IF;
			
			BOT_POSE:
				doLiftBot := TRUE;
				IF diLiftBot = TRUE THEN
					doLiftBot := FALSE;
					doConvBot := TRUE;
					selectLift := GET_BOX;
				END_IF;
		
			GET_BOX:
				doConvLift := TRUE;
				IF diBoxLift = TRUE THEN //the box is succesfully loaded onto the lift
					doConvLift := FALSE;
					selectLift := UNLOAD_POSE;
				END_IF;
		
			UNLOAD_POSE:
				doLiftUnload := TRUE;
				IF diLiftUnload = TRUE THEN
					doLiftUnload := FALSE;
					selectLift := UNLOAD_BOX;
				END_IF;
			
			UNLOAD_BOX:
				doConvLift := TRUE;
				IF diBoxUnload = TRUE THEN
					doConvLift := FALSE;
					selectLift := WAIT;
				END_IF;
		END_CASE;
	END_IF;

	 
END_PROGRAM
