
PROGRAM _INIT
	(* 	These parameters can be changed to change
	 	the behaviour of the simulation.
	 	Default values and units are commented after each parameter. *)
	Configuration.aoBoxSpawnRateTop			:= 20; (* 20 s *)
	Configuration.aoBoxSpawnRateBottom		:= 25; (* 25 s *)
	Configuration.aoConvSpeedInTop			:= 0.6; (* 0.6 m/s *)
	Configuration.aoConvSpeedOutTop			:= 0.7; (* 0.9 m/s *)
	Configuration.aoConvSpeedInBottom		:= 0.5; (* 0.5 m/s *)
	Configuration.aoConvSpeedOutBottom		:= 0.7; (* 0.9 m/s *)
	Configuration.aoConvSpeedLift			:= 0.9; (* 0.9 m/s *)
	Configuration.aoConvSpeedUnload			:= 0.9; (* 0.9 m/s *)
	Configuration.aoLiftTravelSpeed			:= 0.6; (* 0.4 m/s *)
	
	(* 	The global variables to communicate with OPC UA has to be initated.
	Don't change anything below! *)
	Inputs;
	Outputs;
	
	(* Initiate counter and heartbeat timer. *)
	Configuration.InternalHeartbeatTimer(IN:=TRUE, PT:=T#500ms);
	Configuration.HeartbeatTimer(IN:=TRUE, PT:=T#1500ms);
	
END_PROGRAM

PROGRAM _CYCLIC
	(*	The heartbeat is used to check if the OPC UA connection between
		Automation Studio and RobotStudio is still up. 
		In both AS and RS, a counter is increased once per second,
		and if the difference between the internal and incoming
		counter is greater than the tolerance, it is assumed that the
		OPC UA connection is down. *)
	
	(*	Call and update internal counter only when the simulation is active. *)
	IF Inputs.diSimRunning THEN
		
		IF NOT Configuration.HeartbeatTimer.Q THEN
			
			(* 	If the current external counter is the same as the last one,
				the connection is down. *)
			IF Inputs.aiExternalCounter = Configuration.diLastExtCounter THEN
				Outputs.doConnectionError := TRUE;
			ELSE
				Configuration.diLastExtCounter := Inputs.aiExternalCounter;
				Outputs.doConnectionError := FALSE;
			END_IF
			
		END_IF

	END_IF
	
	(* Update counter and call timer. *)
	Outputs.doInternalHeartbeat := Configuration.InternalHeartbeatTimer.Q;
	Configuration.InternalHeartbeatTimer(IN:=(NOT Configuration.InternalHeartbeatTimer.Q), PT:=T#500ms);
	Configuration.HeartbeatTimer(IN:=(NOT Configuration.HeartbeatTimer.Q), PT:=T#1500ms);
	
END_PROGRAM

PROGRAM _EXIT
	 
END_PROGRAM

