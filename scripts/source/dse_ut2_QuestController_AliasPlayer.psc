Scriptname dse_ut2_QuestController_AliasPlayer extends ReferenceAlias

dse_ut2_QuestController Property Untamed Auto

Event OnPlayerLoadGame()
{fires when the save is loaded.}

	;;PO3_SKSEfunctions.a_UnregisterForCellFullyLoaded(self)
	;;PO3_SKSEfunctions.a_RegisterForCellFullyLoaded(self)

	;; make sure our pack is ready.
	Untamed.Pack.FixMembers()

	;; prepare the xp widget.
	While(!Untamed.XPBar.Ready)
		Utility.Wait(1)
	EndWhile
	Untamed.Util.SetExperience(Untamed.Player,0.0)
	Untamed.Util.UpdateExperienceBar()

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnCombatStateChanged(Actor Who, Int CombatState)

	;; when entering combat i want to experiment with sending out an aoe that hits hostiles.
	;; this aoe would place a long duration spell on targets so we can catch who does damage
	;; and kills them so we can make some stats and grant pets additional xp.

	; 0 - not in combat
	; 1 - in combat
	; 2 - searching

	Return
EndEvent


