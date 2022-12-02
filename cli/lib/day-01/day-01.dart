import 'dart:io';

void main(){
  var file = File('lib/day-01/day-01.txt');
  var inputLines = file.readAsLinesSync();
  int currentElfCalories = 0;
  List<int> caloriesByElf = [];
  int numberOfElves = 0;

  // calculate each elf's calories
  for (var contents in inputLines) {
    if (contents == ''){
      numberOfElves++;
      caloriesByElf.add(currentElfCalories);
      currentElfCalories = 0;
      continue;
    }
    currentElfCalories += int.parse(contents);
  }

  // determine top 3
  caloriesByElf.sort((a, b) => b.compareTo(a));

  final int firstMostCalories = caloriesByElf[0];
  final int secondMostCalories = caloriesByElf[1];
  final int thirdMostCalories = caloriesByElf[2];
  final int topThreeTotal = firstMostCalories + secondMostCalories + thirdMostCalories;

  // output
  print("number of elves: $numberOfElves");

  print("The most calories carried by an elf is $firstMostCalories");
  print("Second most calories: $secondMostCalories");
  print("Third most calories: $thirdMostCalories");

  print("Top three total: $topThreeTotal");
}