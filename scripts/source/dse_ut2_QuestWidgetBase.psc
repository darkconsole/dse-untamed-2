Scriptname dse_ut2_QuestWidgetBase extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestController Property Untamed Auto

iWant_Widgets Property iWant Auto Hidden

Int[] Property ItemX Auto Hidden
Int[] Property ItemY Auto Hidden
Int[] Property Labels Auto Hidden
Int[] Property Items Auto Hidden

Int Property Title Auto Hidden
Int Property TitleShadow Auto Hidden
Bool Property Busy = FALSE Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnInit()

	self.ResetItemArrays()

	Untamed.Util.PrintDebug("[WidgetBase] OnInit")

	UnregisterForModEvent("iWantWidgetsReset")
	RegisterForModEvent("iWantWidgetsReset", "OnLocalEvent")

	UnregisterForModEvent("UT2.UI.Update")
	RegisterForModEvent("UT2.UI.Update","OnDataUpdate")

	Return
EndEvent

Event OnUpdate()

	self.OnUpdateWidget()
	Return
EndEvent

Event OnLocalEvent(String EvName, String ArgStr, Float ArgInt, Form From)

	If(EvName == "iWantWidgetsReset")
		Untamed.Util.PrintDebug("[WidgetBase] iWantWidgetsReset")
		Utility.Wait(0.25)
		self.OnLocalReset(ArgStr, ArgInt, From)
	EndIf

	Return
EndEvent

Event OnLocalReset(String ArgStr, Float ArgInt, Form From)

	self.iWant = From as iWant_Widgets
	self.ResetItemArrays()
	self.OnUpdateWidget(TRUE)
	Return
EndEvent

Function OnUpdateWidget(Bool Flush=FALSE)
{this method should be the primary means of asking the widget to update, either
by timer triggers or manual calls.}

	If(self.Busy)
		Return
	EndIf

	self.Busy = TRUE

	self.OnRenderWidget()

	self.Busy = FALSE
	Return
EndFunction

Function ResetItemArrays()

	self.ItemX = Utility.CreateIntArray(0)
	self.ItemY = Utility.CreateIntArray(0)
	self.Labels = Utility.CreateIntArray(0)
	self.Items = Utility.CreateIntArray(0)
	self.Title = 0
	self.TitleShadow = 0

	Return
EndFunction

Function DynopulateItemsAsMeters(Int Needed)

	Int[] NewX
	Int[] NewY
	Int[] LabelsNew
	Int[] ItemsNew
	Int Iter

	;; we need more than we have so add additional meters.

	If(Needed > self.Items.Length)
		Untamed.Util.PrintDebug("[WidgetBase] DynopulateItemsAsMeters Expand To " + Needed)
		NewX = Utility.CreateIntArray(Needed)
		NewY = Utility.CreateIntArray(Needed)
		ItemsNew = Utility.CreateIntArray(Needed)
		LabelsNew = Utility.CreateIntArray(Needed)
		Iter = 0

		;; retain existing meters.

		While(Iter < self.Items.Length)
			NewX[Iter] = self.ItemX[Iter]
			NewY[Iter] = self.ItemY[Iter]
			ItemsNew[Iter] = self.Items[Iter]
			LabelsNew[Iter] = self.Labels[Iter]
			Iter += 1
		EndWhile

		;; initialize addtional meters.

		While(Iter < ItemsNew.Length)
			NewX[Iter] = 0
			NewY[Iter] = 0
			ItemsNew[Iter] = self.iWant.loadMeter()
			LabelsNew[Iter] = self.iWant.loadText("")

			Iter += 1
		EndWhile

		self.ItemX = NewX
		self.ItemY = NewY
		self.Items = ItemsNew
		self.Labels = LabelsNew
		Return
	EndIf

	;; we do not need as many meters as we used to.

	If(Needed < self.Items.Length)
		Untamed.Util.PrintDebug("[WidgetBase] DynopulateItemsAsMeters Shrink To " + Needed)
		NewX = Utility.CreateIntArray(Needed)
		NewY = Utility.CreateIntArray(Needed)
		LabelsNew = Utility.CreateIntArray(Needed)
		ItemsNew = Utility.CreateIntArray(Needed)
		Iter = 0

		;; retain only as many as we need.

		While(Iter < ItemsNew.Length)
			NewX[Iter] = self.ItemX[Iter]
			NewY[Iter] = self.ItemY[Iter]
			ItemsNew[Iter] = self.Items[Iter]
			LabelsNew[Iter] = self.Labels[Iter]
			Iter += 1
		EndWhile

		;; then destroy the remainders.

		While(Iter < self.Items.Length)
			self.iWant.Destroy(self.Items[Iter])
			self.iWant.Destroy(self.Labels[Iter])
			Iter += 1
		EndWhile

		self.ItemX = NewX
		self.ItemY = NewY
		self.Items = ItemsNew
		self.Labels = LabelsNew
		Return
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; below are things that should be moved to scripts extending ;;
;; this one with generic prototypes added here for templates. ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OnRenderWidget()

	Return
EndFunction

