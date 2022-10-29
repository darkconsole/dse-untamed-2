Scriptname dse_ut2_QuestLibEncounter extends Quest
{this script will handle dealing with events from sexlab.}

dse_ut2_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnInit()
{library setup.}

	Untamed.Util.PrintDebug("[LibEncounter] on init")

	;; clear out event handlers.
	self.UnregisterForModEvent("AnimationStart")
	self.UnregisterForModEvent("AnimationEnd")
	self.UnregisterForModEvent("OrgasmStart")

	;; apply event handlers.
	self.RegisterForModEvent("AnimationStart", "OnEncounterStarting")
	self.RegisterForModEvent("AnimationEnd", "OnEncounterEnding")
	self.RegisterForModEvent("OrgasmStart", "OnEncounterOrgasm")

	Return
EndEvent

Event OnEncounterStarting(String EventName, String Args, Float Argc, Form From)
{detect when a sex scene ends.}

	If(!Untamed.OptEnabled)
		Return
	EndIf

	Actor[] Actors = Untamed.Anim.SexLab.HookActors(Args)
	sslBaseAnimation Animation = Untamed.Anim.SexLab.HookAnimation(Args)
	Int Iter = 0

	If(self.IsPlayerInvolved(Actors) && self.CountBeastsInvolved(Actors) > 0)
		While(Iter < Actors.Length)
			If(Actors[Iter] == Untamed.Player || Untamed.Pack.IsMember(Actors[Iter]))
				Untamed.Util.PrintDebug("[EncounterStart] " + Actors[Iter].GetDisplayName() + " has begun a bestial encounter")
				StorageUtil.SetFloatValue(Actors[Iter], Untamed.KeyEncounterTime, Utility.GetCurrentRealTime())
			EndIf
			Iter += 1
		EndWhile
	EndIf

	Return
EndEvent

Event OnEncounterEnding(String EventName, String Args, Float Argc, Form From)
{detect when a sex scene ends.}

	If(!Untamed.OptEnabled)
		Return
	EndIf

	Actor[] Actors = Untamed.Anim.SexLab.HookActors(Args)
	sslBaseAnimation Animation = Untamed.Anim.SexLab.HookAnimation(Args)
	Int Iter = 0
	Float Timer = 0.0
	Float Diff = 0.0
	Float UXP = 0.0

	If(self.IsPlayerInvolved(Actors) && self.CountBeastsInvolved(Actors) > 0)
		While(Iter < Actors.Length)
			If(Actors[Iter] == Untamed.Player || Untamed.Pack.IsMember(Actors[Iter]))
				Timer = StorageUtil.GetFloatValue(Actors[Iter], Untamed.KeyEncounterTime)
				Diff = PapyrusUtil.ClampFloat((Utility.GetCurrentRealTime() - Timer), 0.0, 9001.0)
				UXP = (Diff * Untamed.Config.GetFloat(".PackSexTimeXPM"))

				Untamed.Util.PrintDebug("[EncounterEnd] " + Actors[Iter].GetDisplayName() + " " + UXP + " Time Based UXP")

				If(UXP > 0.0)
					Untamed.Util.ModExperience(Actors[Iter], UXP)
				EndIf
			EndIf
			Iter += 1
		EndWhile
	EndIf

	Return
EndEvent

Event OnEncounterOrgasm(String EventName, String Args, Float Argc, Form From)
{detect when a sex scene ends.}

	If(!Untamed.OptEnabled)
		Return
	EndIf

	Actor[] Actors = Untamed.Anim.SexLab.HookActors(Args)
	sslBaseAnimation Animation = Untamed.Anim.SexLab.HookAnimation(Args)
	Int Iter = 0

	If(self.IsPlayerInvolved(Actors))
		self.OnEncounterOrgasmWithPlayer(Actors,Animation)
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OnEncounterOrgasmWithPlayer(Actor[] Actors, sslBaseAnimation Animation)
{handle what happens when a scene ends with the player involved.}

	Int BeastCount = self.CountBeastsInvolved(Actors)

	If(BeastCount > 0)
		self.OnBeastialOrgasmWithPlayer(Actors,Animation,BeastCount)
	Else
		self.OnLameOrgasmWithPlayer(Actors,Animation)
	EndIf

	Return
EndFunction

Function OnBeastialOrgasmWithPlayer(Actor[] Actors, sslBaseAnimation Animation, Int BeastCount)
{handle what happens when a scene ends with the player involved with beasts.}

	Untamed.Util.PrintDebug("Player Beastial Ending")

	;; you get positive xp for every beast involved when there are beasts
	;; involved.

	Float XP = (BeastCount * Untamed.Config.GetFloat(".PackOrgasmXP"))
	Float BXP = (XP * Untamed.Config.GetFloat(".PackShareXPM"))
	Int Iter = 0
	Int PregChance = 0
	Int PregRoll = 0

	Untamed.Experience(Untamed.Player, XP)

	While(Iter < Actors.Length)
		If(Untamed.Util.ActorIsBeast(Actors[Iter]))
			If(Untamed.Pack.IsMember(Actors[Iter]))
				Untamed.Experience(Actors[Iter], BXP)
			Else
				Untamed.Pack.AddMember(Actors[Iter])
			EndIf

			If(Untamed.Player.HasPerk(Untamed.PerkDenMother))
				PregChance = Untamed.Config.GetInt(".PregnancyChance")
				PregRoll = Utility.RandomInt(1, 100)

				If(PregChance > 0 && PregRoll <= PregChance)
					Untamed.Util.ActorSetPregnant(Untamed.Player, Actors[Iter])
				EndIf
			EndIf
		EndIf

		Iter += 1
	EndWhile

	Untamed.XPBar.RegisterForSingleUpdate(0.1)
	Return
EndFunction

Function OnLameOrgasmWithPlayer(Actor[] Actors, sslBaseAnimation Animation)
{there is a reason its spelled BESTiality.}

	Untamed.Util.PrintDebug("Player Humanoid Ending")

	;; you get negative xp for every humanoid involved when there are no
	;; beasts involved, unless you have the cross breeder perk.

	Float XP = ((((Actors.Length - 1) * Untamed.Config.GetFloat(".PackOrgasmXP")) * -1) * Untamed.Config.GetFloat(".HumanoidOrgasmXPM"))

	If(Untamed.Player.HasPerk(Untamed.PerkCrossbreeder))
		XP = 0
	EndIf

	Untamed.Experience(Untamed.Player, XP)
	Untamed.XPBar.RegisterForSingleUpdate(0.1)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function BeginMatingCall(Actor Caller)

	Int Found = 0
	Int Iter = 0
	Actor Which = NONE

	;;;;;;;;

	StorageUtil.FormListClear(NONE, Untamed.KeyMatingCallList)

	Untamed.SpellMatingCallTracker.Cast(Caller)
	Utility.Wait(2.0)

	;;;;;;;;

	Found = StorageUtil.FormListCount(NONE, Untamed.KeyMatingCallList)
	Untamed.Util.PrintDebug("[BeginMatingCall] " + Found + " found actors")

	While(Iter < Found)
		Which = StorageUtil.FormListGet(NONE, Untamed.KeyMatingCallList, Iter) as Actor

		If(Which != NONE)
			Untamed.Util.PrintDebug("[BeginMatingCall] " + Which.GetDisplayName() + " " + Which)
		EndIf

		ActorUtil.AddPackageOverride(Which, Untamed.PackageFollow, 100)
		Which.EvaluatePackage()

		Iter += 1
	EndWhile

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
	Bool IncludeCreatures = Untamed.Config.GetBool(".IncludeCreatures")

	While(Iter < Actors.Length)
		If(Untamed.Util.ActorIsBeast(Actors[Iter]))
			Count += 1
		EndIf

		Iter += 1
	EndWhile

	Return Count
EndFunction
