Scriptname dse_ut2_QuestInterfaceXP extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestController Property Untamed Auto

Int[] Property Bars Auto Hidden
Int[] Property Names Auto Hidden
iWant_Widgets Property iWant Auto Hidden
Bool Property Busy = FALSE Auto Hidden

Int SW = 1280 ;; screen width (ce fixed hud size)
Int SH = 720  ;; screen height (ce fixed hud size)
Int BW = 150  ;; bar width
Int BH = 20   ;; bar height
Int BS = 1    ;; bar spacing
Int FH = 12   ;; font height

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnInit()

	Untamed.Util.PrintDebug("[Interface:OnInit] booting xp ui")
	self.iWant = Game.GetFormFromFile(0x800, "iWant Widgets.esl") as iWant_Widgets

	self.BuildUI()
	self.UpdateUI()

	Return
EndEvent

Event OnUpdate()

	self.UpdateUI()
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function BuildUI(Bool Force=FALSE)

	Int Needed = 1
	Int Iter = 0
	Actor[] Members = Untamed.Pack.GetMemberList()

	If(self.Busy && !Force)
		Untamed.Util.PrintDebug("[Interface:BuildUI] skipped, busy atm")
		Return
	EndIf

	self.Busy = TRUE

	If(self.Bars.Length > 0)
		self.DestroyUI()
	EndIf

	;;;;;;;;

	Needed += Untamed.Pack.GetMemberCount()
	self.Bars = Utility.CreateIntArray(Needed)
	self.Names = Utility.CreateIntArray(Needed)

	Untamed.Util.PrintDebug("[Interface:BuildUI] building " + self.Bars.Length + " bars")

	While(Iter < self.Bars.Length)
		self.Bars[Iter] = self.iWant.LoadMeter()
		self.SetBarVisible(self.Bars[Iter], FALSE)
		self.SetBarPercent(self.Bars[Iter], 100.0)
		self.SetBarColour(self.Bars[Iter], 158, 96, 26)
		self.SetBarSize(self.Bars[Iter])
		self.SetBarPosition(self.Bars[Iter], Iter)
		self.SetBarDir(self.Bars[Iter])
		self.SetBarVisible(self.Bars[Iter])

		If(Iter == 0)
			self.Names[Iter] = self.iWant.LoadText(Untamed.Player.GetDisplayName(), size=FH)
		Else
			self.Names[Iter] = self.iWant.LoadText(Members[Iter - 1].GetDisplayName(), size=FH)
		EndIf

		self.SetNamePosition(self.Names[Iter], Iter)
		self.SetBarVisible(self.Names[Iter])

		Iter += 1
	EndWhile

	self.Busy = FALSE

	Return
EndFunction

Function DestroyUI()

	Int Iter = self.Bars.Length

	Untamed.Util.PrintDebug("[Interface:DestroyUI] taking ui to bits")

	While(Iter > 0)
		Iter -= 1

		self.iWant.Destroy(self.Bars[Iter])
		self.iWant.Destroy(self.Names[Iter])
	EndWhile

	self.Bars = Utility.CreateIntArray(0)
	self.Names = Utility.CreateIntArray(0)

	Return
EndFunction

Function UpdateUI()

	Int Iter = 0
	Actor[] Members = Untamed.Pack.GetMemberList()
	Int UXP = 0

	;;;;;;;;

	If(self.Busy)
		Untamed.Util.PrintDebug("[Interface:UpdateUI] skipped, busy atm")
		Return
	EndIf

	self.Busy = TRUE

	If(!self.IsRunning())
		self.Busy = FALSE
		Untamed.Util.PrintDebug("[Interface:UpdateUI] skipped, ui disabled atm")
		Return
	EndIf

	;;;;;;;;

	Untamed.Util.PrintDebug("[Interface:UpdateUI] updating ui")

	If((Members.Length + 1) != self.Bars.Length)
		self.BuildUI(TRUE)
	EndIf

	;;;;;;;;

	While(Iter < self.Bars.Length)

		If(Iter == 0)
			UXP = Untamed.Util.GetExperiencePercent(Untamed.Player) As Int
			self.SetBarPercent(self.Bars[Iter], UXP)
			self.SetNameText(self.Names[Iter], (Untamed.Player.GetDisplayName() + " (" + UXP + ")"))
			self.SetNamePosition(self.Names[Iter], Iter)
		Else
			UXP = Untamed.Util.GetExperiencePercent(Members[Iter]) As Int
			self.SetBarPercent(self.Bars[Iter], Untamed.Util.GetExperiencePercent(Members[Iter - 1]))
			self.SetNameText(self.Names[Iter], (Members[Iter].GetDisplayName() + " (" + UXP + ")"))
			self.SetNamePosition(self.Names[Iter], Iter)
		EndIf

		Iter += 1
	EndWhile

	;;;;;;;;

	self.Busy = FALSE

	Return
EndFunction

Function SetBarSize(Int ID)

	;;Untamed.Util.PrintDebug("[Interface:SetBarSize] " + ID + " " + BW + " " + BH)
	self.iWant.SetSize(ID, BH, BW)

	Return
EndFunction

Function SetBarPosition(Int ID, Int Offset)

	Int BX = ((SW - BW) + 16)
	Int BY = (BH / 2) + ((BH + BS) * Offset)

	;;Untamed.Util.PrintDebug("[Interface:SetBarPosition] " + ID + " " + BX + " " + BY)
	self.iWant.SetPos(ID, BX, BY)

	Return
EndFunction

Function SetNamePosition(Int ID, Int Offset)

	Int BX = ((SW - BW) - 4) - (self.iWant.GetXSize(ID) / 2)
	Int BY = (BH / 2) + ((BH + BS) * Offset)

	;;Untamed.Util.PrintDebug("[Interface:SetNamePosition] " + ID + " " + BX + " " + BY)
	self.iWant.SetPos(ID, BX, BY)

	Return
EndFunction

Function SetBarVisible(Int ID, Bool Yes=TRUE)

	;;Untamed.Util.PrintDebug("[Interface:SetBarVisible] " + ID + " " + (Yes as Int))
	self.iWant.SetVisible(ID, (Yes as Int))

	Return
EndFunction

Function SetBarPercent(Int ID, Float Val)

	;;Untamed.Util.PrintDebug("[Interface:SetBarPercent] " + ID + " " + Val)
	self.iWant.SetMeterPercent(ID, Val as Int)

	Return
EndFunction

Function SetBarColour(Int ID, Int R, Int G, Int B)

	self.iWant.SetMeterRGB(ID, R,G,B, (R - 10),(G - 10),(B - 10), (R - 20),(G - 20),(B - 20) )

	Return
EndFunction

Function SetBarDir(Int ID, String Dir="right")

	self.iWant.SetMeterFillDirection(ID, Dir)

	Return
EndFunction

Function SetNameText(Int ID, String Msg)

	self.iWant.SetText(ID, Msg)

	Return
EndFunction
