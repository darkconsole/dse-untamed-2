Scriptname dse_ut2_QuestInterfaceXP extends dse_ut2_QuestWidgetBase

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; progress bars have some margins around them so these define some offsets
;; to align the text label with them.

Int LabelOffsetX = 2
Int LabelOffsetY = 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OnUpdateWidget(Bool Flush=FALSE)

	If(self.Busy)
		Untamed.Util.PrintDebug("[OnUpdateWidget] Widget Busy")
		Return
	EndIf

	self.Busy = TRUE

	If(Flush)
		self.DynopulateItemsAsMeters(0)
		self.iWant.Destroy(self.TitleShadow)
		self.iWant.Destroy(self.Title)
		self.TitleShadow = 0
		self.Title = 0
	EndIf

	self.OnRenderWidget()

	self.Busy = FALSE

	Return
EndFunction

Function OnRenderWidget()

	Actor Who = Game.GetPlayer()
	Actor Member = NONE
	Int Iter = 0
	Int Oter = 0

	;; values for the positioning of the ui

	Int PosX
	Int PosY
	Float Scale
	Int BarW
	Int BarH
	Int Gap
	Int Rot
	Int FontSize

	;; values for the state of the ui

	Int PackSize = Untamed.Pack.GetMemberCount() + 1
	Float[] PackExp = Untamed.Pack.GetPackExperience()

	;;;;;;;;

	PosX = Untamed.Config.GetInt(".WidgetOffsetX")
	PosY = Untamed.Config.GetInt(".WidgetOffsetY")
	Scale = Untamed.Config.GetFloat(".WidgetScale")
	Gap = Untamed.Config.GetInt(".WidgetSpacing")
	BarW = (Untamed.Config.GetInt(".WidgetBarW") * Scale) As Int
	BarH = (Untamed.Config.GetInt(".WidgetBarH") * Scale) As Int
	FontSize = (Untamed.Config.GetInt(".WidgetFontSize") * Scale) As Int
	Rot = 0

	;;;;;;;;

	If(self.Items.Length != PackSize)
		self.DynopulateItemsAsMeters(PackSize)
		;; since we had to rescale this is an acceptable time to force a
		;; potential ugly redraw for positioning. they have to all be set
		;; the same before rotating or they will be positined wrong.

		Iter = 0
		Oter = 0
		While(Iter < self.Items.Length)
			self.ItemX[Iter] = PosX
			self.ItemY[Iter] = PosY + ((Gap + BarH) * Oter)

			self.iWant.SetPos(self.Labels[Iter], self.ItemX[Iter], self.ItemY[Iter])
			self.iWant.SetSize(self.Labels[Iter], FontSize, FontSize)
			self.iWant.SetVisible(self.Labels[Iter], 1)

			self.iWant.SetMeterFillDirection(self.Items[Iter], "left")
			self.iWant.SetMeterPercent(self.Items[Iter], 100)
			self.iWant.SetSize(self.Items[Iter], BarH, BarW)
			self.iWant.SetRotation(self.Items[Iter], Rot)
			self.iWant.SetPos(self.Items[Iter], self.ItemX[Iter], (self.ItemY[Iter]))
			self.iWant.SetVisible(self.Items[Iter], 1)

			Untamed.Util.PrintDebug("ModW " + BarW + " ModH " + BarH + " ItemX " + self.ItemX[Iter] + " ItemY " + self.ItemY[Iter] + " FontSize " + FontSize)
			Oter += 1
			Iter += 1
		EndWhile
	EndIf

	;;;;;;;;

	;; player's bar

	self.iWant.SetText(self.Labels[0], Untamed.Player.GetDisplayName())

	PosX = (self.ItemX[0] + LabelOffsetX) + (self.iWant.GetXSize(self.Labels[0]) / 2)
	PosY = (self.ItemY[0] + LabelOffsetY)

	self.iWant.SetPos(self.Labels[0], PosX, PosY)

	self.iWant.SetMeterRGB(self.Items[0], 158,96,26, 120,73,20, 226,157,78)
	self.iWant.SetMeterPercent(self.Items[0], (Math.Floor(Untamed.Util.GetExperiencePercent(Untamed.Player))))

	;; pack member bars.

	Iter = 0
	Oter = 1

	While(Iter < PackExp.Length)
		Member = Untamed.Pack.Members[Iter].GetActorReference()

		self.iWant.SetText(self.Labels[Oter], Member.GetDisplayName())

		PosX = (self.ItemX[Oter] + LabelOffsetX) + (self.iWant.GetXSize(self.Labels[Oter]) / 2)
		PosY = (self.ItemY[Oter] + LabelOffsetY)

		self.iWant.SetPos(self.Labels[Oter], PosX, PosY)

		self.iWant.SetMeterRGB(self.Items[Oter], 158,96,26, 120,73,20, 226,157,78)
		self.iWant.SetMeterPercent(self.Items[Oter], (Math.Floor(Untamed.Util.GetExperiencePercent(Member))))

		Oter += 1
		Iter += 1
	EndWhile

	Return
EndFunction

