ScriptName dcc_ut2_QuestLibUtil extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut2_QuestController Property Untamed Auto

String Property KeyXP = "UT2.Actor.Experience" Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Print(String Msg)
{send a message to the notification area.}

	Debug.Notification("[UT2] " + Msg)
	Return
EndFunction

Function PrintDebug(String Msg)
{send a message to the console.}

	;;If(!self.OptDebug)
	;;	Return
	;;EndIf

	MiscUtil.PrintConsole("[UT2] " + Msg)
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Public Actor API.
;; These functions are intended for direct use for complete manipulation of
;; actor features.

Function SetTamed(Actor Who, Bool Enable)
{tame an actor to make it friendly as a potential pack member.}

	If(Enable)
		self.PrintDebug("Taming " + Who.GetDisplayName())

		;; stop being a dick to everything.
		Who.RemoveFromFaction(Untamed.FactionPredator)
		Who.SetAV("Aggression",1)

		;; stop being a dick to the player.
		Who.AddToFaction(Untamed.FactionTamed)
		Who.SetFactionRank(Untamed.FactionTamed,1)
		Who.SetRelationshipRank(Untamed.Player,3)
		Who.SetPlayerTeammate(TRUE,FALSE)
		Who.AllowPCDialogue(TRUE)
		self.StopCombat(Who)
	Else
		self.PrintDebug("Untaming " + Who.GetDisplayName())
		Who.RemoveFromFaction(Untamed.FactionTamed)
		Who.SetPlayerTeammate(FALSE,FALSE)
		Who.AllowPCDialogue(FALSE)
	EndIf

	self.SetPersistHack(Who,Enable)
	self.SetPassive(Who,Enable)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Private Actor API.
;; These are small chunks that manage specific aspects. Do not use these
;; directly unless you are sure of what you are doing.

Function SetPersistHack(Actor Who, Bool Enable)
{little trick to keep temporary actors around.}

	If(Enable)
		Who.RegisterForUpdate(3600)
	Else
		Who.UnregisterForUpdate()
	EndIf

	Return
EndFunction

Function SetPassive(Actor Who, Bool Enable)
{make an actor passive by forcing a nothing package.}

	If(Enable)
		ActorUtil.AddPackageOverride(Who,Untamed.PackageDoNothing,99)
	Else
		ActorUtil.RemovePackageOverride(Who,Untamed.PackageDoNothing)
	EndIf

	Return
EndFunction

Function CanOpenDoors(Actor Who)
{make an actor able to open doors...}

	Who.GetRace().ClearCantOpenDoors()

	Return
EndFunction

Function CanTalk(Actor Who)
{make an actor able to engage dialog...}

	Who.AllowPCDialogue(TRUE)

	Return
EndFunction

Function StopCombat(Actor Who)
{try to break an actor's current combat target.}

	Who.StopCombat()
	Who.StopCombatAlarm()

	Return
EndFunction

Function SheatheWeapons(Actor Who, Bool Wait=TRUE)
{sheathe weapons. optionally wait a while just to make sure. if you are needing
to command multiple actors to sheathe you should pass Wait as FALSE for all of
them except the last one. so clever.}

	If(Who.IsWeaponDrawn())
		Who.SheatheWeapon()

		If(Wait)
			Utility.Wait(3.0)
		EndIf
	EndIf

	Return
EndFunction

Function FixAnimalActor(Actor Who)
{animal actors have some flags set on them are problematic, but we can fix them
without having to edit their forms causing conflicts.}

	;; note we should do this
	;; 1) when a save is loaded to all pack members.
	;; 2) every time the pack follower ability gets reapplied by the alias.

	Untamed.Util.CanOpenDoors(Who)
	Untamed.Util.CanTalk(Who)

	Untamed.Util.PrintDebug("Fix Animal Actor: " + Who.GetDisplayName())
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; simple event api

Function SendActorEvent(Actor Who, String EventName)
{sends a simple mod event that just notifies that an actor did something
that has no values associated with it.}

	Int EventID = ModEvent.Create(EventName)

	If(EventID)
		ModEvent.PushForm(EventID,Who)
		ModEvent.Send(EventID)
	EndIf

	Return
EndFunction

Function SendActorEventInt(Actor Who, String EventName, Int Value)
{sends a simple mod event that just notifies that an actor did something
with a value that is an integer.}

	Int EventID = ModEvent.Create(EventName)

	If(EventID)
		ModEvent.PushForm(EventID,Who)
		ModEvent.PushInt(EventID,Value)
		ModEvent.Send(EventID)
	EndIf

	Return
EndFunction

Function SendActorEventFloat(Actor Who, String EventName, Float Value)
{sends a simple mod event that just notifies that an actor did something
with a value that is a float.}

	Int EventID = ModEvent.Create(EventName)

	If(EventID)
		ModEvent.PushForm(EventID,Who)
		ModEvent.PushFloat(EventID,Value)
		ModEvent.Send(EventID)
	EndIf

	Return
EndFunction

Function SendActorEventString(Actor Who, String EventName, String Value)
{sends a simple mod event that just notifies that an actor did something
with a value that is a string.}

	Int EventID = ModEvent.Create(EventName)

	If(EventID)
		ModEvent.PushForm(EventID,Who)
		ModEvent.PushString(EventID,Value)
		ModEvent.Send(EventID)
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; actor experience api

Function ModExperience(Actor Who, Float Amount)
{give or take away untamed xp from an actor.}

	Float XP = self.GetExperience(Who) + Amount

	self.SetExperience(Who,XP)
	Return
EndFunction

Float Function GetExperience(Actor Who)
{get the amount of xp this actor has.}

	Return StorageUtil.GetFloatValue(Who,self.KeyXP)
EndFunction

Float Function GetExperienceMax(Actor Who)
{get the maximum amount of xp this actor can store at once.}

	Float Max = 100.0

	;; @todo - allow perks to adjust the max xp an actor can have stored.

	Return Max
EndFunction

Float Function GetExperiencePercent(Actor Who)
{get the current xp as a percent}

	Return (self.GetExperience(Who) / self.GetExperienceMax(Who)) * 100
EndFunction

Function SetExperience(Actor Who, Float XP)
{set the amount of xp this actor has.}
	
	Float Max = self.GetExperienceMax(Who)
	XP = PapyrusUtil.ClampFloat(XP,0.0,Max)

	StorageUtil.SetFloatValue(Who,self.KeyXP,XP)

	If(Who == Untamed.Player)
		Untamed.XPBar.SetPercent((XP / Max) * 100)
	EndIf

	Return
EndFunction

Function UpdateExperienceBar()
{update xp bar with current value.}

	Untamed.XPBar.SetPercent(self.GetExperiencePercent(Untamed.Player))
EndFunction
