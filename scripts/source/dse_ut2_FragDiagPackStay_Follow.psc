;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname dse_ut2_FragDiagPackStay_Follow Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
dse_ut2_QuestController Untamed = dse_ut2_QuestController.Get()
Untamed.Util.ModExperience(Untamed.Player, 1)
Untamed.Util.ModExperience(akSpeaker, 1)
akSpeaker.RemoveFromFaction(Untamed.FactionPackStay)
akSpeaker.EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
