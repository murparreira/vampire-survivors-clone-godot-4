class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum = 0

func add_item(item, weight: int):
	var path = item.get_path()
	var type = path.right(-path.rfind("/") - 1).left(-5)
	var item_found = false

	for i in range(items.size()):
		if items[i]["type"] == type:
			weight_sum -= items[i]["weight"]
			items[i]["weight"] = weight
			weight_sum += weight
			item_found = true
			break

	if not item_found:
		items.append({"item": item, "type": type, "weight": weight})
		weight_sum += weight

	print("Weight table updated: ", items)
	
func pick_item(exclude: Array = []):
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items:
			if item["item"] in exclude:
				continue
			adjusted_items.append(item)
			adjusted_weight_sum += item["weight"]

	var chosen_weight = randi_range(1, adjusted_weight_sum)
	var iteration_sum = 0
	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["item"]

func remove_item(item_to_remove):
	items = items.filter(func (item): return item["item"] != item_to_remove)
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]
