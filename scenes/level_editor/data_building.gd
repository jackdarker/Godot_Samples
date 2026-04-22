class_name DataBuilding extends Resource

@export var label:String="name"
@export var editable:= true


# !! IMPORTANT !!
# NavigationRegion2D has to be setup so that the BAKED navmeshs vertex of neighboring rooms overlap
# therefore Agents.Radius is set to 0px
# Alternatively NavigationLinks could be used
