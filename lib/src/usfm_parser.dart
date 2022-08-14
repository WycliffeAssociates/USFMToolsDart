import 'package:usfmtoolsdart/src/markers/markers.dart';
import 'package:usfmtoolsdart/src/convert_to_marker_result.dart';
import 'package:usfmtoolsdart/src/utils/string_extensions.dart';

/// Parses a USFM file into a Abstract Syntax Tree
class USFMParser {
  List<String> _ignoredTags = <String>[];
  bool _ignoreUnknownMarkers = false;
  static final RegExp _splitRegex = RegExp("\\\\([a-z0-9\\-]*\\**)([^\\\\]*)");

  USFMParser([List<String>? tagsToIgnore, bool ignoreUnknownMarkers = false]) {
    _ignoredTags = tagsToIgnore ?? <String>[];
    _ignoreUnknownMarkers = ignoreUnknownMarkers;
  }

  /// Parses a string into a USFMDocument
  /// [input] A USFM string
  /// Returns: A USFMDocument representing the input
  USFMDocument parseFromString(String input) {
    USFMDocument output = USFMDocument();
    var markers = _tokenizeFromString(input);

    // Clean out extra whitespace where it isn't needed
    markers = _cleanWhitespace(markers);

    for (int markerIndex = 0; markerIndex < markers.length; markerIndex++) {
      Marker marker = markers[markerIndex];
      if (marker is TRMarker &&
          !output.getTypesPathToLastMarker().contains(TableBlock)) {
        output.insert(TableBlock());
      }
      if (marker is QMarker &&
          markerIndex != markers.length - 1 &&
          markers[markerIndex + 1] is VMarker) {
        marker.isPoetryBlock = true;
      }
      output.insert(marker);
    }

    return output;
  }

  /// Removes all the unessecary whitespace while preserving space between closing markers and opening markers
  /// [input]
  List<Marker> _cleanWhitespace(List<Marker> input) {
    var output = <Marker>[];
    for (var index = 0; index < input.length; index++) {
      if (!(input[index] is TextBlock &&
          (input[index] as TextBlock).text.isNullOrWhiteSpace())) {
        output.add(input[index]);
        continue;
      }

      // If this is an empty text block at the beginning remove it
      if (index == 0) {
        continue;
      }

      // If this is an empty text block at the end then remove it
      if (index == input.length - 1) {
        continue;
      }

      // If this isn't between and end marker and another marker then delete it
      if (!(input[index - 1].identifier.endsWith("*") &&
          !input[index + 1].identifier.endsWith("*"))) {
        continue;
      }

      output.add(input[index]);
    }
    return output;
  }

  /// Generate a list of Markers from a string
  /// [input] USFM String to tokenize
  /// Returns: A List of Markers based upon the string
  List<Marker> _tokenizeFromString(String input) {
    List<Marker> output = <Marker>[];

    for (Match match in _splitRegex.allMatches(input)) {
      if (_ignoredTags.contains(match.group(1))) {
        continue;
      }

      ConvertToMarkerResult result =
          _convertToMarker(match.group(1)!, match.group(2)!);
      result.marker.position = match.start;

      // If this is an unkown marker and we're in Ignore Unkown Marker mode then don't add the marker. We still keep any remaining text though
      if (result.marker is! UnknownMarker || !_ignoreUnknownMarkers) {
        output.add(result.marker);
      }

      if (!result.remainingText.isNullOrEmpty()) {
        output.add(TextBlock(result.remainingText));
      }
    }

    return output;
  }

  ConvertToMarkerResult _convertToMarker(String identifier, String value) {
    Marker output = _selectMarker(identifier);
    String tmp = output.preProcess(value);
    return ConvertToMarkerResult(output, tmp);
  }

  Marker _selectMarker(String identifier) {
    switch (identifier) {
      case "id":
        {
          return IDMarker();
        }
      case "ide":
        {
          return IDEMarker();
        }
      case "sts":
        {
          return STSMarker();
        }
      case "h":
        {
          return HMarker();
        }
      case "toc1":
        {
          return TOC1Marker();
        }
      case "toc2":
        {
          return TOC2Marker();
        }
      case "toc3":
        {
          return TOC3Marker();
        }
      case "toca1":
        {
          return TOCA1Marker();
        }
      case "toca2":
        {
          return TOCA2Marker();
        }
      case "toca3":
        {
          return TOCA3Marker();
        }

      /* Introduction Markers*/
      case "imt":
        {
          return IMTMarker();
        }
      /* Introduction Markers*/
      case "imt1":
        {
          return IMTMarker();
        }
      case "imt2":
        {
          var result = IMTMarker();
          result.weight = 2;
          return result;
        }
      case "imt3":
        {
          var result = IMTMarker();
          result.weight = 3;
          return result;
        }
      case "is":
        {
          return ISMarker();
        }
      case "is1":
        {
          return ISMarker();
        }
      case "is2":
        {
          var result = ISMarker();
          result.weight = 2;
          return result;
        }
      case "is3":
        {
          var result = ISMarker();
          result.weight = 3;
          return result;
        }
      case "ib":
        {
          return IBMarker();
        }
      case "iq":
        {
          return IQMarker();
        }
      case "iq1":
        {
          return IQMarker();
        }
      case "iq2":
        {
          var result = IQMarker();
          result.depth = 2;
          return result;
        }
      case "iq3":
        {
          var result = IQMarker();
          result.depth = 3;
          return result;
        }
      case "iot":
        {
          return IOTMarker();
        }
      case "io":
        {
          return IOMarker();
        }
      case "io1":
        {
          return IOMarker();
        }
      case "io2":
        {
          var result = IOMarker();
          result.depth = 2;
          return result;
        }
      case "io3":
        {
          var result = IOMarker();
          result.depth = 3;
          return result;
        }
      case "ior":
        {
          return IORMarker();
        }
      case "ior*":
        {
          return IOREndMarker();
        }
      case "ili":
        {
          return ILIMarker();
        }
      case "ili1":
        {
          return ILIMarker();
        }
      case "ili2":
        {
          var result = ILIMarker();
          result.depth = 2;
          return result;
        }
      case "ili3":
        {
          var result = ILIMarker();
          result.depth = 3;
          return result;
        }
      case "ip":
        {
          return IPMarker();
        }
      case "ipi":
        {
          return IPIMarker();
        }
      case "im":
        {
          return IMMarker();
        }
      case "imi":
        {
          return IMIMarker();
        }
      case "ipq":
        {
          return IPQMarker();
        }
      case "imq":
        {
          return IMQMarker();
        }
      case "ipr":
        {
          return IPRMarker();
        }
      case "mt":
        {
          return MTMarker();
        }
      case "mt1":
        {
          return MTMarker();
        }
      case "mt2":
        {
          var result = MTMarker();
          result.weight = 2;
          return result;
        }
      case "mt3":
        {
          var result = MTMarker();
          result.weight = 3;
          return result;
        }
      case "c":
        {
          return CMarker();
        }
      case "cp":
        {
          return CPMarker();
        }
      case "ca":
        {
          return CAMarker();
        }
      case "ca*":
        {
          return CAEndMarker();
        }
      case "p":
        {
          return PMarker();
        }
      case "v":
        {
          return VMarker();
        }
      case "va":
        {
          return VAMarker();
        }
      case "va*":
        {
          return VAEndMarker();
        }
      case "vp":
        {
          return VPMarker();
        }
      case "vp*":
        {
          return VPEndMarker();
        }
      case "q":
        {
          return QMarker();
        }
      case "q1":
        {
          return QMarker();
        }
      case "q2":
        {
          var result = QMarker();
          result.depth = 2;
          return result;
        }
      case "q3":
        {
          var result = QMarker();
          result.depth = 3;
          return result;
        }
      case "q4":
        {
          var result = QMarker();
          result.depth = 4;
          return result;
        }
      case "qr":
        {
          return QRMarker();
        }
      case "qc":
        {
          return QCMarker();
        }
      case "qd":
        {
          return QDMarker();
        }
      case "qac":
        {
          return QACMarker();
        }
      case "qac*":
        {
          return QACEndMarker();
        }
      case "qm":
        {
          var result = QMMarker();
          result.depth = 1;
          return result;
        }
      case "qm1":
        {
          var result = QMMarker();
          result.depth = 1;
          return result;
        }
      case "qm2":
        {
          var result = QMMarker();
          result.depth = 2;
          return result;
        }
      case "qm3":
        {
          var result = QMMarker();
          result.depth = 3;
          return result;
        }

      case "m":
        {
          return MMarker();
        }
      case "d":
        {
          return DMarker();
        }
      case "ms":
        {
          return MSMarker();
        }
      case "ms1":
        {
          return MSMarker();
        }
      case "ms2":
        {
          var result = MSMarker();
          result.weight = 2;
          return result;
        }
      case "ms3":
        {
          var result = MSMarker();
          result.weight = 3;
          return result;
        }
      case "mr":
        {
          return MRMarker();
        }
      case "cl":
        {
          return CLMarker();
        }
      case "qs":
        {
          return QSMarker();
        }
      case "qs*":
        {
          return QSEndMarker();
        }
      case "f":
        {
          return FMarker();
        }
      case "fp":
        {
          return FPMarker();
        }
      case "qa":
        {
          return QAMarker();
        }
      case "nb":
        {
          return NBMarker();
        }
      case "fqa":
        {
          return FQAMarker();
        }
      case "fqa*":
        {
          return FQAEndMarker();
        }
      case "fq":
        {
          return FQMarker();
        }
      case "fq*":
        {
          return FQEndMarker();
        }
      case "pi":
        {
          return PIMarker();
        }
      case "pi1":
        {
          return PIMarker();
        }
      case "pi2":
        {
          var result = PIMarker();
          result.depth = 2;
          return result;
        }
      case "pi3":
        {
          var result = PIMarker();
          result.depth = 3;
          return result;
        }
      case "sp":
        {
          return SPMarker();
        }
      case "ft":
        {
          return FTMarker();
        }
      case "fr":
        {
          return FRMarker();
        }
      case "fr*":
        {
          return FREndMarker();
        }
      case "fk":
        {
          return FKMarker();
        }
      case "fv":
        {
          return FVMarker();
        }
      case "fv*":
        {
          return FVEndMarker();
        }
      case "f*":
        {
          return FEndMarker();
        }
      case "bd":
        {
          return BDMarker();
        }
      case "bd*":
        {
          return BDEndMarker();
        }
      case "it":
        {
          return ITMarker();
        }
      case "it*":
        {
          return ITEndMarker();
        }
      case "rem":
        {
          return REMMarker();
        }
      case "b":
        {
          return BMarker();
        }
      case "s":
        {
          return SMarker();
        }
      case "s1":
        {
          return SMarker();
        }
      case "s2":
        {
          var result = SMarker();
          result.weight = 2;
          return result;
        }
      case "s3":
        {
          var result = SMarker();
          result.weight = 3;
          return result;
        }
      case "s4":
        {
          var result = SMarker();
          result.weight = 4;
          return result;
        }
      case "s5":
        {
          var result = SMarker();
          result.weight = 5;
          return result;
        }
      case "bk":
        {
          return BKMarker();
        }
      case "bk*":
        {
          return BKEndMarker();
        }
      case "li":
        {
          return LIMarker();
        }
      case "li1":
        {
          return LIMarker();
        }
      case "li2":
        {
          var result = LIMarker();
          result.depth = 2;
          return result;
        }
      case "li3":
        {
          var result = LIMarker();
          result.depth = 3;
          return result;
        }
      case "add":
        {
          return ADDMarker();
        }
      case "add*":
        {
          return ADDEndMarker();
        }
      case "tl":
        {
          return TLMarker();
        }
      case "tl*":
        {
          return TLEndMarker();
        }
      case "mi":
        {
          return MIMarker();
        }
      case "sc":
        {
          return SCMarker();
        }
      case "sc*":
        {
          return SCEndMarker();
        }
      case "r":
        {
          return RMarker();
        }
      case "rq":
        {
          return RQMarker();
        }
      case "rq*":
        {
          return RQEndMarker();
        }
      case "w":
        {
          return WMarker();
        }
      case "w*":
        {
          return WEndMarker();
        }
      case "x":
        {
          return XMarker();
        }
      case "x*":
        {
          return XEndMarker();
        }
      case "xo":
        {
          return XOMarker();
        }
      case "xt":
        {
          return XTMarker();
        }
      case "xq":
        {
          return XQMarker();
        }
      case "pc":
        {
          return PCMarker();
        }
      case "cls":
        {
          return CLSMarker();
        }
      case "tr":
        {
          return TRMarker();
        }
      case "th1":
        {
          return THMarker();
        }
      case "thr1":
        {
          return THRMarker();
        }
      case "th2":
        {
          var result = THMarker();
          result.columnPosition = 2;
          return result;
        }
      case "thr2":
        {
          var result = THRMarker();
          result.columnPosition = 2;
          return result;
        }
      case "th3":
        {
          var result = THMarker();
          result.columnPosition = 3;
          return result;
        }
      case "thr3":
        {
          var result = THRMarker();
          result.columnPosition = 3;
          return result;
        }
      case "tc1":
        {
          return TCMarker();
        }
      case "tcr1":
        {
          return TCRMarker();
        }
      case "tc2":
        {
          var result = TCMarker();
          result.columnPosition = 2;
          return result;
        }
      case "tcr2":
        {
          var result = TCRMarker();
          result.columnPosition = 2;
          return result;
        }
      case "tc3":
        {
          var result = TCMarker();
          result.columnPosition = 3;
          return result;
        }
      case "tcr3":
        {
          var result = TCRMarker();
          result.columnPosition = 3;
          return result;
        }
      case "usfm":
        {
          return USFMMarker();
        }
      /* Character Styles */
      case "em":
        {
          return EMMarker();
        }
      case "em*":
        {
          return EMEndMarker();
        }
      case "bdit":
        {
          return BDITMarker();
        }
      case "bdit*":
        {
          return BDITEndMarker();
        }
      case "no":
        {
          return NOMarker();
        }
      case "no*":
        {
          return NOEndMarker();
        }
      case "k":
        {
          return KMarker();
        }
      case "k*":
        {
          return KEndMarker();
        }
      case "lf":
        {
          return LFMarker();
        }
      case "lik":
        {
          return LIKMarker();
        }
      case "lik*":
        {
          return LIKEndMarker();
        }
      case "litl":
        {
          return LITLMarker();
        }
      case "litl*":
        {
          return LITLEndMarker();
        }
      case "liv":
        {
          return LIVMarker();
        }
      case "liv*":
        {
          return LIVEndMarker();
        }
      case "ord":
        {
          return ORDMarker();
        }
      case "ord*":
        {
          return ORDEndMarker();
        }
      case "pmc":
        {
          return PMCMarker();
        }
      case "pmo":
        {
          return PMOMarker();
        }
      case "pmr":
        {
          return PMRMarker();
        }
      case "png":
        {
          return PNGMarker();
        }
      case "png*":
        {
          return PNGEndMarker();
        }
      case "pr":
        {
          return PRMarker();
        }
      case "qt":
        {
          return QTMarker();
        }
      case "qt*":
        {
          return QTEndMarker();
        }
      case "rb":
        {
          return RBMarker();
        }
      case "rb*":
        {
          return RBEndMarker();
        }
      case "sig":
        {
          return SIGMarker();
        }
      case "sig*":
        {
          return SIGEndMarker();
        }
      case "sls":
        {
          return SLSMarker();
        }
      case "sls*":
        {
          return SLSEndMarker();
        }
      case "wa":
        {
          return WAMarker();
        }
      case "wa*":
        {
          return WAEndMarker();
        }
      case "wg":
        {
          return WGMarker();
        }
      case "wg*":
        {
          return WGEndMarker();
        }
      case "wh":
        {
          return WHMarker();
        }
      case "wh*":
        {
          return WHEndMarker();
        }
      case "wj":
        {
          return WJMarker();
        }
      case "wj*":
        {
          return WJEndMarker();
        }
      case "nd":
        {
          return NDMarker();
        }
      case "nd*":
        {
          return NDEndMarker();
        }
      case "sup":
        {
          return SUPMarker();
        }
      case "sup*":
        {
          return SUPEndMarker();
        }
      case "ie":
        {
          return IEMarker();
        }
      case "pn":
        {
          return PNMarker();
        }
      case "pn*":
        {
          return PNEndMarker();
        }
      case "pro":
        {
          return PROMarker();
        }
      case "pro*":
        {
          return PROEndMarker();
        }

      /* Special Features */
      case "fig":
        {
          return FIGMarker();
        }
      case "fig*":
        {
          return FIGEndMarker();
        }

      default:
        {
          var result = UnknownMarker();
          result.parsedIdentifier = identifier;
          return result;
        }
    }
  }
}
