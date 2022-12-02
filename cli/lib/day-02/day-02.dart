import 'dart:io';

final Map<String, String> outcomeMapStrings = {
  "X": "LOSE",
  "Y": "DRAW",
  "Z": "WIN",
};

final Map<String, String> moveMapStrings = {
  "A": "ROCK",
  "B": "PAPER",
  "C": "SCISSORS",
  "X": "ROCK",
  "Y": "PAPER",
  "Z": "SCISSORS",
};

final Map<String, Map<String, String>> moveByOutcomeMap = {
  // how to use:
  // against rock, if you want to lose, you should choose scissors
  // against rock, if you want to win, you should choose paper
  "ROCK": {
    "LOSE": "SCISSORS",
    "DRAW": "ROCK",
    "WIN": "PAPER",
  },
  "PAPER": {
    "LOSE": "ROCK",
    "DRAW": "PAPER",
    "WIN": "SCISSORS",
  },
  "SCISSORS": {
    "LOSE": "PAPER",
    "DRAW": "SCISSORS",
    "WIN": "ROCK",
  }
};

final Map<String, Map<String, String>> outcomeByMoveMap = {
  // how to use:
  // against rock, if you choose scissors, you will lose.
  // against rock, if you choose paper, you will win.
  "ROCK": {
    "SCISSORS": "LOSE",
    "ROCK": "DRAW",
    "PAPER": "WIN",
  },
  "PAPER": {
    "ROCK": "LOSE",
    "PAPER": "DRAW",
    "SCISSORS": "WIN",
  },
  "SCISSORS": {
    "PAPER": "LOSE",
    "SCISSORS": "DRAW",
    "ROCK": "WIN",
  }
};

void printOutcome({ required String opponentMove, required String yourMove, required String outcome }){
  if (outcome == "LOSE"){
    print("+LOSE+ $opponentMove beats $yourMove.");
  }
  if (outcome == "WIN"){
    print("+++WIN+++ $yourMove beats $opponentMove.");
  }
  if (outcome == "DRAW"){
    print("++DRAW++ $opponentMove draws with $yourMove.");
  }
}

int getOutcomePoints(String outcome){
  switch(outcome){
    case "LOSE":
      return 0;
    case "DRAW":
      return 3;
    case "WIN":
      return 6;
    default:
      return 0;
  }
}

int getMovePoints(String move){
  switch(move){
    case "ROCK":
      return 1;
    case "PAPER":
      return 2;
    case "SCISSORS":
      return 3;
    default:
      return 0;
  }
}

int getPointsFromDesiredOutcome(String opponentMoveKey, String desiredOutcomeKey){
  final String opponentMoveString = moveMapStrings[opponentMoveKey] ?? "";
  final String desiredOutcome = outcomeMapStrings[desiredOutcomeKey] ?? "";
  final String chosenMove = moveByOutcomeMap[opponentMoveString]![desiredOutcome] ?? "";

  printOutcome(opponentMove: opponentMoveString, yourMove: chosenMove, outcome: desiredOutcome);

  return getMovePoints(chosenMove) + getOutcomePoints(desiredOutcome);
}

int getPointsFromMove(String opponentMoveKey, String yourMoveKey) {
  final String opponentMoveString = moveMapStrings[opponentMoveKey] ?? "";
  final String yourMoveString = moveMapStrings[yourMoveKey] ?? "";
  final String outcome = outcomeByMoveMap[opponentMoveString]![yourMoveString] ?? "";

  // printOutcome(opponentMove: opponentMoveString, yourMove: yourMoveString, outcome: outcome);

  return getMovePoints(yourMoveString) + getOutcomePoints(outcome);
}

void main(){
  var file = File('lib/day-02/day-02.txt');
  var inputLines = file.readAsLinesSync();
  int puzzle1TotalPoints = 0;
  int puzzle2TotalPoints = 0;

  // calculate each elf's calories
  for (var contents in inputLines) {
    final List<String> moves = contents.split(' ');
    final String opponentMove = moves[0];
    final String yourMoveOrOutcome = moves[1];

    puzzle1TotalPoints += getPointsFromMove(opponentMove, yourMoveOrOutcome);
    puzzle2TotalPoints += getPointsFromDesiredOutcome(opponentMove, yourMoveOrOutcome);
  }

  print("Puzzle 1 total points: $puzzle1TotalPoints");
  print("Puzzle 2 total points: $puzzle2TotalPoints");
}