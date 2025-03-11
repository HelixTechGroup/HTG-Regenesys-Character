Scriptname HTG:Character:Special:SpecialPlayerPerk extends HTG:PerkExt

Perk Property SpecialStrengthPerk Mandatory Const Auto
Perk Property SpecialPerceptionPerk Mandatory Const Auto
Perk Property SpecialEndurancePerk Mandatory Const Auto
Perk Property SpecialCharismaPerk Mandatory Const Auto
Perk Property SpecialIntelligencePerk Mandatory Const Auto
Perk Property SpecialAgilityPerk Mandatory Const Auto
Perk Property SpecialLuckPerk Mandatory Const Auto

Event OnEntryRun(int auiEntryID, ObjectReference akTarget, Actor akOwner)
    Parent.OnEntryRun(auiEntryID, akTarget, akOwner)
    
    ; akOwner.AddPerk(SpecialStrengthPerk)
    ; akOwner.AddPerk(SpecialPerceptionPerk)
    ; akOwner.AddPerk(SpecialEndurancePerk)
    ; akOwner.AddPerk(SpecialCharismaPerk)
    ; akOwner.AddPerk(SpecialIntelligencePerk)
    ; akOwner.AddPerk(SpecialAgilityPerk)
    ; akOwner.AddPerk(SpecialLuckPerk)
EndEvent