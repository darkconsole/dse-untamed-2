ScriptName dcc_ut2_QuestController extends Quest
Int Version = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; libraries ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut2_QuestLibAnimate   Property Anim Auto
dcc_ut2_QuestLibEncounter Property Sexl Auto
dcc_ut2_QuestLibPack      Property Pack Auto
dcc_ut2_QuestLibUtil      Property Util Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; subsystems ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut2_QuestConfig Property Config Auto
dcc_ut2_QuestInterfaceXP Property XPBar Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Actor Property Player Auto

Keyword Property KeywordActorTypeAnimal Auto
Keyword Property KeywordActorTypeCreature Auto

Faction Property FactionPredator Auto
Faction Property FactionTamed Auto
Faction Property FactionPackStay Auto

Package Property PackageDoNothing Auto
Package Property PackageFollow Auto
Package Property PackagePackStay Auto

Static Property StaticX Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mod management api ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut2_QuestController Function Get() Global
{Return the API object for access without binding. Primarily for use in things
like dialog fragments where IDGAF.}

	Return Game.GetFormFromFile(0xD62,"dcc-untamed-2.esp") as dcc_ut2_QuestController
EndFunction

Int Function GetVersion()
{Return the scripting version. Probably will not match release versions.}

	Return Version
EndFunction

Function ResetMod()
{cause the mod to reset itself.}

	self.Reset()
	self.Stop()
	self.Start()

	Return
EndFunction

Function ResetMod_Subsystems()
{handle rebooting the libraries and subsystems.}

	Int Iter = 0
	Form[] Systems = new Form[7]

	Systems[0] = self.Config
	Systems[1] = self.Util
	Systems[2] = self.Anim
	Systems[3] = self.Sexl
	Systems[4] = self.Pack
	Systems[5] = self.Util
	Systems[6] = self.XPBar

	While(Iter < Systems.Length)
		(Systems[Iter] as Quest).Reset()
		(Systems[Iter] as Quest).Stop()
		(Systems[Iter] as Quest).Start()
	EndWhile

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnInit()
{detect mod reset}

	self.ResetMod_Subsystems()

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Tame(Actor Who)
{shortcut for SetTamed to force an actor friendly.}

	self.Util.SetTamed(Who,TRUE)
	Return
EndFunction

Function Untame(Actor Who)
{shortcut for SetTamed to reset an actor to untamed behaviour.}

	self.Util.SetTamed(Who,FALSE)
	Return
EndFunction

Float Function Experience(Actor Who, Float Amount=0.0)
{get how much xp the actor has, modding it by amount first if specified.}

	If(Amount != 0.0)
		self.Util.ModExperience(Who,Amount)
	EndIf

	Return self.Util.GetExperience(Who)
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

