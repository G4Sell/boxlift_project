
TYPE
	SystemManagementType : STRUCT
		InputSignals : InputSignalsType;
		CurrentActions : CurrentActionsType;
        BoxCounter : BoxCounterType;
	END_STRUCT;

	CurrentActionsType : STRUCT
		GettingTop : BOOL;
		GettingBot : BOOL;
	END_STRUCT;

	InputSignalsType : STRUCT
		diBoxTop : BOOL;
		diBoxBot : BOOL;
		diLiftTop : BOOL;
		diLiftBot : BOOL;
		diBoxUnload : BOOL;
	END_STRUCT;


	ErrorManagementType : STRUCT 
		TimerCounter : TimerCounterType;
		Conditions : ConditionsType;
		ErrorCommands : ErrorCommandsType;
	END_STRUCT;

	ConditionsType : STRUCT
		ConditionTopErr : BOOL;
		ConditionBotErr : BOOL;
	END_STRUCT;

	TimerCounterType : STRUCT
		TON_0 : TON;
		TON_1 : TON;
	END_STRUCT;
	
	BoxCounterType : STRUCT
		BoxDeliveredCnt : CTU;
		BoxArrivedCnt : CTU;
		BoxesReceived : UINT;
	END_STRUCT;

	ErrorCommandsType : STRUCT
		CauseError : BOOL;
		CauseTestError : BOOL;
		ResetAlarms : BOOL;
		ClearHistory : BOOL; 
		AcknowledgeAlarms : BOOL;
	END_STRUCT;

END_TYPE
