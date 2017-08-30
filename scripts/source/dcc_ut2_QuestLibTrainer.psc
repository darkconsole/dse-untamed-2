Scriptname dcc_ut2_QuestLibTrainer extends Quest

dcc_ut2_QuestController Property Untamed Auto
ReferenceAlias Property Trainer Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnUpdate()
{used to delete the trainer after a while.}

	Actor Who = self.Trainer.GetActorRef()

	If(Who == NONE)
		;; make sure its really empty and not just pointing at a deleted
		;; space that may be reused by the game then bail.
		self.Trainer.Clear()
		Return
	EndIf

	self.DeleteTrainer()
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function SpawnTrainer()
{place the trainer actor in the world.}

	Actor Old = self.Trainer.GetActorRef()
	Actor Who
	ObjectReference Here

	If(Old != NONE)
		self.UnregisterForUpdate()
		self.DeleteTrainer()
	EndIf

	;; try and place the actor underground.
	Here = Untamed.Player.PlaceAtMe(Untamed.StaticX)
	Here.SetPosition(Here.GetPositionX(),Here.GetPositionY(),(Here.GetPositionZ() - 1000))

	Who = Here.PlaceAtMe(Untamed.ActorTrainer,1,FALSE,TRUE) as Actor
	Who.SetVehicle(Here)
	Who.MoveTo(Here)

	;; enable them.
	self.Trainer.ForceRefTo(Who)
	Who.Enable(FALSE)

	;; wait for it.
	While(!Who.Is3dLoaded())
		Utility.Wait(0.1)
		Untamed.Util.PrintDebug("Waiting on Trainer 3D")
	EndWhile

	;; fade them in.
	Untamed.VfxTeleportIn.Play(Who,4.0,Untamed.Player)

	;; move them up and dismount them.
	Here.SetPosition(Here.GetPositionX(),Here.GetPositionY(),(Here.GetPositionZ() + 1000))
	Who.MoveTo(Here)
	Who.SetVehicle(NONE)
	Here.Delete()

	Untamed.Util.PrintDebug("Trainer Spawned")
	self.RegisterForSingleUpdate(30)
	Return
EndFunction

Function DeleteTrainer()
{remove the trainer actor from the world.}

	Actor Who = self.Trainer.GetActorRef()

	;; teleport out fx
	;; Utility.Wait(2)

	Who.Disable()
	self.Trainer.Clear()

	Who.Delete()
	Untamed.Util.PrintDebug("Trainer Despawned")
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function UpdateThickHide(Actor Who)
{update the thick hide perk.}

	Float Value = (Untamed.Util.GetExperience(Who) * Untamed.Config.OptPerkFeatThickHideMult)

	Untamed.PerkFeatThickHide.GetNthEntrySpell(0).SetNthEffectMagnitude(0,Value)
	Untamed.Util.ReapplyPerk(Who,Untamed.PerkFeatThickHide)
	Return
EndFunction

Function UpdateResistantHide(Actor Who)
{update the resistant hide perk.}
	
	Float Value = (Untamed.Util.GetExperience(Who) * Untamed.Config.OptPerkFeatResistantHideMult)

	Untamed.PerkFeatResistantHide.GetNthEntrySpell(0).SetNthEffectMagnitude(0,Value)
	Untamed.Util.ReapplyPerk(Who,Untamed.PerkFeatResistantHide)
	Return
EndFunction
