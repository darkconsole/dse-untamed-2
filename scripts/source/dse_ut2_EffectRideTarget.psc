ScriptName dse_ut2_EffectRideTarget extends ActiveMagicEffect

Event OnEffectStart(Actor Who, Actor Source)
	dse_ut2_QuestController.Get().Ride.Mount(Who)
	Return
EndEvent
