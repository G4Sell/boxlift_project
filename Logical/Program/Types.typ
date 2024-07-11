
TYPE
	ConvType : STRUCT
		Cmd : ConvControlType;
		Status : ConvStatusType;			
	END_STRUCT;

	ConvControlType : STRUCT
		doConvTop : BOOL := TRUE;
		doConvBot : BOOL := TRUE;
	END_STRUCT;

	ConvStatusType : STRUCT
		diConvBot : BOOL := FALSE;
		diConvTop : BOOL := FALSE;
		diBoxUnload : BOOL := FALSE;
	END_STRUCT;

	LiftType : STRUCT
		Cmd : LiftControlType;
		Status : LiftStatusType;
	END_STRUCT;

	LiftControlType : STRUCT
		doLiftTop : BOOL := FALSE;
		doLiftBot : BOOL := FALSE;
		doConvLift : BOOL := FALSE;
		doLiftUnload : BOOL := FALSE;
	END_STRUCT;

	LiftStatusType : STRUCT
		diLiftBot : BOOL := FALSE;
		diLiftTop : BOOL := FALSE;
		diBoxLift : BOOL := FALSE;
		diLiftUnload : BOOL := FALSE;
	END_STRUCT;

END_TYPE
