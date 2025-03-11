Scriptname HTG:Character:Special:AttributeEffect extends ActiveMagicEffect

; GlobalVariable Property SpecialGlobal Mandatory Const Auto
; ActorValue Property SpecialValue Mandatory Const Auto
Perk Property SpecialPerk  Auto

Event OnEffectStart(ObjectReference akTarget, Actor akCaster, MagicEffect akBaseEffect, float afMagnitude, float afDuration)
    ; SpecialGlobal.SetValue(akCaster.GetValue(SpecialValue))
    akCaster.AddPerk(SpecialPerk)
EndEvent

Event OnEffectFinish(ObjectReference akTarget, Actor akCaster, MagicEffect akBaseEffect, float afMagnitude, float afDuration)
    ; SpecialGlobal.SetValue(0)
    akCaster.RemovePerk(SpecialPerk)
EndEvent