Scriptname dse_ut2_QuestLibEncounter extends Quest
{this script will handle dealing with events from sexlab.}

dse_ut2_QuestController Property Untamed Auto

Event OnInit()
{library setup.}

	;; clear out event handlers.
	self.UnregisterForModEvent("OrgasmStart")

	;; apply event handlers.
	self.RegisterForModEvent("OrgasmStart", "OnEncounterEnding")

	Return
EndEvent

Event OnEncounterEnding(String EventName, String Args, Float Argc, Form From)
{detect when a sex scene ends.}

	If(!Untamed.Menu.Enabled)
		Return
	EndIf

	Actor[] Actors = Untamed.Anim.SexLab.HookActors(Args)
	sslBaseAnimation Animation = Untamed.Anim.SexLab.HookAnimation(Args)
	Int Iter = 0

	If(self.IsPlayerInvolved(Actors))
		self.OnEncounterEndingWithPlayer(Actors,Animation)
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OnEncounterEndingWithPlayer(Actor[] Actors, sslBaseAnimation Animation)
{handle what happens when a scene ends with the player involved.}

	Int BeastCount = self.CountBeastsInvolved(Actors)

	If(BeastCount > 0)
		self.OnBeastialEndingWithPlayer(Actors,Animation,BeastCount)
	Else
		self.OnLameEndingWithPlayer(Actors,Animation)
	EndIf

	Return
EndFunction

Function OnBeastialEndingWithPlayer(Actor[] Actors, sslBaseAnimation Animation, Int BeastCount)
{handle what happens when a scene ends with the player involved with beasts.}

	Untamed.Util.PrintDebug("Player Beastial Ending")

	;; you get positive xp for every beast involved when there are beasts
	;; involved.

	Float XP = (BeastCount * Untamed.Menu.OptEncounterXP)
	Int Iter = 0

	Untamed.Experience(Untamed.Player, XP)

	While(Iter < Actors.Length)
		If(Untamed.Pack.IsMember(Actors[Iter]))
			Untamed.Experience(Actors[Iter], XP)
		EndIf

		Iter += 1
	EndWhile

	Untamed.XPBar.UpdateUI()

	Return
EndFunction

Function OnLameEndingWithPlayer(Actor[] Actors, sslBaseAnimation Animation)
{there is a reason its spelled BESTiality.}

	Untamed.Util.PrintDebug("Player Humanoid Ending")

	;; you get negative xp for every humanoid involved when there are no
	;; beasts involved, unless you have the cross breeder perk.

	Float XP = ((((Actors.Length - 1) * Untamed.Menu.OptEncounterXP) * -1) * Untamed.Menu.OptEncounterHumanoidMult)

	If(Untamed.Player.HasPerk(Untamed.PerkCrossbreeder))
		XP = 0
	EndIf

	Untamed.Experience(Untamed.Player, XP)
	Untamed.XPBar.UpdateUI()

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Function IsPlayerInvolved(Actor[] Actors)
{determine if the player was involved in the scene.}

	Int Iter = 0
	Bool Found = FALSE

	While(Iter < Actors.Length)
		If(Actors[Iter] == Untamed.Player)
			Found = TRUE
			Iter = Actors.Length
		EndIf

		Iter += 1
	EndWhile

	Return Found
EndFunction

Int Function CountBeastsInvolved(Actor[] Actors)
{determine if animals were involved.}

	Int Count = 0
	Int Iter = 0
	Bool Found = FALSE

	While(Iter < Actors.Length)
		If(Actors[Iter].HasKeyword(Untamed.KeywordActorTypeAnimal))
			Count += 1
		ElseIf(Untamed.Menu.OptIncludeActorTypeCreature)
			If(Actors[Iter].HasKeyword(Untamed.KeywordActorTypeCreature))
				Count += 1
			EndIf
		EndIf

		Iter += 1
	EndWhile

	Return Count
EndFunction
