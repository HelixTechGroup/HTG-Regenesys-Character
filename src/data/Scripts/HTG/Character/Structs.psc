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
    int SpecialId = 100
    int SpecialAlertId = 101
    int SpecialNoPointsId = 102
EndStruct