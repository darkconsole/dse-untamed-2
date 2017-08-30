Scriptname dcc_ut2_QuestInterfaceXP extends SKI_WidgetBase

;/*
Float  Property Width = 200.0 Auto Hidden
Float  Property Height = 24.0 Auto Hidden
Int    Property PrimaryColor = 0xAA00AA Auto Hidden
Int    Property SecondaryColor = 0XFF0000 Auto Hidden
Int    Property FlashColor = -1 Auto Hidden
String Property FillDirection = "right" Auto Hidden
*/;

Float  Property Percent = 0.0 Auto Hidden

String Function GetMethod(String Method)
{get fqmn for the ui.}

	Return WidgetRoot + Method
EndFunction

String Function GetWidgetSource()
{specificy location of ui element}

	Return "dcc-untamed-2/meter.swf"
EndFunction

String Function GetWidgetType()
{not actually sure doesnt seem documented}

	Return "UT2XP"
EndFunction

Event OnWidgetReset()
{when a widget is turned on}

	parent.OnWidgetReset()
	UI.Invoke(HUD_MENU, GetMethod(".initCommit"))

	Int[] Colours = new Int[3]
	Colours[0] = 0xFF00FF
	Colours[1] = 0xFFAA00
	Colours[2] = -1

	self.VAnchor = "top"
	self.HAnchor = "left"
	self.Alpha   = 100.0
	self.X = 70.0
	self.Y = 684.0

	UI.InvokeFloat(HUD_MENU, GetMethod(".setWidth"), 290.0)
	UI.InvokeFloat(HUD_MENU, GetMethod(".setHeight"), 24.0)
	UI.InvokeString(HUD_MENU, GetMethod(".setFillDirection"), "right")
	UI.InvokeIntA(HUD_MENU, GetMethod(".setColors"), Colours)

	dcc_ut2_QuestController.Get().Util.UpdateExperienceBar()

	Return
EndEvent

Function SetPercent(Float Value)
{set the meter to a specific percentage}

	Float[] Args = new Float[2]
	Args[0] = Value / 100
	Args[1] = 0.0

	self.Percent = Value
	UI.InvokeFloatA(HUD_MENU, GetMethod(".setPercent"), Args)

	Return
EndFunction
