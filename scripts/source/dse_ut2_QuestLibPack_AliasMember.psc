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
	Untamed.Util.Print(Me.GetDisplayName() + " is dead!")
	Untamed.Pack.RemoveMember(Me)
	Return
EndEvent

Event OnHit(ObjectReference Whom, Form What, Projectile Bullet, Bool IsPowerful, Bool IsSneak, Bool IsBash, Bool WasBlocked)
	Actor Me = self.GetActorReference()
	Untamed.Util.Print(Me.GetDisplayName() + " hit by " + Whom.GetDisplayName())
	Return
EndEvent

Event OnItemAdded(Form What, Int Count, ObjectReference Obj, ObjectReference From)
	Actor Me = self.GetActorReference()
	Untamed.Util.Print(Me.GetDisplayName() + " added " + What.GetName())
	Return
EndEvent

Event OnItemRemoved(Form What, Int Count, ObjectReference Obj, ObjectReference From)
	Actor Me = self.GetActorReference()
	Untamed.Util.Print(Me.GetDisplayName() + " removed " + What.GetName())
	Return
EndEvent

Event OnObjectEquipped(Form What, ObjectReference Obj)
	Actor Me = self.GetActorReference()
	Untamed.Util.Print(Me.GetDisplayName() + " equip " + What.GetName())
	Return
EndEvent

Event OnObjectUnequipped(Form What, ObjectReference Obj)
	Actor Me = self.GetActorReference()
	Untamed.Util.Print(Me.GetDisplayName() + " unequip " + What.GetName())
	Return
EndEvent

Event OnPackageStart(Package Pkg)
	Actor Me = self.GetActorReference()
	Untamed.Util.Print(Me.GetDisplayName() + " pkg start " + Pkg.GetFormID())
	Return
EndEvent

Event OnPackageChange(Package Pkg)
	Actor Me = self.GetActorReference()
	Untamed.Util.Print(Me.GetDisplayName() + " pkg change " + Pkg.GetFormID())
	Return
EndEvent

Event OnPackageEnd(Package Pkg)
	Actor Me = self.GetActorReference()
	Untamed.Util.Print(Me.GetDisplayName() + " pkg end " + Pkg.GetFormID())
	Return
EndEvent

Event OnPlayerFastTravelEnd(Float Time)
	Actor Me = self.GetActorReference()
	Untamed.Util.Print(Me.GetDisplayName() + " fast travel end.")
	Return
EndEvent
