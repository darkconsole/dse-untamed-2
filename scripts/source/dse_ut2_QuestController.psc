ScriptName dse_ut2_QuestController extends Quest
Int Version = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; libraries ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestLibAnimate   Property Anim Auto
dse_ut2_QuestLibTrainer   Property Feat Auto
dse_ut2_QuestLibPack      Property Pack Auto
dse_ut2_QuestLibEncounter Property Sexl Auto
dse_ut2_QuestLibUtil      Property Util Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; subsystems ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestConfig Property Config Auto
dse_ut2_QuestMCM Property Menu Auto
dse_ut2_QuestInterfaceXP Property XPBar Auto
dse_ut2_QuestLove01 Property QuestLove01 Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; form references ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Actor        Property Player Auto                   ;; skyrim.esm
ActorBase    Property ActorTrainer Auto             ;; untamed
Keyword      Property KeywordActorTypeAnimal Auto   ;; skyrim.esm
Keyword      Property KeywordActorTypeCreature Auto ;; skyrim.esm
Faction      Property FactionPredator Auto          ;; skyrim.esm
Faction      Property FactionTamed Auto             ;; untamed
Faction      Property FactionPackStay Auto          ;; untamed
Package      Property PackageDoNothing Auto         ;; untamed
Package      Property PackageFollow Auto            ;; untamed
Package      Property PackagePackStay Auto          ;; untamed
Perk         Property PerkCrossbreeder Auto         ;; untamed
Perk         Property PerkDenMother Auto            ;; untamed
Perk         Property PerkExperienced Auto          ;; untamed
Perk         Property PerkPackLeader1 Auto          ;; untamed
Perk         Property PerkPackLeader2 Auto          ;; untamed
Perk         Property PerkPackLeader3 Auto          ;; untamed
Perk         Property PerkResistantHide Auto    ;; untamed
Perk         Property PerkThickHide Auto        ;; untamed
Static       Property StaticX Auto                  ;; skyrim.esm
VisualEffect Property VfxTeleportIn Auto            ;; untamed

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mod management api ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestController Function Get() Global
{Return the API object for access without binding. Primarily for use in things
like dialog fragments where IDGAF.}

	Return Game.GetFormFromFile(0xD62,"dse-untamed-2.esp") as dse_ut2_QuestController
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

	Systems[0] = self.Menu
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

		Iter += 1
	EndWhile

	self.UnregisterForModEvent("SexLabOrgasm")
	self.RegisterForModEvent("SexLabOrgasm","OnModEvent_SexLabOrgasm")

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

Function OnModEvent_SexLabOrgasm(Form Whom, Int Enjoy, Int OCount)
{handler for sexlab orgasm events.}



	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
