Scriptname dse_ut2_QuestLibPack_AliasMember extends ReferenceAlias

dse_ut2_QuestController Property Untamed Auto
Int Property CombatState = 0 Auto Hidden
Float Property CombatTime = 0 Auto Hidden

Event OnActivate(ObjectReference By)
	Actor Me = self.GetActorReference()
	;;Untamed.Util.Print(Me.GetDisplayName() + " activated!")
	;;Untamed.Util.FixAnimalActor(Me)
	Return
EndEvent

Event OnEnterBleedout()

	Actor Me = self.GetActorReference()
	Actor Source = Untamed.Player

	Bool SecondWind = FALSE
	Float XPMult = 0.0
	Float HealMult = 0.0

	;;;;;;;;

	Me.SetNoBleedoutRecovery(TRUE)

	If(Untamed.Config.GetBool(".PackSecondWind"))
		Source = Me
	EndIf

	If(Untamed.Player.HasPerk(Untamed.PerkSecondWind2))
		If(Untamed.Util.GetExperiencePercent(Source) >= 25.0)
			SecondWind = TRUE
			XPMult = 0.75
			HealMult = 0.5
		EndIf
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkSecondWind1))
		If(Untamed.Util.GetExperiencePercent(Source) >= 50.0)
			SecondWind = TRUE
			XPMult = 0.5
			HealMult = 0.25
		EndIf
	Endif

	;;;;;;;;

	If(SecondWind)
		Me.RestoreActorValue(Untamed.KeyActorValueHealth, (Me.GetActorValueMax(Untamed.KeyActorValueHealth) * HealMult))
		Untamed.Util.SetExperience(Source, (Untamed.Util.GetExperience(Source) * XPMult))
		Untamed.Util.Print(Me.GetDisplayName() + " gets second wind!")
		Untamed.XPBar.RegisterForSingleUpdate(0.05)
		Return
	EndIf

	Untamed.Util.Print(Me.GetDisplayName() + " has been downed!")
	Untamed.Pack.RemoveMember(Me)
	Me.Kill()

	Return
EndEvent

Event OnDying(Actor Killer)
	Actor Me = self.GetActorReference()

	Untamed.Util.Print(Me.GetDisplayName() + " is has died!")
	Return
EndEvent

Event OnDeath(Actor Killer)
	Actor Me = self.GetActorReference()

	Untamed.Util.Print(Me.GetDisplayName() + " is dead!")

	Untamed.XPBar.RegisterForSingleUpdate(0.05)
	Return
EndEvent

Event OnHit(ObjectReference Whom, Form What, Projectile Bullet, Bool IsPowerful, Bool IsSneak, Bool IsBash, Bool WasBlocked)
EndEvent

Event OnItemAdded(Form What, Int Count, ObjectReference Obj, ObjectReference From)
	Actor Me = self.GetActorReference()
	;;Untamed.Util.Print(Me.GetDisplayName() + " added " + What.GetName())
	Return
EndEvent

Event OnItemRemoved(Form What, Int Count, ObjectReference Obj, ObjectReference From)
	Actor Me = self.GetActorReference()
	;;Untamed.Util.Print(Me.GetDisplayName() + " removed " + What.GetName())
	Return
EndEvent

Event OnObjectEquipped(Form What, ObjectReference Obj)
	Actor Me = self.GetActorReference()
	;;Untamed.Util.Print(Me.GetDisplayName() + " equip " + What.GetName())
	Return
EndEvent

Event OnObjectUnequipped(Form What, ObjectReference Obj)
	Actor Me = self.GetActorReference()
	;;Untamed.Util.Print(Me.GetDisplayName() + " unequip " + What.GetName())
	Return
EndEvent

Event OnPackageStart(Package Pkg)
	Actor Me = self.GetActorReference()
	;; Untamed.Util.Print(Me.GetDisplayName() + " pkg start " + Untamed.Util.DecToHex(pkg.GetFormID()))
	Return
EndEvent

Event OnPackageChange(Package Pkg)
	Actor Me = self.GetActorReference()
	;; Untamed.Util.Print(Me.GetDisplayName() + " pkg change " + Untamed.Util.DecToHex(pkg.GetFormID()))
	Return
EndEvent

Event OnPackageEnd(Package Pkg)
	Actor Me = self.GetActorReference()
	;; Untamed.Util.Print(Me.GetDisplayName() + " pkg end " + Untamed.Util.DecToHex(pkg.GetFormID()))
	Return
EndEvent

Event OnPlayerFastTravelEnd(Float Time)
	Actor Me = self.GetActorReference()
	Untamed.Util.Print(Me.GetDisplayName() + " fast travel end")
	Return
EndEvent
