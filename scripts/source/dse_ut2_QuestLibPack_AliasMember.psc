Scriptname dse_ut2_QuestLibPack_AliasMember extends ReferenceAlias

dse_ut2_QuestController Property Untamed Auto

Event OnActivate(ObjectReference By)

	Actor Me = self.GetActorReference()

	Untamed.Util.Print(Me.GetDisplayName() + " activated!")
	Untamed.Util.FixAnimalActor(Me)

	Return
EndEvent

Event OnEnterBleedout()

	Actor Me = self.GetActorReference()

	Untamed.Util.Print(Me.GetDisplayName() + " is down!")

	Return
EndEvent

Event OnDying(Actor Killer)

	Actor Me = self.GetActorReference()

	Untamed.Util.Print(Me.GetDisplayName() + " is dying!")

	Return
EndEvent
