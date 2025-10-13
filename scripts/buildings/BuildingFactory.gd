#class_name BuildingFactory
#
#signal building_mode
#signal building_select
#signal building_placement
#
#var toPlace :BaseBuilding
#
#func place(){
	#place(toPlace);
#}
#
#
#var available_buildings = []
#
#func createLabo(pos: Vector2):
	#var labo = Laboratory.new()
	#labo.constructs(pos)
#
#func createToilets(pos: Vector2):
	#var toilets = Toilets.new()
	#toilets.constructs(pos)
#
#func createIceMine(pos: Vector2):
	#var ice_mine = IceMine.new()
	#ice_mine.constructs(pos)
