;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname dse_ut2_FragDiagGoAwayChoose Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE

dse_ut2_QuestController Untamed = dse_ut2_QuestController.Get()

ActorUtil.RemovePackageOverride(akSpeaker, Untamed.PackageFollow)
Untamed.Pack.RemoveMember(akSpeaker)
;; Untamed.Util.SetTamed(akSpeaker, FALSE)
akSpeaker.EvaluatePackage()

Return

;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE

dse_ut2_QuestController Untamed = dse_ut2_QuestController.Get()

akSpeaker.AddToFaction(Untamed.FactionPredator)
Untamed.Pack.RemoveMember(akSpeaker)
Untamed.Util.SetTamed(akSpeaker, FALSE)
ActorUtil.RemovePackageOverride(akSpeaker, Untamed.PackageFollow)
akSpeaker.EvaluatePackage()
akSpeaker.StartCombat(Untamed.Player)

Return

;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
