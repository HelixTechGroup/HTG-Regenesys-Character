Scriptname HTG:Character:Special:SpecialPerksManager extends ActiveMagicEffect

Group SPECIAL_Perks
Perk Property SpecialDisplayPerk Mandatory Const Auto
Perk Property SpecialStrengthPerk Mandatory Const Auto
Perk Property SpecialPerceptionPerk Mandatory Const Auto
Perk Property SpecialEndurancePerk Mandatory Const Auto
Perk Property SpecialCharismaPerk Mandatory Const Auto
Perk Property SpecialIntelligencePerk Mandatory Const Auto
Perk Property SpecialAgilityPerk Mandatory Const Auto
Perk Property SpecialLuckPerk Mandatory Const Auto
EndGroup

Event OnEffectStart(ObjectReference akTarget, Actor akCaster, MagicEffect akBaseEffect, float afMagnitude, float afDuration)
    akCaster.AddPerk(SpecialStrengthPerk)
    akCaster.AddPerk(SpecialPerceptionPerk)
    akCaster.AddPerk(SpecialEndurancePerk)
    akCaster.AddPerk(SpecialCharismaPerk)
    akCaster.AddPerk(SpecialIntelligencePerk)
    akCaster.AddPerk(SpecialAgilityPerk)
    akCaster.AddPerk(SpecialLuckPerk)
    akCaster.AddPerk(SpecialDisplayPerk)
EndEvent

Event OnEffectFinish(ObjectReference akTarget, Actor akCaster, MagicEffect akBaseEffect, float afMagnitude, float afDuration)
    akCaster.RemovePerk(SpecialStrengthPerk)
    akCaster.RemovePerk(SpecialPerceptionPerk)
    akCaster.RemovePerk(SpecialEndurancePerk)
    akCaster.RemovePerk(SpecialCharismaPerk)
    akCaster.RemovePerk(SpecialIntelligencePerk)
    akCaster.RemovePerk(SpecialAgilityPerk)
    akCaster.RemovePerk(SpecialLuckPerk)
    akCaster.RemovePerk(SpecialDisplayPerk)
EndEvent