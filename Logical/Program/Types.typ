
TYPE
	ConvType : 	STRUCT  (*Input and outputs for the conveyer belts*)
		Cmd : ConvControlType; (*Output commands for the conveyer belts*)
		Status : ConvStatusType; (*Input signals from the conveyer belts*)
	END_STRUCT;
	ConvControlType : 	STRUCT  
		doConvTop : BOOL := TRUE; (*digital output for top conv*)
		doConvBot : BOOL := TRUE; (*digital output for bot conv*)
	END_STRUCT;
	ConvStatusType : 	STRUCT 
		diConvBot : BOOL := FALSE;  (*digital input for the scanner on the bot conv*)
		diConvTop : BOOL := FALSE;  (*digital input for the scanner on the top conv*)
		diBoxUnload : BOOL := FALSE;  (*digital input for the scanner on the unloading conv*)
	END_STRUCT;
	LiftType : 	STRUCT (*Input and output for the lift*)
		Cmd : LiftControlType; (*Output commands for the lift*)
		Status : LiftStatusType; (*Input signals from the *)
	END_STRUCT;
	LiftControlType : 	STRUCT 
		doLiftTop : BOOL := FALSE; (*digital output for the lift top position*)
		doLiftBot : BOOL := FALSE; (*digital output for the lift bot position*)
		doConvLift : BOOL := FALSE; (*digital output for the lift conveyer*)
		doLiftUnload : BOOL := FALSE; (*digital output for the lift unload positions*)
	END_STRUCT;
	LiftStatusType : 	STRUCT 
		diLiftBot : BOOL := FALSE; (*digital input of the bottom position of the lift*)
		diLiftTop : BOOL := FALSE; (*digital input of the bottom position of the lift*)
		diBoxLift : BOOL := FALSE; (*digital input of the scanner on the lift conv *)
		diLiftUnload : BOOL := FALSE; (*digital input of the unload position of the lift*)
	END_STRUCT;
END_TYPE
