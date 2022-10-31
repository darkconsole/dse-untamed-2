Scriptname dse_ut2_QuestController_AliasPlayer extends ReferenceAlias

dse_ut2_QuestController Property Untamed Auto
Float Property SleepTimeStart = 0.0 Auto Hidden

Event OnPlayerLoadGame()
{fires when the save is loaded.}

	;;PO3_SKSEfunctions.a_UnregisterForCellFullyLoaded(self)
	;;PO3_SKSEfunctions.a_RegisterForCellFullyLoaded(self)

	self.UnregisterForSleep()
	self.RegisterForSleep()

	;; make sure our pack is ready.
	Untamed.Pack.FixMembers()

	;;;;;;;;

	Untamed.Util.PrintDebug("Game Load Script Complete")
	Return
EndEvent

Event OnCellLoad()
{fires haphazardly when the game feels like telling you about it.}

	;; the thing about this event, and the wiki seems to be right about this, is
	;; that it does not "fire reliable" as in like, if the cell was already in
	;; memory it will not fire. i can demonstrate this by walking in and out of
	;; my house in whiterun. it'll fire the first two load screens but not the
	;; third. however, when i was walking in and out of whiterun crossing the
	;; worldspace barrier, it always fired for me.

	;; make sure our pack is ready.
	Untamed.Pack.FixMembers()

	Return
EndEvent

Event OnCellFullyLoaded(Cell Where)
{fires every time a new cell loads - powerofthree's papyrus extension.}

	;; make sure our pack is ready.
	Untamed.Pack.FixMembers()

	Return
EndEvent

Event OnLocationChange(Location LocPrev, Location LocNew)
{fires when changing location areas.}

	;; make sure our pack is ready.
	Untamed.Pack.FixMembers()

	Return
EndEvent

Event OnHit(ObjectReference Whom, Form What, Projectile Bullet, Bool IsPowerful, Bool IsSneak, Bool IsBash, Bool WasBlocked)

	Return
EndEvent

Event OnSleepStart(Float TimeStart, Float TimeEnd)

	self.SleepTimeStart = TimeStart
	Untamed.Util.PrintDebug("[OnSleepStart] " + TimeStart + " => " + TimeEnd)

	Return
EndEvent

Event OnSleepStop(Bool Iptd)

	Float TimeEnd = Utility.GetCurrentGameTime()
	Float TimeSlept = TimeEnd - self.SleepTimeStart
	Float TimeMin = ((Untamed.Config.GetFloat(".PackSleepMinHr") - 0.1) / 24)
	Float HourSlept = TimeSlept * 24.0

	Float SleepXPM
	Int SleepDist
	Actor[] Pack
	Int Piter
	Int Pmult

	;; the tenth of a day fuckery in the min calc is to deal with how the
	;; game will stop sleeping just a fraction before the full time that was
	;; requested.

	If(TimeSlept >= TimeMin)
		;; give well rested for the amount of time a game day should last.

		Untamed.Util.PrintDebug("[OnSleepStop] " + TimeSlept)
		StorageUtil.SetFloatValue(Untamed.Player, Untamed.KeySleptHours, HourSlept)
		Untamed.Player.RemoveSpell(Untamed.SpellPackRested)

		;; give pack members level for sleeping near them.

		SleepXPM = Untamed.Config.GetFloat(".PackSleepXPM")
		SleepDist = Untamed.Config.GetInt(".PackSleepDist")
		Pack = Untamed.Pack.GetMemberList()
		Piter = 0
		Pmult = 0

		While(Piter < Pack.Length)
			If(Pack[Piter].GetDistance(Untamed.Player) <= SleepDist)
				Untamed.Util.ModExperience(Pack[Piter], (HourSlept * SleepXPM))
				Pmult += 1
			EndIf

			Piter += 1
		EndWhile

		;; give player level for sleeping near pack.

		If(Pmult > 0)
			Untamed.Util.ModExperience(Untamed.Player, ((HourSlept * SleepXPM) * Pmult))
			Untamed.Player.AddSpell(Untamed.SpellPackRested)
		EndIf

		Untamed.XPBar.RequestUpdate()
	EndIf

	Return
EndEvent

