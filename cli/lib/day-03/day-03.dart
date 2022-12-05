import 'dart:io';
import 'dart:convert';

int getItemPriority (String item){
  int charcode = item.toLowerCase().codeUnitAt(0);
  int priority = charcode - 96;

  if (item.toLowerCase() != item){
    priority += 26;
  }

  return priority;
}

List<String> getCommonKeys(Map<String, int> compartment1Inventory, Map<String, int> compartment2Inventory){
  Iterable<String> keys1 = compartment1Inventory.keys;
  Iterable<String> keys2 = compartment2Inventory.keys;

  return keys1.toSet().intersection(keys2.toSet()).toList();
}

int calculateCommonItemPriorities (Map<String, int> compartment1Inventory, Map<String, int> compartment2Inventory){
  final intersection = getCommonKeys(compartment1Inventory, compartment2Inventory);

  return intersection.fold<int>(0, (int sum, String item) {
    int itemPriorityValue = getItemPriority(item);

    return sum + itemPriorityValue;
  });
}

Map<String, int> getCompartmentInventory (String rucksackContents) {
  Map<String, int> compartmentInventory = {};

  for (int i = 0; i < rucksackContents.length; i++){
    String item = rucksackContents[i];
    compartmentInventory[item] = (compartmentInventory[item] ?? 0) + 1;
  }

  return compartmentInventory;
}

String getGroupBadge (List<String> group){
  if (group.length != 3){
    throw Exception('group is wrong size; group size: ${group.length}');
  }

  print("GROUPPPPPPPPPPP");
  print("item: ${group.first}");

  return group.sublist(1, group.length).fold<List<String>>(group.first.split(''), (List<String> possibleBadges, String item) {
    List<String> itemContents = item.split('');
    print("possibleBadges: $possibleBadges");
    print("item: $item");
    return possibleBadges.toSet().intersection(itemContents.toSet()).toList();
  })[0];
}

void main(){
  var file = File('lib/day-03/day-03.txt');
  var inputLines = file.readAsLinesSync();
  List<String> badges = [];

  int puzzle1PrioritySum = 0;
  int puzzle2PrioritySum = 0;

  for (String rucksackContents in inputLines) {
    int rucksackSize = rucksackContents.length;
    int compartmentSize = rucksackSize ~/ 2;
    String compartment1Contents = rucksackContents.substring(0, compartmentSize);
    String compartment2Contents = rucksackContents.substring(compartmentSize, rucksackSize);
    final compartment1Inventory = getCompartmentInventory(compartment1Contents);
    final compartment2Inventory = getCompartmentInventory(compartment2Contents);

    puzzle1PrioritySum += calculateCommonItemPriorities(compartment1Inventory, compartment2Inventory);
  }

  for (int i = 0; i < inputLines.length; i += 3) {
    String groupBadge = getGroupBadge(inputLines.sublist(i, i + 3));
    print("groupBadge: $groupBadge");
    puzzle2PrioritySum += getItemPriority(groupBadge);
  }

  print("Puzzle 1 priority sum: $puzzle1PrioritySum");
  print("Puzzle 2 priority sum: $puzzle2PrioritySum");
}