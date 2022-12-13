import 'dart:io';
import 'dart:convert';

bool doesOneRangeFullyContainOther(List<int> range1, List<int> range2){
  // range1: A-B, range2: X-Y; B is always greater or equal to A,
  // Y is always greater than or equal to X
  // if A <= X and B >= Y
  if (range1[0] <= range2[0] && range1[1] >= range2[1]){
    return true;
  }
  // if X <= A and Y >= B
  if (range2[0] <= range1[0] && range2[1] >= range1[1]){
    return true;
  }
  return false;
}

void main(){
  var file = File('lib/day-04/day-04.txt');
  var inputLines = file.readAsLinesSync();

  int fullyContainedPairsCount = 0;
  int intersectingPairsCount = 0;

  for (String ranges in inputLines) {
    List<String> rangeList = ranges.split(',');
    List<int> range1 = rangeList[0].split('-').map<int>((String bound) => int.parse(bound)).toList();
    List<int> range2 = rangeList[1].split('-').map<int>((String bound) => int.parse(bound)).toList();
    List<int> completeRange1 = List<int>.generate(range1[1] - range1[0] + 1, (int index) => index + range1[0]);
    List<int> completeRange2 = List<int>.generate(range2[1] - range2[0] + 1, (int index) => index + range2[0]);

    bool isRangeContained = doesOneRangeFullyContainOther(range1, range2);
    bool isRangeIntersecting = completeRange1.toSet().intersection(completeRange2.toSet()).toList().isNotEmpty;
    fullyContainedPairsCount += isRangeContained ? 1 : 0;
    intersectingPairsCount += isRangeIntersecting ? 1 : 0;

    print('range1: $range1');
    print('range2: $range2');
    print('completeRange1: $completeRange1');
    print('completeRange2: $completeRange2');
    print('------------- isRangeContained $isRangeContained');
    print('------------- isRangeIntersecting $isRangeIntersecting');
  }

  print("Number of range pairs where one range is fully contained: $fullyContainedPairsCount");
  print("Number of range pairs that intersect: $intersectingPairsCount");
}