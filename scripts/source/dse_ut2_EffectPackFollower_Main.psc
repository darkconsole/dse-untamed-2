Scriptname dse_ut2_EffectPackFollower_Main extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto
Actor Property Me Auto Hidden

Event OnEffectStart(Actor Who, Actor From)
	self.Me = Who

	Untamed.Util.Print("[PackFollower:OnEffectStart] " + self.Me)
	Untamed.Util.FixAnimalActor(self.Me)
	self.RegisterForSingleUpdate(1.2)

	Return
EndEvent

Event OnUpdate()

	Untamed.Util.Print("[PackFollower:OnUpdate] " + self.Me)

	If(Untamed.Menu.HasEFF)
		Untamed.Util.AddToEFF(self.Me)
	EndIf

	Return
EndEvent

