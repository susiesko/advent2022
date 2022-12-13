import 'dart:io';
import 'dart:convert';

void main(){
  var file = File('lib/day-06/day-06.txt');
  var input = file.readAsLinesSync()[0];

  int inputIdx = 0;
  int currentMarkerLength = 0;
  int markerStartIdx = 0;
  String startingCharacter = "";
  int markerStringLength = 0;
  int minMarkerLength = 4;
  minMarkerLength = 14;

  do {
    final inputWindow = input.substring(inputIdx, inputIdx + minMarkerLength);
    final markerString = input.substring(markerStartIdx, inputIdx + minMarkerLength);
    final inputWindowUniqueCharacters = inputWindow.split('').toSet().join("");
    // print("inputWindow: $inputWindow");

    if (inputWindow.length == inputWindowUniqueCharacters.length){
      // print("markerString: $markerString");
      markerStringLength = markerString.length;
      inputIdx += minMarkerLength;
      markerStartIdx = inputIdx;
      currentMarkerLength = minMarkerLength;
    } else {
      currentMarkerLength++;
      inputIdx++;
    }
  } while (inputIdx <= input.length - minMarkerLength && markerStringLength == 0);

  print("markerStringLength: $markerStringLength");
}