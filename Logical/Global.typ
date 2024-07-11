
TYPE
    StatesEnum:
	(
		WAIT,
		TOP_POSE,
		BOT_POSE,
		GET_BOX,
		UNLOAD_POSE,
		UNLOAD_BOX
	);

    MainType : STRUCT
        AutomaticControl : BOOL := TRUE;
        State : StatesEnum := WAIT;
		Error : BOOL;
        Restart : BOOL;
    END_STRUCT;

END_TYPE
