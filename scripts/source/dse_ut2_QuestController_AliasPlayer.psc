Scriptname dse_ut2_QuestController_AliasPlayer extends ReferenceAlias

dse_ut2_QuestController Property Untamed Auto

Event OnPlayerLoadGame()

	;; make sure our pack is ready.
	Untamed.Pack.FixMembers()

	;; prepare the xp widget.
	While(!Untamed.XPBar.Ready)
		Utility.Wait(1)
	EndWhile
	Untamed.Util.UpdateExperienceBar()

	;;;;;;;;

	Untamed.Util.PrintDebug("Game Load Script Complete")
	Return
EndEvent

