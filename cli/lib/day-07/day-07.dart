import 'dart:io';
import 'dart:convert';
import 'dart:math';

class MyFile {
  final String name;
  final int size;
  MyFile(this.name, this.size);
}

class MyDirectory {
  final String directoryName;
  final MyDirectory? parentDirectory;
  Map<String, MyDirectory> childDirectories = {};
  List<MyFile> files = [];

  MyDirectory(this.directoryName, { this.parentDirectory });

  void addDirectory(String directoryName){
    childDirectories[directoryName] = childDirectories[directoryName] ?? MyDirectory(directoryName, parentDirectory: this);
  }

  void addFile(String fileName, int fileSize){
    files.add(MyFile(fileName, fileSize));
  }

  void printDirectory({int indentCount = 0, String indentString = "    "}){
    String indents = indentString * indentCount;
    print("$indents- DIR  $directoryName ($totalSize)");

    for (String directory in childDirectories.keys){
      childDirectories[directory]?.printDirectory(indentCount: indentCount + 1);
    }

    for (MyFile f in files) {
      print("$indents - file ${f.name} (${f.size})");
    }
  }

  int get totalSize {
    int directoryTotalSize = 0;

    for (MyFile f in files) {
      directoryTotalSize += f.size;
    }

    for (String directory in childDirectories.keys) {
      directoryTotalSize += childDirectories[directory]?.totalSize ?? 0;
    }

    return directoryTotalSize;
  }
}

void updateTotals(List<int> totals, MyDirectory? directory){
  if (directory == null){
    return;
  }

  totals.add(directory.totalSize);

  for (String dirName in directory.childDirectories.keys){
    updateTotals(totals, directory.childDirectories[dirName]);
  }
}

void main(){
  var file = File('lib/day-07/day-07.txt');
  var inputLines = file.readAsLinesSync();

  bool listingCommand = false;

  MyDirectory rootDirectory = MyDirectory("/");
  MyDirectory currentDirectory = rootDirectory;
  Map<String, MyDirectory> directoryMap = {};
  Map<String, int> directoryNameOccurrences = {};
  List<int> directoryTotalSizes = [];

  for (String line in inputLines) {
    // parse command ------------
    bool isCommand = line[0] == "\$";
    bool isDirectoryListing = line.substring(0, 3) == "dir";

    if (isDirectoryListing){
      final newDirectoryName = line.split(" ")[1];
      currentDirectory.addDirectory(newDirectoryName);
      directoryMap[newDirectoryName] = currentDirectory.childDirectories[newDirectoryName]!;
    }
    else if (isCommand){
      listingCommand = false;
      final String command = line.substring(2,4);

      // when command is cd, change to different directory and add to file system.
      if (command == "cd") {
        String directoryName = line.split(" ")[2];
        if (directoryName == "..") {
          currentDirectory = currentDirectory.parentDirectory ?? currentDirectory;
        }
        else if (directoryName != "/") {
          currentDirectory =
              currentDirectory.childDirectories[directoryName] ??
                  MyDirectory(directoryName, parentDirectory: currentDirectory);
        }
      }
      if (command == "ls"){
        listingCommand = true;
      }
    }
    else {
      List<String> fileData = line.split(" ");
      final fileSize = int.parse(fileData[0]);
      final fileName = fileData[1];
      currentDirectory.addFile(fileName, fileSize);
    }
  }
  // rootDirectory.printDirectory();

  updateTotals(directoryTotalSizes, rootDirectory);

  //
  final rootTotalSize = rootDirectory.totalSize;
  final totalSpace = 70000000;
  final neededSpace = 30000000;
  final availableSpace = totalSpace - rootTotalSize;
  final additionalSpaceNeeded = neededSpace - availableSpace;
  int totalSizesUpTo100k = 0;
  int sizeOfDirectoryToDelete = 0;

  for(int totalSize in directoryTotalSizes) {
    // print("directoryName:  $directoryName");
    // print("directory total size:  ${directoryMap[directoryName]?.totalSize}");
    totalSizesUpTo100k += (totalSize <= 100000) ? totalSize : 0;
    if (totalSize >= additionalSpaceNeeded){
      sizeOfDirectoryToDelete = sizeOfDirectoryToDelete == 0 ? totalSize : min(sizeOfDirectoryToDelete, totalSize);
    }
    // print("totalSizesGreaterThan100k:  $totalSizesUpTo100k");
  }


  print("totalSizesUpTo100k: $totalSizesUpTo100k");
  print("sizeOfDirectoryToDelete: $sizeOfDirectoryToDelete");
}