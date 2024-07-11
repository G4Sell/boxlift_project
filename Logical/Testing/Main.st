
PROGRAM _INIT
	Output := TRUE;

END_PROGRAM

PROGRAM _CYCLIC
	R_TRIG_0(CLK := Input);
	F_TRIG_0(CLK := Input);
	
	IF R_TRIG_0.Q THEN
		Output := FALSE;
	ELSIF F_TRIG_0.Q THEN
		Output := TRUE;
	END_IF;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
END_PROGRAM

