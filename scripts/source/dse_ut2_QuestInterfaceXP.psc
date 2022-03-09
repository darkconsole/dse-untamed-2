Scriptname dse_ut2_QuestInterfaceXP extends dse_ut2_QuestWidgetBase

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
	Int Iter = 0
	Int Oter = 0

	;; values for the positioning of the ui

	Int PosX
	Int PosY
	Float Scale
	Int ModW
	Int ModH
	Int Gap
	Int Rot
	Int FontSize

	;; values for the state of the ui

	Int PackSize = Untamed.Pack.GetMemberCount()
	Float[] PackExp = Untamed.Pack.GetPackExperience()

	;;;;;;;;

	PosX = Untamed.Config.GetFloat(".WidgetOffsetX") As Int
	PosY = Untamed.Config.GetFloat(".WidgetOffsetY") As Int
	Scale = Untamed.Config.GetFloat(".WidgetScale")
	Gap = Untamed.Config.GetFloat(".WidgetSpacing") As Int
	ModW = (Untamed.Config.GetInt(".WidgetBarW") * Scale) As Int
	ModH = (Untamed.Config.GetInt(".WidgetBarH") * Scale) As Int
	FontSize = (Untamed.Config.GetInt(".WidgetFontSize") * Scale) As Int
	Rot = 0

	;;;;;;;;

	If(self.Title)
		self.iWant.SetText(self.TitleShadow, Who.GetDisplayName())
		self.iWant.SetText(self.Title, Who.GetDisplayName())
	Else
		self.iWant.SetVisible(self.TitleShadow, 0)
		self.iWant.SetVisible(self.Title, 0)

		self.TitleShadow = self.iWant.loadText(Who.GetDisplayName(), size=FontSize)
		self.Title = self.iWant.loadText(Who.GetDisplayName(), size=FontSize)

		self.iWant.SetTransparency(self.TitleShadow, 50)
		self.iWant.SetRGB(self.TitleShadow, 0, 0, 0)
	EndIf

	self.iWant.SetPos(self.TitleShadow, (PosX + 1), (PosY + 1))
	self.iWant.SetPos(self.Title, PosX, PosY)

	self.iWant.SetVisible(self.TitleShadow)
	self.iWant.SetVisible(self.Title)

	;;;;;;;;

	If(self.Items.Length != PackExp.Length)
		self.DynopulateItemsAsMeters(PackExp.Length)
		;; since we had to rescale this is an acceptable time to force a
		;; potential ugly redraw for positioning. they have to all be set
		;; the same before rotating or they will be positined wrong.

		Iter = 0
		While(Iter < self.Items.Length)
			self.iWant.SetMeterPercent(self.Items[Iter], 100)
			self.iWant.SetZoom(self.Items[Iter], ModW, ModH)
			self.iWant.SetRotation(self.Items[Iter], Rot)
			self.iWant.SetPos(self.Items[Iter], PosX, (((Gap + ModH) * Iter) + PosY))
			self.iWant.SetVisible(self.Items[Iter], 1)

			Untamed.Util.PrintDebug("ModW " + ModW + " ModH " + ModH + " PosX " + PosX + " PosY " + (((Gap + ModH) * Iter) + PosY))
			Iter += 1
		EndWhile
	EndIf

	;;;;;;;;

	Iter = 0

	While(Iter < PackExp.Length)
		self.iWant.SetMeterRGB(self.Items[Iter], 158,96,26, 120,73,20, 226,157,78)
		self.iWant.SetMeterPercent(self.Items[Iter], 50)
		Iter += 1
	EndWhile

	Return
EndFunction

