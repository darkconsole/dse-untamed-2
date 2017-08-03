Scriptname dcc_ut2_QuestConfig extends SKI_ConfigBase Conditional

dcc_ut2_QuestController Property Untamed Auto

Bool Property HasNIO = FALSE Auto
Bool Property HasUIE = FALSE Auto
Bool Property HasSL = FALSE Auto
Bool Property HasPUtil = FALSE Auto
Bool Property HasBWA = FALSE Auto
Bool Property HasSLA = FALSE Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; leveling settings.

Float Property OptExperienceMax = 100.0 Auto Hidden
Float Property OptPerkExperiencedAdd = 20.0 Auto Hidden

Float Property OptEncounterXP = 5.0 Auto Hidden
Float Property OptFondleXP = 2.5 Auto Hidden
Float Property OptPlayXP = 2.5 Auto Hidden

Float Property OptEncounterHumanoidMult = 0.5 Auto Hidden

;; pack leader settings.

Int   Property OptPerkPackLeader0 = 1 Auto Hidden
Int   Property OptPerkPackLeader1 = 3 Auto Hidden
Int   Property OptPerkPackLeader2 = 6 Auto Hidden
Int   Property OptPerkPackLeader3 = 12 Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; general mod options

Bool Property Enabled = TRUE Auto Hidden

Bool Property OptIncludeActorTypeCreature = FALSE Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dependency detection.

Bool Function IsInstalledNiOverride(Bool Popup=TRUE)
{make sure NiOverride is installed and active.}

	If(SKSE.GetPluginVersion("NiOverride") == -1)
		If(Popup)
			Debug.MessageBox("NiOverride not installed. Install it by installing RaceMenu or by installing it standalone from the Nexus.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledUIExtensions(Bool Popup=TRUE)
{make sure UIExtensions is installed and active.}

	If(Game.GetModByName("UIExtensions.esp") == 255)
		If(Popup)
			Debug.MessageBox("UIExtensions not installed. Install it from the Nexus.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledSexLab(Bool Popup=TRUE)
{make sure SexLab is installed and active.}

	If(Game.GetModByName("SexLab.esm") == 255)
		If(Popup)
			Debug.MessageBox("SexLab not installed. Install it from LoversLab.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledPapyrusUtil(Bool Popup=TRUE)
{make sure papyrus util is a version we need. if we test this after sexlab we
can basically promise it will be there. we need to make sure that shlongs of
skyrim though didn't fuck it up again with an older version, that will break
the use of AdjustFloatValue and the like.}

	If(PapyrusUtil.GetVersion() < 31)
		If(Popup)
			Debug.MessageBox("Your PapyrusUtil is too old or has been overwritten by something like SOS. Install PapyrusUtil 3.1 from LoversLab and make sure it dominates the load order.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledBlushWhenAroused(Bool Popup=TRUE)
{make sure blush when aroused is installed and active.}

	If(Game.GetModByName("Blush When Aroused.esp") == 255)
		If(Popup)
			Debug.MessageBox("Blush When Aroused is not installed. Install it from LoversLab.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledSexLabAroused(Bool Popup=TRUE)
{make sure sexlab aroused is installed and active.}

	If(Game.GetModByName("SexLabAroused.esm") == 255)
		If(Popup)
			Debug.MessageBox("SexLab Aroused is not installed. Install it, preferably Redux, from LoversLab.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; MCM stuff

Int Function GetVersion()
{mcm's version request}

	Return 1
EndFunction

Event OnGameReload()
{things to do when the game is loaded from disk.}

	parent.OnGameReload()

	;; hard requirements
	self.HasNIO = self.IsInstalledNiOverride(TRUE)
	self.HasUIE = self.IsInstalledUIExtensions(TRUE)
	self.HasSL = self.IsInstalledSexLab(TRUE)
	self.HasPUtil = self.IsInstalledPapyrusUtil(TRUE)

	;; soft requirements
	self.HasSLA = self.IsInstalledSexLabAroused(FALSE)
	self.HasBWA = self.IsInstalledBlushWhenAroused(FALSE)

	Return
EndEvent

Event OnConfigInit()
{things to do when the menu initalises (is opening)}

	self.Pages = new String[2]
	
	self.Pages[0] = "Splash"
	self.Pages[1] = "General"

	Return
EndEvent

Event OnConfigOpen()
{things to do when the menu actually opens.}

	self.OnConfigInit()
	Return
EndEvent

Event OnConfigClose()
{things to do when the menu closes.}

	Return
EndEvent

Event OnPageReset(String Page)
{when a different tab is selected in the menu.}

	self.UnloadCustomContent()

	If(Page == "Splash")
		;;
	ElseIf(Page == "General")
		;;
	EndIf

	Return
EndEvent

