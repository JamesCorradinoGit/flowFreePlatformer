extends Resource
class_name gridModifier

@export var cellToModify:int
@export_subgroup("Border Modifiers")
@export var leftModify:PackedScene
@export var rightModify:PackedScene
@export var topModify:PackedScene
@export var bottomModify:PackedScene
@export_subgroup("Interior Modify")
@export var middleCellModify:PackedScene
