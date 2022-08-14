import 'package:usfmtoolsdart/src/utils/string_extensions.dart';

class ADDEndMarker extends Marker {
  @override
  String get identifier => "add*";
}

class ADDMarker extends Marker {
  @override
  String get identifier => "add";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class BDEndMarker extends Marker {
  @override
  String get identifier => "bd*";
}

class BDITEndMarker extends Marker {
  @override
  String get identifier => "bdit*";
}

class BDITMarker extends Marker {
  @override
  String get identifier => "bdit";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class BDMarker extends Marker {
  /// Text that is bolded
  late String text;

  @override
  String get identifier => "bd";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class BKEndMarker extends Marker {
  @override
  String get identifier => "bk*";
}

class BKMarker extends Marker {
  /// Text that is bolded
  late String bookTitle;

  @override
  String get identifier => "bk";

  @override
  String preProcess(String input) {
    bookTitle = input.trim();
    return "";
  }
}

/// Marker for a blank line
class BMarker extends Marker {
  @override
  String get identifier => "b";
}

class CAEndMarker extends Marker {
  @override
  String get identifier => "ca*";
}

class CAMarker extends Marker {
  late String altChapterNumber;

  @override
  String get identifier => "ca";

  @override
  String preProcess(String input) {
    altChapterNumber = input.trim();
    return "";
  }
}

class CDMarker extends Marker {
  late String description;

  @override
  String get identifier => "cd";

  @override
  String preProcess(String input) {
    description = input.trim();
    return "";
  }
}

class CLMarker extends Marker {
  late String label;

  @override
  String get identifier => "cl";

  @override
  String preProcess(String input) {
    label = input.trim();
    return "";
  }
}

class CLSMarker extends Marker {
  @override
  String get identifier => "cls";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class CMarker extends Marker {
  static final RegExp _regex = RegExp(" *(\\d*) *(.*)");
  int number = 0;

  String get publishedChapterMarker {
    var childCharacterMarker = getChildMarkers<CPMarker>();
    if (childCharacterMarker.isNotEmpty) {
      return childCharacterMarker[0].publishedChapterMarker;
    } else {
      return number.toString();
    }
  }

  String get customChapterLabel {
    var childChapLabelMarker = getChildMarkers();
    if (childChapLabelMarker.isNotEmpty) {
      return childChapLabelMarker[0].label;
    } else {
      return publishedChapterMarker;
    }
  }

  @override
  String get identifier => "c";

  @override
  String preProcess(String input) {
    var match = _regex.firstMatch(input);
    if (match != null) {
      if (match.group(1).isNullOrWhiteSpace()) {
        number = 0;
      } else {
        number = int.parse(match.group(1)!);
      }
      if (match.group(2).isNullOrWhiteSpace()) {
        return "";
      }
      return match.group(2)!.trimRight();
    }
    return "";
  }

  @override
  List<Type> get allowedContents {
    var result = [
      MMarker,
      MSMarker,
      SMarker,
      BMarker,
      DMarker,
      VMarker,
      PMarker,
      PCMarker,
      CDMarker,
      CPMarker,
      DMarker,
      CLMarker,
      QMarker,
      QSMarker,
      QSEndMarker,
      QAMarker,
      QMarker,
      QSMarker,
      QSEndMarker,
      QAMarker,
      QMarker,
      NBMarker,
      RMarker,
      LIMarker,
      TableBlock,
      MMarker,
      MIMarker,
      PIMarker,
      CAMarker,
      CAEndMarker,
      SPMarker,
      TextBlock,
      REMMarker,
      DMarker,
      VAMarker,
      VAEndMarker,
      FMarker,
      FEndMarker,
    ];
    return result;
  }
}

class CPMarker extends Marker {
  late String publishedChapterMarker;

  @override
  String get identifier => "cp";

  @override
  String preProcess(String input) {
    publishedChapterMarker = input.trim();
    return "";
  }
}

class DMarker extends Marker {
  late String description;

  @override
  String get identifier => "d";

  @override
  String preProcess(String input) {
    description = input.trim();
    return "";
  }

  @override
  List<Type> get allowedContents {
    var results = [FMarker, FEndMarker, ITMarker, ITEndMarker, TextBlock];
    return results;
  }
}

class EMEndMarker extends Marker {
  @override
  String get identifier => "em*";
}

class EMMarker extends Marker {
  @override
  String get identifier => "em";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class FEndMarker extends Marker {
  @override
  String get identifier => "f*";
}

class FIGEndMarker extends Marker {
  @override
  String get identifier => "fig*";
}

class FIGMarker extends Marker {
  late String caption;
  late String description;
  late String width;
  late String location;
  late String copyright;
  late String reference;
  late String filePath;

  @override
  String get identifier => "fig";

  @override
  String preProcess(String input) {
    input = input.trim();

    List<String> wordEntry = input.split('|');
    if (wordEntry.isNotEmpty) {
      description = wordEntry[0].trim();
    }
    if (wordEntry.length > 1) {
      filePath = wordEntry[1].trim();
    }
    if (wordEntry.length > 2) {
      width = wordEntry[2].trim();
    }
    if (wordEntry.length > 3) {
      location = wordEntry[3].trim();
    }
    if (wordEntry.length > 4) {
      copyright = wordEntry[4].trim();
    }
    if (wordEntry.length > 5) {
      caption = wordEntry[5].trim();
    }
    if (wordEntry.length > 6) {
      reference = wordEntry[6].trim();
    }

    List<String> contentArr = input.split('|');
    if (contentArr.isNotEmpty && contentArr.length <= 2) {
      caption = contentArr[0].trim();

      List<String> attributes = contentArr[1].split('"');
      for (int i = 0; i < attributes.length; i++) {
        if (attributes[i].replaceAll(" ", "").contains("alt=")) {
          description = attributes[i + 1].trim();
        }
        if (attributes[i].replaceAll(" ", "").contains("src=")) {
          filePath = attributes[i + 1].trim();
        }
        if (attributes[i].replaceAll(" ", "").contains("size=")) {
          width = attributes[i + 1].trim();
        }
        if (attributes[i].replaceAll(" ", "").contains("loc=")) {
          location = attributes[i + 1].trim();
        }
        if (attributes[i].replaceAll(" ", "").contains("copy=")) {
          copyright = attributes[i + 1].trim();
        }
        if (attributes[i].replaceAll(" ", "").contains("ref=")) {
          reference = attributes[i + 1].trim();
        }
      }
    }

    return "";
  }
}

class FKMarker extends Marker {
  @override
  String get identifier => "fk";
  late String footNoteKeyword;

  @override
  String preProcess(String input) {
    footNoteKeyword = input.trim();
    return "";
  }
}

class FMarker extends Marker {
  @override
  String get identifier => "f";

  late String footNoteCaller;

  @override
  String preProcess(String input) {
    footNoteCaller = input.trim();
    return "";
  }

  @override
  List<Type> get allowedContents {
    var results = [
      FRMarker,
      FREndMarker,
      FKMarker,
      FTMarker,
      FVMarker,
      FPMarker,
      FQAMarker,
      FQAEndMarker,
      FQMarker,
      FQEndMarker,
      TLMarker,
      TLEndMarker,
      WMarker,
      WEndMarker,
      TextBlock,
      ITMarker,
      ITEndMarker,
      SCMarker,
      SCEndMarker,
      SUPMarker,
      SUPEndMarker,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
    ];
    return results;
  }
}

class FPMarker extends Marker {
  @override
  String get identifier => "fp";

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class FQAEndMarker extends Marker {
  @override
  String get identifier => "fqa*";
}

class FQAMarker extends Marker {
  @override
  String get identifier => "fqa";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      TLMarker,
      TLEndMarker,
      WMarker,
      WEndMarker,
    ];
    return result;
  }
}

class FQEndMarker extends Marker {
  @override
  String get identifier => "fq*";
}

class FQMarker extends Marker {
  @override
  String get identifier => "fq";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      TLMarker,
      TLEndMarker,
      WMarker,
      WEndMarker,
    ];
    return result;
  }
}

class FREndMarker extends Marker {
  @override
  String get identifier => "fr*";
}

class FRMarker extends Marker {
  @override
  String get identifier => "f*";
  late String verseReference;

  @override
  String preProcess(String input) {
    verseReference = input.trim();
    return "";
  }
}

class FTMarker extends Marker {
  @override
  String get identifier => "ft";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      TLMarker,
      TLEndMarker,
      WMarker,
      WEndMarker,
      ITMarker,
      ITEndMarker,
      SCMarker,
      SCEndMarker,
      SUPMarker,
      SUPEndMarker,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
    ];
    return result;
  }
}

class FVEndMarker extends Marker {
  @override
  String get identifier => "fv*";
}

class FVMarker extends Marker {
  @override
  String get identifier => "fv";
  late String verseCharacter;

  @override
  String preProcess(String input) {
    verseCharacter = input.trim();
    return "";
  }
}

class HMarker extends Marker {
  @override
  String get identifier => "h";
  late String headerText;

  @override
  String preProcess(String input) {
    headerText = input.trim();
    return "";
  }
}

class IBMarker extends Marker {
  @override
  String get identifier => "ib";
}

class IDEMarker extends Marker {
  @override
  String get identifier => "ide";
  late String encoding;

  @override
  String preProcess(String input) {
    encoding = input.trim();
    return "";
  }
}

class IDMarker extends Marker {
  @override
  String get identifier => "id";
  late String textIdentifier;

  @override
  String preProcess(String input) {
    textIdentifier = input.trim();
    return "";
  }
}

class IEMarker extends Marker {
  @override
  String get identifier => "ie";
}

class ILIMarker extends Marker {
  int depth = 1;

  @override
  String get identifier => "ili";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class IMIMarker extends Marker {
  @override
  String get identifier => "imi";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
      ITMarker,
      ITEndMarker,
    ];
    return result;
  }
}

class IMMarker extends Marker {
  @override
  String get identifier => "im";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
      ITMarker,
      ITEndMarker,
    ];
    return result;
  }
}

class IMQMarker extends Marker {
  @override
  String get identifier => "imq";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
      ITMarker,
      ITEndMarker,
    ];
    return result;
  }
}

class IMTMarker extends Marker {
  int weight = 1;
  late String introTitle;

  @override
  String get identifier => "imt";

  @override
  String preProcess(String input) {
    introTitle = input.trim();
    return "";
  }
}

class IOMarker extends Marker {
  int depth = 1;

  @override
  String get identifier => "io";

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      IORMarker,
      IOREndMarker,
    ];
    return result;
  }
}

class IOREndMarker extends Marker {
  @override
  String get identifier => "ior*";
}

class IORMarker extends Marker {
  @override
  String get identifier => "ior";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
    ];
    return result;
  }
}

class IOTMarker extends Marker {
  late String title;

  @override
  String get identifier => "iot";

  @override
  String preProcess(String input) {
    title = input.trim();
    return "";
  }
}

class IPIMarker extends Marker {
  @override
  String get identifier => "ipi";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
      ITMarker,
      ITEndMarker,
      SCMarker,
      SCEndMarker,
      BDITMarker,
      BDITEndMarker,
      NDMarker,
      NDEndMarker,
      NOMarker,
      NOEndMarker,
      SUPMarker,
      SUPEndMarker,
    ];
    return result;
  }
}

class IPMarker extends Marker {
  @override
  String get identifier => "ip";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
      ITMarker,
      ITEndMarker,
      SCMarker,
      SCEndMarker,
      BDITMarker,
      BDITEndMarker,
      NDMarker,
      NDEndMarker,
      NOMarker,
      NOEndMarker,
      SUPMarker,
      SUPEndMarker,
      IEMarker,
      RQMarker,
      RQEndMarker,
    ];
    return result;
  }
}

class IPQMarker extends Marker {
  @override
  String get identifier => "ipq";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
      ITMarker,
      ITEndMarker,
      SCMarker,
      SCEndMarker,
      BDITMarker,
      BDITEndMarker,
      NDMarker,
      NDEndMarker,
      NOMarker,
      NOEndMarker,
      SUPMarker,
      SUPEndMarker,
    ];
    return result;
  }
}

class IPRMarker extends Marker {
  @override
  String get identifier => "ipr";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
      ITMarker,
      ITEndMarker,
      SCMarker,
      SCEndMarker,
      BDITMarker,
      BDITEndMarker,
      NDMarker,
      NDEndMarker,
      NOMarker,
      NOEndMarker,
      SUPMarker,
      SUPEndMarker,
    ];
    return result;
  }
}

class IQMarker extends Marker {
  int depth = 1;
  late String text;

  @override
  String get identifier => "iq";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
    ];
    return result;
  }
}

class ISMarker extends Marker {
  int weight = 1;
  late String heading;

  @override
  String get identifier => "is";

  @override
  String preProcess(String input) {
    heading = input.trim();
    return "";
  }
}

class ITEndMarker extends Marker {
  @override
  String get identifier => "it*";
}

class ITMarker extends Marker {
  @override
  String get identifier => "it";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
    ];
    return result;
  }
}

class KEndMarker extends Marker {
  @override
  String get identifier => "k*";
}

class KMarker extends Marker {
  @override
  String get identifier => "k";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
    ];
    return result;
  }
}

class LFMarker extends Marker {
  @override
  String get identifier => "lf";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
    ];
    return result;
  }
}

class LIKEndMarker extends Marker {
  @override
  String get identifier => "lik*";
}

class LIKMarker extends Marker {
  @override
  String get identifier => "lik";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
    ];
    return result;
  }
}

class LIMarker extends Marker {
  int depth = 1;

  @override
  String get identifier => "li";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      VMarker,
    ];
    return result;
  }
}

class LITLEndMarker extends Marker {
  @override
  String get identifier => "litl*";
}

class LITLMarker extends Marker {
  @override
  String get identifier => "litl";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class LIVEndMarker extends Marker {
  @override
  String get identifier => "liv*";
}

class LIVMarker extends Marker {
  @override
  String get identifier => "liv";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class _Stack<T> {
  final list = <T>[];
  void push(T value) => list.add(value);
  T pop() => list.removeLast();
  int get length => list.length;
}

class _StackItem {
  Marker marker;
  bool isLastInParent;

  _StackItem(this.marker, this.isLastInParent);
}

abstract class Marker {
  List<Marker> contents = <Marker>[];

  String get identifier;

  int position = 0;

  List<Type> get allowedContents {
    return <Type>[];
  }

  /// Pre-process the text contents before creating text elements inside of it
  /// [input]
  /// Returns:
  String preProcess(String input) {
    return input;
  }

  bool tryInsert(Marker input) {
    if (contents.isNotEmpty && contents.last.tryInsert(input)) {
      return true;
    }
    if (allowedContents.contains(input.runtimeType)) {
      contents.add(input);
      return true;
    }
    return false;
  }

  List<Type> getTypesPathToLastMarker() {
    List<Type> types = <Type>[];
    types.add(runtimeType);
    if (contents.isNotEmpty) {
      types.addAll(contents.last.getTypesPathToLastMarker());
    }
    return types;
  }

  List<Marker> getHierarchyToMarker(Marker target) {
    var parents = _Stack<_StackItem>();
    int childMarkerContentsCount = 0;

    bool found = false;
    var stack = _Stack<_StackItem>();

    stack.push(_StackItem(this, false));
    while (stack.length > 0) {
      var popped = stack.pop();
      var marker = popped.marker;
      var isLastInParent = popped.isLastInParent;
      if (marker == target) {
        found = true;
        break;
      }

      if (marker.contents.isNotEmpty) {
        // We're descending
        parents.push(_StackItem(marker, isLastInParent));

        childMarkerContentsCount = marker.contents.length;
        for (int i = 0; i < childMarkerContentsCount; i++) {
          stack.push(_StackItem(marker.contents[i], i == 0));
        }
      } else if (stack.length == 0 || isLastInParent) {
        // We're ascending
        var tmp = parents.pop();
        // keep moving up the parent stack until we aren't the last in a parent
        while (tmp.isLastInParent == true) {
          tmp = parents.pop();
        }
      }
    }
    var output = <Marker>[];

    if (!found) {
      return output;
    }

    for (final _StackItem i in parents.list) {
      output.add(i.marker);
    }
    output.add(target);
    return output;
  }

  /// Get the paths to multiple markers
  /// [targets] A list of markers to find
  /// Returns: A dictionary of markers and paths
  /// Remarks: In the case that the marker doesn't exist in the tree the dictionary will contain an empty list for that marker
  Map<Marker, List<Marker>> getHierachyToMultipleMarkers(List<Marker> targets) {
    Map<Marker, List<Marker>> output = <Marker, List<Marker>>{};
    var parents = _Stack<_StackItem>();
    int childMarkerContentsCount = 0;

    var stack = _Stack<_StackItem>();
    stack.push(_StackItem(this, false));
    while (stack.length > 0) {
      var popped = stack.pop();
      var marker = popped.marker;
      var isLastInParent = popped.isLastInParent;
      if (targets.contains(marker)) {
        var tmp = <Marker>[];
        for (var i in parents.list) {
          tmp.add(i.marker);
        }
        tmp.add(marker);
        output.addAll({marker: tmp});
        if (output.length == targets.length) {
          break;
        }
      }
      if (marker.contents.isNotEmpty) {
        // We're descending
        parents.push(_StackItem(marker, isLastInParent));

        childMarkerContentsCount = marker.contents.length;
        for (int i = 0; i < childMarkerContentsCount; i++) {
          stack.push(_StackItem(marker.contents[i], i == 0));
        }
      } else if (stack.length == 0 || isLastInParent) {
        // We're ascending
        var tmp = parents.pop();
        // keep moving up the parent stack until we aren't the last in a parent
        while (tmp.isLastInParent == true) {
          tmp = parents.pop();
        }
      }
    }

    for (var i in targets) {
      if (!output.containsKey(i)) {
        output.addAll({i: []});
      }
    }
    return output;
  }

  /// A recursive search for children of a certain type
  /// <typeparam name="T] </typeparam>
  /// Returns:
  List<T> getChildMarkers<T>([List<Type>? ignoredParents]) {
    List<T> output = <T>[];
    var stack = _Stack<Marker>();

    if (ignoredParents != null && ignoredParents.contains(runtimeType)) {
      return output;
    }

    stack.push(this);

    while (stack.length > 0) {
      var marker = stack.pop();
      if (marker is T) {
        output.add(marker as T);
      }

      for (var child in marker.contents) {
        if (ignoredParents == null ||
            !ignoredParents.contains(child.runtimeType)) {
          stack.push(child);
        }
      }
    }

    output.reversed.toList();
    return output;
  }

  Marker getLastDescendent() {
    if (contents.isEmpty) {
      return this;
    }
    return contents.last.getLastDescendent();
  }
}

class MIMarker extends Marker {
  @override
  String get identifier => "mi";

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      VMarker,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
      ITMarker,
      ITEndMarker,
      SCMarker,
      SCEndMarker,
      BDITMarker,
      BDITEndMarker,
      NDMarker,
      NDEndMarker,
      NOMarker,
      NOEndMarker,
      SUPMarker,
      SUPEndMarker
    ];
    return result;
  }
}

class MMarker extends Marker {
  @override
  String get identifier => "m";

  @override
  List<Type> get allowedContents {
    var result = [
      VMarker,
      TextBlock,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
      ITMarker,
      ITEndMarker,
      SCMarker,
      SCEndMarker,
      BDITMarker,
      BDITEndMarker,
      NDMarker,
      NDEndMarker,
      NOMarker,
      NOEndMarker,
      SUPMarker,
      SUPEndMarker
    ];
    return result;
  }
}

class MRMarker extends Marker {
  int weight = 1;
  late String sectionReference;

  @override
  String get identifier => "mr";

  @override
  String preProcess(String input) {
    sectionReference = input.trimLeft();
    return "";
  }

  @override
  List<Type> get allowedContents {
    var result = [FMarker, FEndMarker];
    return result;
  }
}

/// Major heading marker
class MSMarker extends Marker {
  int weight = 1;
  late String heading;

  @override
  String get identifier => "ms";

  @override
  String preProcess(String input) {
    heading = input.trimLeft();
    return "";
  }

  @override
  List<Type> get allowedContents {
    var result = [MRMarker];
    return result;
  }
}

/// Major title marker
class MTMarker extends Marker {
  int weight = 1;
  late String title;

  @override
  String get identifier => "mt";

  @override
  String preProcess(String input) {
    title = input.trim();
    return "";
  }
}

/// No Break Marker
class NBMarker extends Marker {
  @override
  String get identifier => "nb";
}

class NDEndMarker extends Marker {
  @override
  String get identifier => "nd*";
}

/// Name of God (name of Deity)
class NDMarker extends Marker {
  @override
  String get identifier => "nd";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class NOEndMarker extends Marker {
  @override
  String get identifier => "no*";
}

/// Normal Text
class NOMarker extends Marker {
  @override
  String get identifier => "no";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class ORDEndMarker extends Marker {
  @override
  String get identifier => "ord*";
}

class ORDMarker extends Marker {
  @override
  String get identifier => "ord";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

/// Centered paragraph
class PCMarker extends Marker {
  @override
  String get identifier => "pc";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      VMarker,
      BMarker,
      SPMarker,
      TextBlock,
      FMarker,
      FEndMarker,
      LIMarker,
      QMarker
    ];
    return result;
  }
}

/// Intented Paragraph marker
class PIMarker extends Marker {
  int depth = 1;

  @override
  String get identifier => "pi";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      VMarker,
      BMarker,
      SPMarker,
      TextBlock,
      FMarker,
      FEndMarker,
      LIMarker,
      QMarker
    ];
    return result;
  }
}

class PMarker extends Marker {
  @override
  String get identifier => "p";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      VMarker,
      BMarker,
      SPMarker,
      TextBlock,
      FMarker,
      FEndMarker,
      LIMarker,
      QMarker,
      XMarker
    ];
    return result;
  }
}

class PMCMarker extends Marker {
  @override
  String get identifier => "pmc";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class PMOMarker extends Marker {
  @override
  String get identifier => "pmo";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class PMRMarker extends Marker {
  @override
  String get identifier => "pmr";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class PNEndMarker extends Marker {
  @override
  String get identifier => "pn*";
}

class PNGEndMarker extends Marker {
  @override
  String get identifier => "png*";
}

class PNGMarker extends Marker {
  @override
  String get identifier => "png";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

/// Name of God (name of Deity)
class PNMarker extends Marker {
  @override
  String get identifier => "pn";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class PRMarker extends Marker {
  @override
  String get identifier => "pr";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class PROEndMarker extends Marker {
  @override
  String get identifier => "pro*";
}

/// Name of God (name of Deity)
class PROMarker extends Marker {
  @override
  String get identifier => "pro";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class QACEndMarker extends Marker {
  @override
  String get identifier => "qac*";
}

/// Marker to indicate the acrostic letter within a poetic line
class QACMarker extends Marker {
  late String acrosticLetter;

  @override
  String get identifier => "qac";

  @override
  String preProcess(String input) {
    acrosticLetter = input.trim();
    return "";
  }
}

/// Acrostic heading for poetry
class QAMarker extends Marker {
  /// Heading for the poetry
  late String heading;

  @override
  String get identifier => "qa";

  @override
  String preProcess(String input) {
    heading = input.trim();
    return "";
  }

  @override
  List<Type> get allowedContents {
    var result = [QACMarker, QACEndMarker];
    return result;
  }
}

/// Centered poetic line
class QCMarker extends Marker {
  @override
  String get identifier => "qc";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      FMarker,
      FEndMarker,
      TLMarker,
      TLEndMarker,
      WMarker,
      WEndMarker
    ];
    return result;
  }
}

/// Hebrew note
class QDMarker extends Marker {
  @override
  String get identifier => "qd";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      FMarker,
      FEndMarker,
      TLMarker,
      TLEndMarker,
      WMarker,
      WEndMarker
    ];
    return result;
  }
}

/// A Poetry Marker
class QMarker extends Marker {
  int depth = 1;
  late String text;
  bool isPoetryBlock = false;

  @override
  String get identifier => "q";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      BMarker,
      QSMarker,
      QSEndMarker,
      TextBlock,
      FMarker,
      FEndMarker,
      TLMarker,
      TLEndMarker,
      WMarker,
      WEndMarker,
      VMarker
    ];
    return result;
  }

  @override
  bool tryInsert(Marker input) {
    if (input is VMarker && contents.any((m) => m is VMarker)) {
      return false;
    }
    return super.tryInsert(input);
  }
}

/// Embedded text poetic line
class QMMarker extends Marker {
  int depth = 1;

  @override
  String get identifier => "qm";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      FMarker,
      FEndMarker,
      TLMarker,
      TLEndMarker,
      WMarker,
      WEndMarker
    ];
    return result;
  }
}

/// Right-aligned poetic line
class QRMarker extends Marker {
  @override
  String get identifier => "qr";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [
      TextBlock,
      FMarker,
      FEndMarker,
      TLMarker,
      TLEndMarker,
      WMarker,
      WEndMarker
    ];
    return result;
  }
}

class QSEndMarker extends Marker {
  @override
  String get identifier => "qs*";
}

/// Poetry Selah Marker (I know weird but it is in the spec)
class QSMarker extends Marker {
  late String text;

  @override
  String get identifier => "qs";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class QTEndMarker extends Marker {
  @override
  String get identifier => "qt*";
}

class QTMarker extends Marker {
  @override
  String get identifier => "qt";

  @override
  String preProcess(String input) {
    return input;
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class RBEndMarker extends Marker {
  @override
  String get identifier => "rb*";
}

class RBMarker extends Marker {
  @override
  String get identifier => "rb";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class REMMarker extends Marker {
  late String comment;

  @override
  String get identifier => "rem";

  @override
  String preProcess(String input) {
    comment = input.trim();
    return "";
  }
}

/// Parallel passage reference(s)
class RMarker extends Marker {
  @override
  String get identifier => "r";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class RQEndMarker extends Marker {
  @override
  String get identifier => "rq*";
}

/// Inline quotation reference(s)
class RQMarker extends Marker {
  @override
  String get identifier => "rq";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class SCEndMarker extends Marker {
  @override
  String get identifier => "sc*";
}

/// Small-Cap Letter
class SCMarker extends Marker {
  @override
  String get identifier => "sc";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class SIGEndMarker extends Marker {
  @override
  String get identifier => "sig*";
}

class SIGMarker extends Marker {
  @override
  String get identifier => "sig";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class SLSEndMarker extends Marker {
  @override
  String get identifier => "sls*";
}

class SLSMarker extends Marker {
  @override
  String get identifier => "sls";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

/// Section marker
class SMarker extends Marker {
  int weight = 1;
  late String text;

  @override
  String get identifier => "s";

  @override
  String preProcess(String input) {
    text = input.trimLeft();
    return "";
  }

  @override
  List<Type> get allowedContents {
    var result = [
      RMarker,
      FMarker,
      FEndMarker,
      SCMarker,
      SCEndMarker,
      EMMarker,
      EMEndMarker,
      BDMarker,
      BDEndMarker,
      ITMarker,
      ITEndMarker,
      BDITMarker,
      BDITEndMarker,
      NOMarker,
      NOEndMarker,
      SUPMarker,
      SUPEndMarker,
      TextBlock
    ];
    return result;
  }
}

/// A speaker Marker (Used mostly in Job and Songs of Solomon)
class SPMarker extends Marker {
  late String speaker;

  @override
  String get identifier => "sp";

  @override
  String preProcess(String input) {
    speaker = input.trim();
    return "";
  }
}

/// Project text status tracking
class STSMarker extends Marker {
  late String statusText;

  @override
  String get identifier => "sts";

  @override
  String preProcess(String input) {
    statusText = input.trim();
    return "";
  }
}

class SUPEndMarker extends Marker {
  @override
  String get identifier => "sup*";
}

/// Superscript text. Typically for use in critical edition footnotes
class SUPMarker extends Marker {
  @override
  String get identifier => "sup";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

/// A "marker" for a table block. This exists so that we can handle table data
class TableBlock extends Marker {
  @override
  String get identifier => "";

  @override
  List<Type> get allowedContents {
    var result = [TRMarker];
    return result;
  }
}

/// Table Cell Marker
class TCMarker extends Marker {
  int columnPosition = 1;

  @override
  String get identifier => "tc";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class TCRMarker extends Marker {
  int columnPosition = 1;

  @override
  String get identifier => "tcr";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

/// A "marker" for a text block. This exists so that we can handle
class TextBlock extends Marker {
  String text;

  TextBlock(this.text);

  @override
  String get identifier => "";
}

class THMarker extends Marker {
  int columnPosition = 1;

  @override
  String get identifier => "th";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class THRMarker extends Marker {
  int columnPosition = 1;

  @override
  String get identifier => "thr";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class TLEndMarker extends Marker {
  @override
  String get identifier => "tl*";
}

/// Transliterated (or foreign) word(s)
class TLMarker extends Marker {
  @override
  String get identifier => "tl";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

/// A tag for the long table of contents
class TOC1Marker extends Marker {
  late String longTableOfContentsText;

  @override
  String get identifier => "toc1";

  @override
  String preProcess(String input) {
    longTableOfContentsText = input.trim();
    return "";
  }
}

/// Tag for the short table of contents
class TOC2Marker extends Marker {
  late String shortTableOfContentsText;

  @override
  String get identifier => "toc2";

  @override
  String preProcess(String input) {
    shortTableOfContentsText = input.trim();
    return "";
  }
}

/// Tag for book abbreviation
class TOC3Marker extends Marker {
  late String bookAbbreviation;

  @override
  String get identifier => "toc3";

  @override
  String preProcess(String input) {
    bookAbbreviation = input.trim();
    return "";
  }
}

/// A tag for the alternative language long table of contents
class TOCA1Marker extends Marker {
  late String altLongTableOfContentsText;

  @override
  String get identifier => "toca1";

  @override
  String preProcess(String input) {
    altLongTableOfContentsText = input.trim();
    return "";
  }
}

/// Tag for the Alternative language short table of contents
class TOCA2Marker extends Marker {
  late String altShortTableOfContentsText;

  @override
  String get identifier => "toca2";

  @override
  String preProcess(String input) {
    altShortTableOfContentsText = input.trim();
    return "";
  }
}

/// Tag for alternative language book abbreviation
class TOCA3Marker extends Marker {
  late String altBookAbbreviation;

  @override
  String get identifier => "toca3";

  @override
  String preProcess(String input) {
    altBookAbbreviation = input.trim();
    return "";
  }
}

class TRMarker extends Marker {
  @override
  String get identifier => "tr";

  @override
  List<Type> get allowedContents {
    var result = [TCMarker, THMarker, TCRMarker, THRMarker];
    return result;
  }
}

class UnknownMarker extends Marker {
  late String parsedIdentifier;
  late String parsedValue;

  @override
  String get identifier => "";

  @override
  String preProcess(String input) {
    parsedValue = input;
    return "";
  }
}

class USFMDocument extends Marker {
  USFMDocument() {
    contents = <Marker>[];
  }

  @override
  String get identifier => "";

  @override
  List<Type> get allowedContents {
    var result = [
      HMarker,
      IDEMarker,
      IDMarker,
      IBMarker,
      IQMarker,
      ILIMarker,
      IOTMarker,
      IOMarker,
      STSMarker,
      USFMMarker,
      TOC1Marker,
      TOC2Marker,
      TOC3Marker,
      TOCA1Marker,
      TOCA2Marker,
      TOCA3Marker,
      ISMarker,
      MTMarker,
      IMTMarker,
      IPMarker,
      IPIMarker,
      IMMarker,
      IMIMarker,
      IPQMarker,
      IMQMarker,
      IPRMarker,
      CLMarker,
      CMarker
    ];
    return result;
  }

  void insert(Marker input) {
    if (!tryInsert(input)) {
      // Since this is the root then add them anyway
      contents.add(input);
    }
  }

  void insert1(USFMDocument document) {
    insertMultiple(document.contents);
  }

  void insertMultiple(Iterable<Marker> input) {
    for (Marker i in input) {
      insert(i);
    }
  }
}

/// Marker for USFM version
class USFMMarker extends Marker {
  @override
  String get identifier => "usfm";

  /// USFM Version
  late String version;

  @override
  String preProcess(String input) {
    version = input.trim();
    return "";
  }
}

class VAEndMarker extends Marker {
  @override
  String get identifier => "va*";
}

/// Alternate verse number
class VAMarker extends Marker {
  late String altVerseNumber;

  @override
  String get identifier => "va";

  @override
  String preProcess(String input) {
    altVerseNumber = input.trim();
    return "";
  }
}

class VMarker extends Marker {
  // This is a string because of verse bridges. In the future this should have starting and ending verse
  late String verseNumber;
  static final RegExp _verseRegex = RegExp("^ *([0-9]*-?[0-9]*) ?([\\s\\S.]*)");
  int startingVerse = 0;
  int endingVerse = 0;

  String get verseCharacter {
    var firstCharacterMarker = getChildMarkers<VPMarker>();
    if (firstCharacterMarker.isNotEmpty) {
      return firstCharacterMarker[0].verseCharacter;
    } else {
      return verseNumber;
    }
  }

  @override
  String get identifier => "v";

  @override
  String preProcess(String input) {
    var match = _verseRegex.firstMatch(input);
    if (match != null) {
      verseNumber = match.group(1) ?? "";
      if (!verseNumber.isNullOrWhiteSpace()) {
        var verseBridgeChars = verseNumber.split('-');
        startingVerse = int.parse(verseBridgeChars[0]);
        endingVerse = verseBridgeChars.length > 1 &&
                !verseBridgeChars[1].isNullOrWhiteSpace()
            ? int.parse(verseBridgeChars[1])
            : startingVerse;
      }
    }
    return match?.group(2) ?? "";
  }

  @override
  List<Type> get allowedContents {
    var result = [
      VPMarker,
      VPEndMarker,
      TLMarker,
      TLEndMarker,
      ADDMarker,
      ADDEndMarker,
      BMarker,
      BKMarker,
      BKEndMarker,
      BDMarker,
      BDEndMarker,
      ITMarker,
      ITEndMarker,
      EMMarker,
      EMEndMarker,
      BDITMarker,
      BDITEndMarker,
      SUPMarker,
      SUPEndMarker,
      NOMarker,
      NOEndMarker,
      SCMarker,
      SCEndMarker,
      NDMarker,
      NDEndMarker,
      QMarker,
      MMarker,
      FMarker,
      FEndMarker,
      FRMarker,
      FREndMarker,
      SPMarker,
      TextBlock,
      WMarker,
      WEndMarker,
      XMarker,
      XEndMarker,
      CLSMarker,
      RQMarker,
      RQEndMarker,
      PIMarker,
      MIMarker,
      QSMarker,
      QSEndMarker,
      QRMarker,
      QCMarker,
      QDMarker,
      QACMarker,
      QACEndMarker,
      SMarker,
      VAMarker,
      VAEndMarker,
      KMarker,
      KEndMarker,
      LFMarker,
      LIKMarker,
      LIKEndMarker,
      LITLMarker,
      LITLEndMarker,
      LIVMarker,
      LIMarker,
      LIVEndMarker,
      ORDMarker,
      ORDEndMarker,
      PMCMarker,
      PMOMarker,
      PMRMarker,
      PNMarker,
      PNEndMarker,
      PNGMarker,
      PNGEndMarker,
      PRMarker,
      QTMarker,
      QTEndMarker,
      RBMarker,
      RBEndMarker,
      SIGMarker,
      SIGEndMarker,
      SLSMarker,
      SLSEndMarker,
      WAMarker,
      WAEndMarker,
      WGMarker,
      WGEndMarker,
      WHMarker,
      WHEndMarker,
      WJMarker,
      WJEndMarker,
      FIGMarker,
      FIGEndMarker,
      PNMarker,
      PNEndMarker,
      PROMarker,
      PROEndMarker,
      REMMarker,
      PMarker,
      LIMarker
    ];
    return result;
  }

  @override
  bool tryInsert(Marker input) {
    if (input is VMarker) {
      return false;
    }

    if (input is QMarker && input.isPoetryBlock) {
      return false;
    }

    return super.tryInsert(input);
  }
}

class VPEndMarker extends Marker {
  @override
  String get identifier => "vp*";
}

/// Marker for Custom Verse Number
class VPMarker extends Marker {
  late String verseCharacter;

  @override
  String get identifier => "vp";

  @override
  String preProcess(String input) {
    verseCharacter = input.trim();
    return "";
  }
}

class WAEndMarker extends Marker {
  @override
  String get identifier => "wa*";
}

class WAMarker extends Marker {
  @override
  String get identifier => "wa";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class WEndMarker extends Marker {
  @override
  String get identifier => "w*";
}

class WGEndMarker extends Marker {
  @override
  String get identifier => "wg*";
}

class WGMarker extends Marker {
  @override
  String get identifier => "wg";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class WHEndMarker extends Marker {
  @override
  String get identifier => "wh*";
}

class WHMarker extends Marker {
  @override
  String get identifier => "wh";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

class WJEndMarker extends Marker {
  @override
  String get identifier => "wj*";
}

class WJMarker extends Marker {
  @override
  String get identifier => "wj";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

/// Wordlist / Glossary / Dictionary Entry Marker
class WMarker extends Marker {
  late String term;
  Map<String, String> attributes = {};
  static final RegExp _wordAttrPattern = RegExp("([\\w]+)=?\"?([\\w,:.]*)\"?");

  @override
  String get identifier => "w";

  @override
  String preProcess(String input) {
    input = input.trim();
    attributes = <String, String>{};

    List<String> wordEntry = input.split('|');
    term = wordEntry[0];

    if (wordEntry.length > 1) {
      List<String> wordAttr = wordEntry[1].split(' ');
      for (String attr in wordAttr) {
        var attrMatch = _wordAttrPattern.firstMatch(attr);
        if (attrMatch?.group(2)?.isEmpty ?? false) {
          attributes["lemma"] = attrMatch!.group(1)!;
        } else {
          attributes[attrMatch!.group(1)!] = attrMatch.group(2)!;
        }
      }
    }
    return "";
  }
}

class XEndMarker extends Marker {
  @override
  String get identifier => "x*";
}

/// Cross reference element
class XMarker extends Marker {
  @override
  String get identifier => "x";
  late String crossRefCaller;

  @override
  String preProcess(String input) {
    crossRefCaller = input.trim();
    return "";
  }

  @override
  List<Type> get allowedContents {
    var result = [XOMarker, XTMarker, XQMarker, TextBlock];
    return result;
  }
}

/// Cross reference origin reference
class XOMarker extends Marker {
  late String originRef;

  @override
  String get identifier => "xo";

  @override
  String preProcess(String input) {
    originRef = input.trim();
    return "";
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

/// A quotation from the scripture text
class XQMarker extends Marker {
  @override
  String get identifier => "xq";

  @override
  String preProcess(String input) {
    return input.trim();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}

/// Target reference(s)
class XTMarker extends Marker {
  @override
  String get identifier => "xt";

  @override
  String preProcess(String input) {
    return input.trimLeft();
  }

  @override
  List<Type> get allowedContents {
    var result = [TextBlock];
    return result;
  }
}
