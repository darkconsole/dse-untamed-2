Scriptname dse_ut2_QuestInterfacePerks extends dse_ut2_QuestWidgetBase

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int ScreenX = 1280
Int ScreenY = 720

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OnUpdateWidget(Bool Flush=FALSE)

	If(self.Busy)
		Untamed.Util.PrintDebug("[Perks:OnUpdateWidget] Widget Busy")
		Return
	EndIf

	self.Busy = TRUE

	If(Flush)
		;;
	EndIf

	self.OnRenderWidget()
	self.Busy = FALSE

	Return
EndFunction

Function OnRenderWidget()

	If(self.Items.Length == 0)
		Untamed.Util.PrintDebug("[Perks:OnRenderWidget] Init")
		self.Items = Utility.CreateIntArray(1)
	EndIf

	Int CX = ScreenX / 2
	Int CY = ScreenY / 2

	Untamed.Util.PrintDebug("[Perks:OnRenderWidget] Render")
	self.Items[0] = self.iWant.LoadWidget("widgets/dse-untamed-2/test.dds")

	self.iWant.SetPos(self.Items[0], CX, CY)
	self.iWant.SetVisible(self.Items[0], 1)

	Return
EndFunction

Float Function WidthOf(Int ID)

	Return self.iWant.GetXSize(ID)
EndFunction

