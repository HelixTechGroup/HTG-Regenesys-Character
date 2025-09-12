Scriptname HTG:Character:Structs

Struct ActorAttributeModInfo
    ActorValue Attribute
    FormList AttributeMods
    Perk AttributePerk
EndStruct

Struct ActorSpecialInfo
    ActorValue Strength
    ActorValue Perception
    ActorValue Endurance
    ActorValue Charisma
    ActorValue Intelligence
    ActorValue Agility
    ActorValue Luck
EndStruct

Struct CharacterStageIds
    Int SpecialId = 100
    Int SpecialAlertId = 101
    Int SpecialNoPointsId = 102
    Int SpecialDisplayUpdateId = 103
EndStruct