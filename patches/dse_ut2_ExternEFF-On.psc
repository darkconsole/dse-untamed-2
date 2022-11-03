ScriptName dse_ut2_ExternEFF extends Quest
{enabled.}

Bool Function IsEnabled() Global

	Return TRUE
EndFunction

Function AddToPanel(Actor Who) Global

	;; this way is technically better but it will cause the entire eff
	;; system to get used which also causes annoyances with my own package
	;; stack for stay and follow.

	;;int EvID = ModEvent.Create("XFL_System_AddFollower")
	;;ModEvent.PushForm(EvID, Who)
	;;ModEvent.Send(EvID)

	;; this requires a lib that can be patched in and out with fomod installer
	;; but it is nicer because it gets eff to put them in the health bars but
	;; not do the full eff takeover.

	EFFCore EFF = Game.GetFormFromFile(0x000EFF, "EFFCore.esm") as EFFCore

	If(EFF == NONE)
		Debug.MessageBox("UT2[AddToEFF]: EFF patch used but EFF is not loaded.")
		Return
	EndIf

	EFF.XFL_Panel.AddActors(Who)
	Return
EndFunction

Function RemoveFromPanel(Actor Who) Global

	;;int EvID = ModEvent.Create("XFL_System_Dismiss")
	;;ModEvent.PushForm(EvID, Who)
	;;ModEvent.PushInt(EvID, 0)
	;;ModEvent.PushInt(EvID, 0)
	;;ModEvent.Send(EvID)

	EFFCore EFF = Game.GetFormFromFile(0x000EFF, "EFFCore.esm") as EFFCore

	If(EFF == NONE)
		Debug.MessageBox("UT2[AddToEFF]: EFF patch used but EFF is not loaded.")
		Return
	EndIf

	EFF.XFL_Panel.RemoveActors(Who)
	Return
EndFunction
