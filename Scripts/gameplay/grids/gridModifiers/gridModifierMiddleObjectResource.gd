extends Resource
class_name gridMiddleModifierObject

func getNodeAtPath(parentNode:Node2D, path:NodePath):
	if path.is_empty():
		return null
	return parentNode.get_node(path)

func instanceGridObject():
	pass
