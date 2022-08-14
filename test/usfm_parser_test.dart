import 'package:test/test.dart';
import 'package:usfmtoolsdart/usfmtoolsdart.dart';

void main() {
  late USFMParser parser;

  setUp(() {
    parser = USFMParser();
  });

  void _checkTypeList(List<Type> types, List<Marker> markers) {
    for (var i = 0; i < types.length; i++) {
      expect(markers[i].runtimeType, types[i], reason: "Expected type ${types[i]} but got ${markers[i]} at index $i");
    }
  }

  test('testIgnoredTags', () {
    parser = USFMParser(["bd", "bd*"]);
    USFMDocument doc = parser.parseFromString("\\v 1 In the beginning \\bd God \\bd*");
    expect(1, doc.contents.length);
    VMarker vm = doc.contents[0] as VMarker;
    expect(1, vm.contents.length);
    TextBlock tb = vm.contents[0] as TextBlock;
    expect(0, tb.contents.length);
    expect("In the beginning ", tb.text);
  });

  test('testIdentificationMarkers', () {
    expect("Genesis", (parser.parseFromString("\\id Genesis").contents[0] as IDMarker).textIdentifier);
    expect("UTF-8", (parser.parseFromString("\\ide UTF-8").contents[0] as IDEMarker).encoding);
    expect("2", (parser.parseFromString("\\sts 2").contents[0] as STSMarker).statusText);

    expect("3.0", (parser.parseFromString("\\usfm 3.0").contents[0] as USFMMarker).version);

    USFMDocument doc = parser.parseFromString("\\rem Remark");
    expect(doc.contents[0].runtimeType, REMMarker);
    REMMarker rem = doc.contents[0] as REMMarker;
    expect("Remark", rem.comment);
  });

  test('testIntroductionMarkers',() {
    expect("Title", (parser.parseFromString("\\imt Title").contents[0] as IMTMarker).introTitle);
    expect(1, (parser.parseFromString("\\imt").contents[0] as IMTMarker).weight);
    expect(1, (parser.parseFromString("\\imt1").contents[0] as IMTMarker).weight);
    expect(2, (parser.parseFromString("\\imt2").contents[0] as IMTMarker).weight);
    expect(3, (parser.parseFromString("\\imt3").contents[0] as IMTMarker).weight);

    expect("Heading", (parser.parseFromString("\\is Heading").contents[0] as ISMarker).heading);
    expect(1, (parser.parseFromString("\\is").contents[0] as ISMarker).weight);
    expect(1, (parser.parseFromString("\\is1").contents[0] as ISMarker).weight);
    expect(2, (parser.parseFromString("\\is2").contents[0] as ISMarker).weight);
    expect(3, (parser.parseFromString("\\is3").contents[0] as ISMarker).weight);

    expect(1, (parser.parseFromString("\\iq").contents[0] as IQMarker).depth);
    expect(1, (parser.parseFromString("\\iq1").contents[0] as IQMarker).depth);
    expect(2, (parser.parseFromString("\\iq2").contents[0] as IQMarker).depth);
    expect(3, (parser.parseFromString("\\iq3").contents[0] as IQMarker).depth);

    // Assert.isNotNull((_parser.parseFromString("\\ib").contents[0] as IBMarker));

    expect("Title", (parser.parseFromString("\\iot Title").contents[0] as IOTMarker).title);

    expect(1, (parser.parseFromString("\\io").contents[0] as IOMarker).depth);
    expect(1, (parser.parseFromString("\\io1").contents[0] as IOMarker).depth);
    expect(2, (parser.parseFromString("\\io2").contents[0] as IOMarker).depth);
    expect(3, (parser.parseFromString("\\io3").contents[0] as IOMarker).depth);

    USFMDocument doc = parser.parseFromString("\\ior (1.1-3)\\ior*");
    expect(2, doc.contents.length);
    expect("(1.1-3)", (doc.contents[0].contents[0] as TextBlock).text);

    expect("Text", (parser.parseFromString("\\ili Text").contents[0].contents[0] as TextBlock).text);
    expect(1, (parser.parseFromString("\\ili").contents[0] as ILIMarker).depth);
    expect(1, (parser.parseFromString("\\ili1").contents[0] as ILIMarker).depth);
    expect(2, (parser.parseFromString("\\ili2").contents[0] as ILIMarker).depth);
    expect(3, (parser.parseFromString("\\ili3").contents[0] as ILIMarker).depth);

    doc = parser.parseFromString("\\ip Text");
    expect(doc.contents[0].runtimeType, IPMarker);
    expect("Text", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\ipi Text");
    expect(doc.contents[0].runtimeType, IPIMarker);
    expect("Text", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\im Text");
    expect(doc.contents[0].runtimeType, IMMarker);
    expect("Text", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\is Heading");
    expect(doc.contents[0].runtimeType, ISMarker);
    expect("Heading", (doc.contents[0] as ISMarker).heading);

    doc = parser.parseFromString("\\iq Quote");
    expect(doc.contents[0].runtimeType, IQMarker);
    expect("Quote", (doc.contents[0].contents[0] as TextBlock).text);
    expect(1, (parser.parseFromString("\\iq Quote").contents[0] as IQMarker).depth);
    expect(1, (parser.parseFromString("\\iq1 Quote").contents[0] as IQMarker).depth);
    expect(2, (parser.parseFromString("\\iq2 Quote").contents[0] as IQMarker).depth);
    expect(3, (parser.parseFromString("\\iq3 Quote").contents[0] as IQMarker).depth);

    doc = parser.parseFromString("\\imi Text");
    expect(doc.contents[0].runtimeType, IMIMarker);
    expect("Text", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\ipq Text");
    expect(doc.contents[0].runtimeType, IPQMarker);
    expect("Text", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\imq Text");
    expect(doc.contents[0].runtimeType, IMQMarker);
    expect("Text", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\ipr Text");
    expect(doc.contents[0].runtimeType, IPRMarker);
    expect("Text", (doc.contents[0].contents[0] as TextBlock).text);
  });

  test('testSectionParse', () {
    // Section Headings
    expect("Silsilah Yesus Kristus ", (parser.parseFromString("\\s Silsilah Yesus Kristus \\r (Luk. 3:23 - 38)").contents[0] as SMarker).text);
    expect("Kumpulkanlah Harta di Surga ", (parser.parseFromString("\\s3 Kumpulkanlah Harta di Surga \\r (Luk. 12:33 - 34; 11:34 - 36; 16:13)").contents[0] as SMarker).text);
    expect(1, (parser.parseFromString("\\s Silsilah Yesus Kristus \\r (Luk. 3:23 - 38)").contents[0] as SMarker).weight);
    expect(2, (parser.parseFromString("\\s2 Silsilah Yesus Kristus \\r (Luk. 3:23 - 38)").contents[0] as SMarker).weight);
    expect(3, (parser.parseFromString("\\s3 Silsilah Yesus Kristus \\r (Luk. 3:23 - 38)").contents[0] as SMarker).weight);

    // Major Section
    expect("jilid 1 ", (parser.parseFromString("\\ms1 jilid 1 \\mr (Mazmur 1 - 41)").contents[0] as MSMarker).heading);
    expect("jilid 1 ", (parser.parseFromString("\\ms2 jilid 1 \\mr (Mazmur 1 - 41)").contents[0] as MSMarker).heading);
    expect(3, (parser.parseFromString("\\ms3 jilid 1 \\mr (Mazmur 1 - 41)").contents[0] as MSMarker).weight);
    expect(1, (parser.parseFromString("\\ms jilid 1 \\mr (Mazmur 1 - 41)").contents[0] as MSMarker).weight);

    // References
    expect("(Mazmur 1 - 41)", (parser.parseFromString("\\ms2 jilid 1 \\mr (Mazmur 1 - 41)").contents[0].contents[0] as MRMarker).sectionReference);
    expect("(Mazmur 41)", (parser.parseFromString("\\ms2 jilid 1 \\mr (Mazmur 41)").contents[0].contents[0] as MRMarker).sectionReference);
    expect("(Mazmur)", (parser.parseFromString("\\ms2 jilid 1 \\mr (Mazmur)").contents[0].contents[0] as MRMarker).sectionReference);
  });

  test('testTableOfContentsParse', () {
    // Table of Contents
    expect("Keluaran", (parser.parseFromString("\\toc1 Keluaran").contents[0] as TOC1Marker).longTableOfContentsText);
    expect("Keluaran", (parser.parseFromString("\\toc2 Keluaran").contents[0] as TOC2Marker).shortTableOfContentsText);
    expect("Kel", (parser.parseFromString("\\toc3 Kel").contents[0] as TOC3Marker).bookAbbreviation);
    // Alternate Table of Contents
    expect("Keluaran", (parser.parseFromString("\\toca1 Keluaran").contents[0] as TOCA1Marker).altLongTableOfContentsText);
    expect("Keluaran", (parser.parseFromString("\\toca2 Keluaran").contents[0] as TOCA2Marker).altShortTableOfContentsText);
    expect("Kel", (parser.parseFromString("\\toca3 Kel").contents[0] as TOCA3Marker).altBookAbbreviation);
  });

  test('testMajorTitleParse', () {
    expect("Keluaran", (parser.parseFromString("\\mt1 Keluaran").contents[0] as MTMarker).title);
    expect("Keluaran", (parser.parseFromString("\\mt3 Keluaran").contents[0] as MTMarker).title);
    expect(1, (parser.parseFromString("\\mt Keluaran").contents[0] as MTMarker).weight);
    expect(2, (parser.parseFromString("\\mt2 Keluaran").contents[0] as MTMarker).weight);
  });

  test('testHeaderParse', () {
    expect("Genesis", (parser.parseFromString("\\h Genesis").contents[0] as HMarker).headerText);
    expect("", (parser.parseFromString("\\h").contents[0] as HMarker).headerText);
    expect("1 John", (parser.parseFromString("\\h 1 John").contents[0] as HMarker).headerText);
    expect("", (parser.parseFromString("\\h   ").contents[0] as HMarker).headerText);

    USFMDocument doc = parser.parseFromString("\\sp Job");
    SPMarker sp = doc.contents[0] as SPMarker;
    expect("Job", sp.speaker);
  });

  test('testChapterParse', () {
    expect(1, (parser.parseFromString("\\c 1").contents[0] as CMarker).number);
    expect(1000, (parser.parseFromString("\\c 1000").contents[0] as CMarker).number);
    expect(0, (parser.parseFromString("\\c 0").contents[0] as CMarker).number);

    // Chapter Labels
    expect("Chapter One", (parser.parseFromString("\\c 1 \\cl Chapter One").contents[0].contents[0] as CLMarker).label);
    expect("Chapter One", (parser.parseFromString("\\cl Chapter One \\c 1").contents[0] as CLMarker).label);
    expect("Chapter Two", (parser.parseFromString("\\c 1 \\cl Chapter One \\c 2 \\cl Chapter Two").contents[1].contents[0] as CLMarker).label);

    USFMDocument doc = parser.parseFromString("\\cp Q");
    expect(doc.contents[0].runtimeType, CPMarker);
    expect("Q", (doc.contents[0] as CPMarker).publishedChapterMarker);

    doc = parser.parseFromString("\\ca 53 \\ca*");
    expect(2, doc.contents.length);
    CAMarker caBegin = doc.contents[0] as CAMarker;
    CAEndMarker caEnd = doc.contents[1] as CAEndMarker;
    expect("53", caBegin.altChapterNumber);

    doc = parser.parseFromString("\\va 22 \\va*");
    expect(2, doc.contents.length);
    VAMarker vaBegin = doc.contents[0] as VAMarker;
    VAEndMarker vaEnd = doc.contents[1] as VAEndMarker;
    expect("22", vaBegin.altVerseNumber);

    doc = parser.parseFromString("\\p In the beginning God created the heavens and the earth.");
    expect(doc.contents[0].runtimeType, PMarker);
    expect("In the beginning God created the heavens and the earth.", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\pc In the beginning God created the heavens and the earth.");
    expect(doc.contents[0].runtimeType, PCMarker);
    expect("In the beginning God created the heavens and the earth.", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\p \\v 1 In the beginning God created the heavens and the earth.");
    expect(doc.contents[0].runtimeType, PMarker);
    PMarker pm = doc.contents[0] as PMarker;
    VMarker vm = pm.contents[0] as VMarker;
    expect("In the beginning God created the heavens and the earth.", (vm.contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\mi");
    expect(1, doc.contents.length);
    expect(doc.contents[0].runtimeType, MIMarker);

    doc = parser.parseFromString("\\d A Psalm of David");
    expect("A Psalm of David", (doc.contents[0] as DMarker).description);

    doc = parser.parseFromString("\\nb");
    expect(doc.contents[0].runtimeType, NBMarker);

    doc = parser.parseFromString("\\fq the Son of God");
    expect(doc.contents[0].runtimeType, FQMarker);
    expect("the Son of God", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\pi The one who scattered");
    expect(doc.contents[0].runtimeType, PIMarker);
    expect(1, doc.contents.length);
    expect("The one who scattered", (doc.contents[0].contents[0] as TextBlock).text);
    expect(1, (parser.parseFromString("\\pi").contents[0] as PIMarker).depth);
    expect(1, (parser.parseFromString("\\pi1").contents[0] as PIMarker).depth);
    expect(2, (parser.parseFromString("\\pi2").contents[0] as PIMarker).depth);
    expect(3, (parser.parseFromString("\\pi3").contents[0] as PIMarker).depth);

    doc = parser.parseFromString("\\m \\v 37 David himself called him 'Lord';");
    expect(1, doc.contents.length);
    MMarker mm = doc.contents[0] as MMarker;
    expect(1, mm.contents.length);
    vm = mm.contents[0] as VMarker;
    expect("David himself called him 'Lord';", (vm.contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\b");
    expect(1, doc.contents.length);
    expect(doc.contents[0].runtimeType, BMarker);
  });

  test('testVerseParse', () {
    expect("9", (parser.parseFromString("\\v 9 Yahweh God called to the man and said to him, \"Where are you?\"").contents[0] as VMarker).verseNumber);
    expect("26", ((parser.parseFromString("\\v 26 God said, \"Let us make man in our image, after our likeness. Let them have dominion over the fish of the sea, over the birds of the sky, over the livestock, over all the earth, and over every creeping thing that creeps on the earth.\" \\f + \\ft Some ancient copies have: \\fqa ... Over the livestock, over all the animals of the earth, and over every creeping thing that creeps on the earth \\fqa*  . \\f*").contents[0]) as VMarker).verseNumber);
    expect("0", (parser.parseFromString("\\v 0 Not in the Bible").contents[0] as VMarker).verseNumber);
    expect("1-2", (parser.parseFromString("\\v 1-2 Not in the Bible").contents[0] as VMarker).verseNumber);

    // References - Quoted book title - Parallel passage reference
    expect("(Luk. 3:23 - 38)", (parser.parseFromString("\\s Silsilah Yesus Kristus \\r (Luk. 3:23 - 38)").contents[0].contents[0].contents[0] as TextBlock).text);
    expect("(Luk. 12:33 - 34; 11:34 - 36; 16:13)", (parser.parseFromString("\\s Kumpulkanlah Harta di Surga \\r (Luk. 12:33 - 34; 11:34 - 36; 16:13)").contents[0].contents[0].contents[0] as TextBlock).text);
    expect("Kitab Peperangan TUHAN,", (parser.parseFromString("\\v 14 Itulah sebabnya kata-kata ini ditulis dalam \\bk Kitab Peperangan TUHAN,\\bk*").contents[0].contents[1] as BKMarker).bookTitle);
    expect("Psa 2.7", (parser.parseFromString("\\v 5 For God never said to any of his angels,\\q1 \"You are my Son;\\q2 today I have become your Father.\"\\rq Psa 2.7\\rq* ").contents[0].contents[3].contents[0] as TextBlock).text);

    // Closing - Selah
    expect("[[ayt.co/Mat]]", (parser.parseFromString("\\cls [[ayt.co/Mat]]").contents[0].contents[0] as TextBlock).text);
    expect("Sela", (parser.parseFromString("\\v 3 Allah datang dari negeri Teman \\q2 dan Yang Mahakudus datang dari Gunung Paran. \\qs Sela \\qs* ").contents[0].contents[1].contents[1].contents[0] as TextBlock).text);
    expect("Sela", (parser.parseFromString("\\q2 dan sampai batu yang penghabisan. \\qs Sela \\qs*").contents[0].contents[1].contents[0] as TextBlock).text);

    // Transliterated
    expect("Hades", (parser.parseFromString("\\f + \\fr 10:15 \\fk dunia orang mati \\ft Dalam bahasa Yunani adalah \\tl Hades\\tl* \\ft , tempat orang setelah meninggal.\\f*").contents[0].contents[2].contents[1].contents[0] as TextBlock).text);
    expect("TEKEL", (parser.parseFromString("\\v 27 \\tl TEKEL\\tl* :").contents[0].contents[0].contents[0] as TextBlock).text);
  });

  test('testTableParse', () {
    expect(parser.parseFromString("\\tr \\tc1 dari suku Ruben \\tcr2 12.000").contents[0].runtimeType, TableBlock);

    // Table Rows - Cells
    expect(parser.parseFromString("\\tr \\tc1 dari suku Ruben \\tcr2 12.000").contents[0].contents[0].runtimeType, TRMarker);
    expect("dari suku Ruben", (parser.parseFromString("\\tr \\tc1 dari suku Ruben \\tcr2 12.000").contents[0].contents[0].contents[0].contents[0] as TextBlock).text);
    expect("12.000", (parser.parseFromString("\\tr \\tc1 dari suku Ruben \\tcr2 12.000").contents[0].contents[0].contents[1].contents[0] as TextBlock).text);
    expect(1, (parser.parseFromString("\\tr \\tc1 dari suku Ruben \\tcr2 12.000").contents[0].contents[0].contents[0] as TCMarker).columnPosition);
    expect(2, (parser.parseFromString("\\tr \\tc2 dari suku Ruben \\tcr2 12.000").contents[0].contents[0].contents[0] as TCMarker).columnPosition);
    expect(3, (parser.parseFromString("\\tr \\tc3 dari suku Ruben \\tcr2 12.000").contents[0].contents[0].contents[0] as TCMarker).columnPosition);
    expect(1, (parser.parseFromString("\\tr \\tc1 dari suku Ruben \\tcr1 12.000").contents[0].contents[0].contents[1] as TCRMarker).columnPosition);
    expect(2, (parser.parseFromString("\\tr \\tc1 dari suku Ruben \\tcr2 12.000").contents[0].contents[0].contents[1] as TCRMarker).columnPosition);
    expect(3, (parser.parseFromString("\\tr \\tc1 dari suku Ruben \\tcr3 12.000").contents[0].contents[0].contents[1] as TCRMarker).columnPosition);

    // Test verses
    expect(parser.parseFromString("\\tc1 \\v 6 dari suku Asyer").contents[1] is VMarker, true);

    // Table Headers
    expect("dari suku Ruben", (parser.parseFromString("\\tr \\th1 dari suku Ruben \\thr2 12.000").contents[0].contents[0].contents[0].contents[0] as TextBlock).text);
    expect("12.000", (parser.parseFromString("\\tr \\th1 dari suku Ruben \\thr2 12.000").contents[0].contents[0].contents[1].contents[0] as TextBlock).text);
    expect(1, (parser.parseFromString("\\tr \\th1 dari suku Ruben \\thr2 12.000").contents[0].contents[0].contents[0] as THMarker).columnPosition);
    expect(2, (parser.parseFromString("\\tr \\th2 dari suku Ruben \\thr 12.000").contents[0].contents[0].contents[0] as THMarker).columnPosition);
    expect(3, (parser.parseFromString("\\tr \\th3 dari suku Ruben \\thr 12.000").contents[0].contents[0].contents[0] as THMarker).columnPosition);

    expect(1, (parser.parseFromString("\\tr \\th1 dari suku Ruben \\thr1 12.000").contents[0].contents[0].contents[1] as THRMarker).columnPosition);
    expect(2, (parser.parseFromString("\\tr \\th1 dari suku Ruben \\thr2 12.000").contents[0].contents[0].contents[1] as THRMarker).columnPosition);
    expect(3, (parser.parseFromString("\\tr \\th1 dari suku Ruben \\thr3 12.000").contents[0].contents[0].contents[1] as THRMarker).columnPosition);
  });

  test('testListParse', () {
    // List Items
    expect("Peres ayah Hezron.", (parser.parseFromString("\\li Peres ayah Hezron.").contents[0].contents[0] as TextBlock).text);
    expect(1, (parser.parseFromString("\\li Peres ayah Hezron.").contents[0] as LIMarker).depth);
    expect(1, (parser.parseFromString("\\li1 Peres ayah Hezron.").contents[0] as LIMarker).depth);
    expect(2, (parser.parseFromString("\\li2 Peres ayah Hezron.").contents[0] as LIMarker).depth);
    expect(3, (parser.parseFromString("\\li3 Peres ayah Hezron.").contents[0] as LIMarker).depth);
    // Verse within List
    expect("19", (parser.parseFromString("\\li Peres ayah Hezron. \\li \\v 19 Hezron ayah Ram.").contents[1].contents[0] as VMarker).verseNumber);
  });

  test('testFootnoteParse', () {
    // Footnote Text Marker
    expect("Sample Simple Footnote. ", (parser.parseFromString("\\f + \\ft Sample Simple Footnote. \\f*").contents[0].contents[0].contents[0] as TextBlock).text);

    // Footnote Caller
    expect("+", (parser.parseFromString("\\f + \\ft Sample Simple Footnote. \\f*").contents[0] as FMarker).footNoteCaller);
    expect("-", (parser.parseFromString("\\f - \\ft Sample Simple Footnote. \\f*").contents[0] as FMarker).footNoteCaller);
    expect("abc", (parser.parseFromString("\\f abc \\ft Sample Simple Footnote. \\f*").contents[0] as FMarker).footNoteCaller);

    // Footnote Alternate Translation Marker
    expect("... Over the livestock, over all the animals of the earth, and over every creeping thing that creeps on the earth ", (parser.parseFromString("\\v 26 God said, \"Let us make man in our image, after our likeness. Let them have dominion over the fish of the sea, over the birds of the sky, over the livestock, over all the earth, and over every creeping thing that creeps on the earth.\" \\f + \\ft Some ancient copies have: \\fqa ... Over the livestock, over all the animals of the earth, and over every creeping thing that creeps on the earth \\fqa*  . \\f*").contents[0].contents[1].contents[1].contents[0] as TextBlock).text);

    // Footnote Keyword
    expect("Tamar", (parser.parseFromString("\\f + \\fr 1.3 \\fk Tamar \\ft Menantu Yehuda yang akhirnya menjadi istrinya (bc. Kej. 38:1-30).\\f*").contents[0].contents[1] as FKMarker).footNoteKeyword);

    //Footnote Reference
    expect("1.3", (parser.parseFromString("\\f + \\fr 1.3 \\fk Tamar \\ft Menantu Yehuda yang akhirnya menjadi istrinya (bc. Kej. 38:1-30).\\f*").contents[0].contents[0] as FRMarker).verseReference);

    // Footnote Verse Marker - Paragraph
    expect("56", (parser.parseFromString("\\f + \\fr 9:55 \\ft Beberapa salinan Bahasa Yunani menambahkan: Dan ia berkata, Kamu tidak tahu roh apa yang memilikimu. \\fv 56 \\fv* \\ft Anak Manusia tidak datang untuk menghancurkan hidup manusia, tetapi untuk menyelamatkan mereka.\\f*").contents[0].contents[2] as FVMarker).verseCharacter);
    expect(parser.parseFromString("\\f + \\fr 17.25 \\ft Kemungkinan maksudnya adalah bebas dari kewajiban pajak seumur hidup. (bdk. NIV. NET) \\fp \\f*").contents[0].contents[2].runtimeType, FPMarker);

    // Make sure that a fqa end marker doesn't end up outside of the footnote
    expect(1, parser.parseFromString("\\v 1 Words \\f + \\fqa Thing \\fqa* \\f*").contents.length);
  });

  test('testCrossReferenceParse', () {
    // Cross Reference Caller
    expect("-", (parser.parseFromString("\\x - \\xo 11.21 \\xq Tebes \\xt \\x*").contents[0] as XMarker).crossRefCaller);

    // Cross Reference Origin
    expect("11.21", (parser.parseFromString("\\x - \\xo 11.21 \\xq Tebes \\xt \\x*").contents[0].contents[0] as XOMarker).originRef);

    // Cross Reference Target
    expect("Mrk 1.24; Luk 2.39; Jhn 1.45.", (parser.parseFromString("\\x - \\xo 11.21 \\xq Tebes \\xt Mrk 1.24; Luk 2.39; Jhn 1.45.\\x*").contents[0].contents[2].contents[0] as TextBlock).text);

    // Cross Reference Quotation
    expect("Tebes", (parser.parseFromString("\\x - \\xo 11.21 \\xq Tebes \\xt \\x*").contents[0].contents[1].contents[0] as TextBlock).text);
  });

  test('testVerseCharacterParse', () {
    expect("1a", (parser.parseFromString("\\v 1 \\vp 1a \\vp* This is not Scripture").contents[0].contents[0] as VPMarker).verseCharacter);
    expect("2b", (parser.parseFromString("\\v 2 \\vp 2b \\vp* This is not Scripture").contents[0].contents[0] as VPMarker).verseCharacter);
    expect("asdf", (parser.parseFromString("\\v 1 \\vp asdf \\vp* This is not Scripture").contents[0].contents[0] as VPMarker).verseCharacter);
  });

  test('testTranslationNotesParse', () {
    // Translator’s addition
    expect("dan mencari TUHAN semesta alam!", (parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi kepada penduduk kota yang lain sambil berkata,\\q2 'Mari kita pergi memohon belas kasihan TUHAN\\q1 \\add dan mencari TUHAN semesta alam!\\add * ").contents[0].contents[3].contents[0] as TextBlock).text);
    expect("(malaikat)", (parser.parseFromString("\\v 1 “Pada tahun pertama pemerintahan Darius, orang Media, aku bangkit untuk menguatkan dan melindungi dia.” \\add (malaikat)\\add* dari Persia.").contents[0].contents[1].contents[0] as TextBlock).text);
  });

  test('testWordEntryParse', () {
    // Within Footnotes
    expect("Berhala", (parser.parseFromString("\\f + \\fr 3:5 \\fk berhala \\ft Lih. \\w Berhala \\w* di Daftar Istilah.\\f*").contents[0].contents[2].contents[1] as WMarker).term);

    // Word Entry Attributes
    expect("Berhala", (parser.parseFromString("\\f + \\fr 3:5 \\fk berhala \\ft Lih. \\w Berhala|Berhala \\w* di Daftar Istilah.\\f*").contents[0].contents[2].contents[1] as WMarker).attributes["lemma"]);
    expect("grace", (parser.parseFromString("\\f + \\fr 3:5 \\fk berhala \\ft Lih. \\w gracious|lemma=\"grace\" \\w* di Daftar Istilah.\\f*").contents[0].contents[2].contents[1] as WMarker).attributes["lemma"]);
    expect("G5485", (parser.parseFromString("\\f + \\fr 3:5 \\fk berhala \\ft Lih. \\w gracious|lemma=\"grace\" strong=\"G5485\" \\w* di Daftar Istilah.\\f*").contents[0].contents[2].contents[1] as WMarker).attributes["strong"]);
    expect("H1234,G5485", (parser.parseFromString("\\f + \\fr 3:5 \\fk berhala \\ft Lih. \\w gracious|strong=\"H1234,G5485\" \\w* di Daftar Istilah.\\f*").contents[0].contents[2].contents[1] as WMarker).attributes["strong"]);
    expect("gnt5:51.1.2.1", (parser.parseFromString("\\f + \\fr 3:5 \\fk berhala \\ft Lih. \\w gracious|lemma=\"grace\" srcloc=\"gnt5:51.1.2.1\" \\w* di Daftar Istilah.\\f*").contents[0].contents[2].contents[1] as WMarker).attributes["srcloc"]);
  });

  test('testPoetryParse', () {
    USFMDocument doc = parser.parseFromString("\\q Quote");
    expect(doc.contents[0].runtimeType, QMarker);
    expect("Quote", (doc.contents[0].contents[0] as TextBlock).text);
    expect(1, (parser.parseFromString("\\q Quote").contents[0] as QMarker).depth);
    expect(1, (parser.parseFromString("\\q1 Quote").contents[0] as QMarker).depth);
    expect(2, (parser.parseFromString("\\q2 Quote").contents[0] as QMarker).depth);
    expect(3, (parser.parseFromString("\\q3 Quote").contents[0] as QMarker).depth);

    doc = parser.parseFromString("\\qr God's love never fails.");
    expect(doc.contents[0].runtimeType, QRMarker);
    expect("God's love never fails.", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\qc Amen! Amen!");
    expect(doc.contents[0].runtimeType, QCMarker);
    expect("Amen! Amen!", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\qd For the director of music.");
    expect(doc.contents[0].runtimeType, QDMarker);
    expect("For the director of music.", (doc.contents[0].contents[0] as TextBlock).text);

    doc = parser.parseFromString("\\qac P\\qac*");
    expect(2, doc.contents.length);
    QACMarker qac = doc.contents[0] as QACMarker;
    QACEndMarker qacEnd = doc.contents[1] as QACEndMarker;
    expect("P", qac.acrosticLetter);

    doc = parser.parseFromString("\\qm God is on your side.");
    expect(1, doc.contents.length);
    expect(doc.contents[0].runtimeType, QMMarker);
    expect("God is on your side.", (doc.contents[0].contents[0] as TextBlock).text);
    expect(1, (parser.parseFromString("\\qm God is on your side.").contents[0] as QMMarker).depth);
    expect(1, (parser.parseFromString("\\qm1 God is on your side.").contents[0] as QMMarker).depth);
    expect(2, (parser.parseFromString("\\qm2 God is on your side.").contents[0] as QMMarker).depth);
    expect(3, (parser.parseFromString("\\qm3 God is on your side.").contents[0] as QMMarker).depth);

    doc = parser.parseFromString("\\qa Aleph");
    expect(doc.contents[0].runtimeType, QAMarker);
    QAMarker qa = doc.contents[0] as QAMarker;
    expect("Aleph", qa.heading);
  });

  test('testCharacterStylingParse', () {
    expect(parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\em Emphasis \\em* ").contents[0].contents[1].runtimeType, EMMarker);
    expect(parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\bd Boldness \\bd* ").contents[0].contents[1].runtimeType, BDMarker);
    expect(parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\bdit Boldness and Italics \\bdit* ").contents[0].contents[1].runtimeType, BDITMarker);
    expect(parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\it Italics \\it* ").contents[0].contents[1].runtimeType, ITMarker);
    expect(parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\sup Superscript \\sup* ").contents[0].contents[1].runtimeType, SUPMarker);
    expect(parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\nd Name of Diety \\nd* ").contents[0].contents[1].runtimeType, NDMarker);
    expect(parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\sc Small Caps \\sc* ").contents[0].contents[1].runtimeType, SCMarker);
    expect(parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\no Normal \\no* ").contents[0].contents[1].runtimeType, NOMarker);

    // Text Content
    expect("Emphasis", (parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\em Emphasis \\em* ").contents[0].contents[1].contents[0] as TextBlock).text);
    expect("Boldness", (parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\bd Boldness \\bd* ").contents[0].contents[1].contents[0] as TextBlock).text);
    expect("Boldness and Italics", (parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\bdit Boldness and Italics \\bdit* ").contents[0].contents[1].contents[0] as TextBlock).text);
    expect("Italics", (parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\it Italics \\it* ").contents[0].contents[1].contents[0] as TextBlock).text);
    expect("Superscript", (parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\sup Superscript \\sup* ").contents[0].contents[1].contents[0] as TextBlock).text);
    expect("Name of Diety", (parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\nd Name of Diety \\nd* ").contents[0].contents[1].contents[0] as TextBlock).text);
    expect("Small Caps", (parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\sc Small Caps \\sc* ").contents[0].contents[1].contents[0] as TextBlock).text);
    expect("Normal", (parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\no Normal \\no* ").contents[0].contents[1].contents[0] as TextBlock).text);
  });

  test('testUnknownMarkerParse', () {
    expect(" what is yy?", (parser.parseFromString("\\yy what is yy?").contents[0] as UnknownMarker).parsedValue);
    expect("yy", (parser.parseFromString("\\yy what is yy?").contents[0] as UnknownMarker).parsedIdentifier);
    expect(" what is z?", (parser.parseFromString("\\z what is z?").contents[0] as UnknownMarker).parsedValue);
    expect("z", (parser.parseFromString("\\z what is z?").contents[0] as UnknownMarker).parsedIdentifier);
    expect(" what is 1?", (parser.parseFromString("\\1 what is 1?").contents[0] as UnknownMarker).parsedValue);
    expect("1", (parser.parseFromString("\\1  what is 1?").contents[0] as UnknownMarker).parsedIdentifier);
  });

  test('testWhitespacePreserve', () {
    String verseText = "This is verse text ";
    String otherVerseText = " after the word";
    var output = parser.parseFromString("\\v 1 $verseText\\bd Bold \\bd*$otherVerseText");
    expect(verseText, (output.contents[0].contents[0] as TextBlock).text);
    expect(otherVerseText, (output.contents[0].contents[3] as TextBlock).text);
  });

  /// Verify that QMarker and VMarker nesting is handeld correctly
  test('testVersePoetryNesting', () {
    String verseText = "\\q \\v 1 This is verse one \\q another poetry \\v 2 second verse";
    var output = parser.parseFromString(verseText);
    expect(2, output.contents.length);
    expect(output.contents[0] is QMarker, true);
    expect(output.contents[0].contents[0] is VMarker, true);
    expect(output.contents[0].contents[0].contents[1] is QMarker, true);
    expect(output.contents[1] is VMarker, true);

    String secondVerseText = "\\v 1 This is verse one \\q another poetry \\v 2 second verse";

    output = parser.parseFromString(secondVerseText);
    expect(2, output.contents.length);
    expect(output.contents[0] is VMarker, true);
    expect(output.contents[0].contents[1] is QMarker, true);
    expect(output.contents[1] is VMarker, true);
  });

  /// Verify that an empty QMarker gets pushed back out to being a block QMarker
  test('testEmptyQMarkerInVerse', () {
    String verseText = "\\v 1 This is verse one \\q \\v 2 second verse";
    var output = parser.parseFromString(verseText);
    expect(2, output.contents.length);
    expect(output.contents[0] is VMarker, true);
    QMarker qMarker = output.contents[1] as QMarker;
    expect(output.contents[1] is QMarker && qMarker.isPoetryBlock, true);
    expect(output.contents[1].contents[0] is VMarker, true);
  });

  test('testBadChapterHandling', () {
    String verseText = "\\c 1 Bad text here";
    var output = parser.parseFromString(verseText);
    expect(1, output.contents.length);
    expect(output.contents[0].contents[0] is TextBlock, true);
    expect(1, (output.contents[0] as CMarker).number);
    expect("Bad text here", (output.contents[0].contents[0] as TextBlock).text);
  });

  test('testNoChapterNumberingHandling', () {
    String verseText = "\\c \\v 1 Bad text here";
    var output = parser.parseFromString(verseText);
    expect(1, output.contents.length);
    expect(output.contents[0] is CMarker, true);
    expect(0, (output.contents[0] as CMarker).number);
  });

  test('testNoChapterNumberingAndTextHandling', () {
    String verseText = "\\c Text Block \\v 1 Bad text here";
    var output = parser.parseFromString(verseText);
    expect(1, output.contents.length);
    expect(output.contents[0] is CMarker, true);
    expect(0, (output.contents[0] as CMarker).number);
    expect(2, output.contents[0].contents.length);
    expect(output.contents[0].contents[0] is TextBlock, true);
    expect("Text Block", (output.contents[0].contents[0] as TextBlock).text);
  });

  test('testCorrectFQAEndMarkerNesting', () {
    String verseText = "\\f + \\ft Text \\fqa Other \\fqa* More";
    var output = parser.parseFromString(verseText);
    expect(4, output.contents[0].contents.length);
  });

  /// Verify that if a \q marker is at the end of a string it doesn't throw an exception
  test('testTrailingEmptyQMarker', () {
    String verseText = "\\q";
    var output = parser.parseFromString(verseText);
    expect(output.contents[0] is QMarker, true);
  });

  test('testIntroParagraphs', () {
    String text = "\\ip \\rq \\rq* \\ie";
    var output = parser.parseFromString(text);
    expect(output.contents[0] is IPMarker, true);
    expect(output.contents[0].contents[0] is RQMarker, true);
    expect(output.contents[0].contents[1] is RQEndMarker, true);
    expect(output.contents[0].contents[3] is IEMarker, true);
  });

  test('testNewlineInTextBlock', () {
    String verseText = """This is text 
with a newline""";
    String usfm = "\\v 1 $verseText";
    var output = parser.parseFromString(usfm);
    expect(output.contents[0] is VMarker, true);
    expect(output.contents[0].contents[0] is TextBlock, true);
    expect(verseText, (output.contents[0].contents[0] as TextBlock).text);
  });

  test('testFigureParse', () {
    //PRE 3.0 TESTS
    //Description;
    expect("description", (parser.parseFromString("\\fig description|filepath|width|location|copyright|caption caption caption|reference\\fig*").contents[0] as FIGMarker).description);
    //FilePath;
    expect("filepath", (parser.parseFromString("\\fig description| filepath|width|location|copyright|caption caption caption|reference\\fig*").contents[0] as FIGMarker).filePath);
    //Width;
    expect("width", (parser.parseFromString("\\fig description|filepath |width|location|copyright|caption caption caption|reference\\fig*").contents[0] as FIGMarker).width);
    //Location;
    expect("location", (parser.parseFromString("\\fig description|filepath|width | location|copyright|caption caption caption|reference\\fig*").contents[0] as FIGMarker).location);
    //Copyright;
    expect("copyright", (parser.parseFromString("\\fig description|filepath|width|location|copyright |caption caption caption|reference\\fig*").contents[0] as FIGMarker).copyright);
    //Caption;
    expect("caption caption caption", (parser.parseFromString("\\fig description|filepath|width|location|copyright|caption caption caption|reference\\fig*").contents[0] as FIGMarker).caption);
    //Reference;
    expect("reference", (parser.parseFromString("\\fig description|filepath|width|location|copyright|caption caption caption | reference\\fig*").contents[0] as FIGMarker).reference);

    //3.0 TESTS
    //Caption;
    expect("caption caption caption", (parser.parseFromString("\\fig caption caption caption | alt=\"description\" src=\"filepath\" size=\"width\" loc =\"location\" " "copy= \"copyright\"  ref = \"reference\"\\fig*").contents[0] as FIGMarker).caption);
    //Description;
    expect("description", (parser.parseFromString("\\fig caption caption caption | alt=\"description\" src=\"filepath\" size=\"width\" loc =\"location\" " "copy= \"copyright\"  ref = \"reference\"\\fig*").contents[0] as FIGMarker).description);
    //FilePath;
    expect("filepath", (parser.parseFromString("\\fig caption caption caption | alt=\"description\" src=\"filepath\" size=\"width\" loc =\"location\" " "copy= \"copyright\"  ref = \"reference\"\\fig*").contents[0] as FIGMarker).filePath);
    //Width;
    expect("width", (parser.parseFromString("\\fig caption caption caption | alt=\"description\" src=\"filepath\" size=\"width\" loc =\"location\" " "copy= \"copyright\"  ref = \"reference\"\\fig*").contents[0] as FIGMarker).width);
    //Location;
    expect("location", (parser.parseFromString("\\fig caption caption caption | alt=\"description\" src=\"filepath\" size=\"width\" loc =\"location\" " "copy= \"copyright\"  ref = \"reference\"\\fig*").contents[0] as FIGMarker).location);
    //Copyright;
    expect("copyright", (parser.parseFromString("\\fig caption caption caption | alt=\"description\" src=\"filepath\" size=\"width\" loc =\"location\" " "copy= \"copyright\"  ref = \"reference\"\\fig*").contents[0] as FIGMarker).copyright);
    //Reference;
    expect("reference", (parser.parseFromString("\\fig caption caption caption | alt=\"description\" src=\"filepath\" size=\"width\" loc =\"location\" " "copy= \"copyright\"  ref = \"reference\"\\fig*").contents[0] as FIGMarker).reference);



    // Cross Reference Caller
    expect("-", (parser.parseFromString("\\x - \\xo 11.21 \\xq Tebes \\xt \\x*").contents[0] as XMarker).crossRefCaller);

    // Cross Reference Origin
    expect("11.21", (parser.parseFromString("\\x - \\xo 11.21 \\xq Tebes \\xt \\x*").contents[0].contents[0] as XOMarker).originRef);

    // Cross Reference Target
    expect("Mrk 1.24; Luk 2.39; Jhn 1.45.", (parser.parseFromString("\\x - \\xo 11.21 \\xq Tebes \\xt Mrk 1.24; Luk 2.39; Jhn 1.45.\\x*").contents[0].contents[2].contents[0] as TextBlock).text);

    // Cross Reference Quotation
    expect("Tebes", (parser.parseFromString("\\x - \\xo 11.21 \\xq Tebes \\xt \\x*").contents[0].contents[1].contents[0] as TextBlock).text);
  });
  test('testSpacingBetweenWords', () {
    var parsed = parser.parseFromString("\\v 21 Penduduk kota yang satu akan pergi \\em Emphasis \\em* \\em Second \\em*");
    expect(" ", (parsed.contents[0].contents[3] as TextBlock).text);
  });
  test('testIgnoreUnkownMarkers', () {
    parser = USFMParser([], true);
    var parsed = parser.parseFromString("\\v 1 Text \\unkown more text \\bd Text \\bd*");
    expect(1, parsed.contents.length);
    expect(3, parsed.contents[0].contents.length);
  });

  test('testIgnoreParentsWhenGettingChildMarkers', () {
    var ignoredParents = [FMarker];
    var result = parser.parseFromString("\\v 1 Text blocks \\f \\ft Text \\f*");
    expect(2, result.getChildMarkers<TextBlock>().length);
    expect(1, result.getChildMarkers<TextBlock>(ignoredParents).length);
    var verse = result.getChildMarkers<VMarker>()[0];
    expect(2, verse.getChildMarkers<TextBlock>().length);
    expect(1, verse.getChildMarkers<TextBlock>(ignoredParents).length);
    expect(0, verse.getChildMarkers<TextBlock>([VMarker]).length);
  });

  test('testGetChildMarkers', () {
    var result = parser.parseFromString("\\c 1 \\v 1 Text blocks \\f \\ft Text \\f* \\v 2 Third block \\c 2 \\v 1 Fourth block");
    var markers = result.getChildMarkers<VMarker>();
    expect(3, markers.length);
    expect("1", markers[0].verseNumber);
    expect("2", markers[1].verseNumber);
    expect("1", markers[2].verseNumber);
  });

  test('testGetHierarchyToMarker', () {
    var document = USFMDocument();
    var chapter = CMarker();
    chapter.number = 1;
    var verse = VMarker();
    verse.verseNumber = "1";
    var textblock = TextBlock("Hello world");
    document.insertMultiple(<Marker>[chapter, verse, textblock]);
    var result = document.getHierarchyToMarker(textblock);
    expect(document, result[0]);
    expect(chapter, result[1]);
    expect(verse, result[2]);
    expect(textblock, result[3]);

    document = parser.parseFromString("\\c 1\\p \\v 1 Before \\f + \\ft In footnote \\f* After footnore");

    var markers = document.getChildMarkers<TextBlock>().toList();
    var baseMarker = document.contents[0].contents[0].contents[0];
    var hierarchy = baseMarker.getHierarchyToMarker(markers[0]).toList();
    _checkTypeList([VMarker, TextBlock], hierarchy);
    hierarchy = baseMarker.getHierarchyToMarker(markers[1]).toList();
    _checkTypeList([VMarker, FMarker, FTMarker, TextBlock], hierarchy);
    hierarchy = baseMarker.getHierarchyToMarker(markers[2]).toList();
    _checkTypeList([VMarker, TextBlock], hierarchy);
  });

  test('testGetHierarchyToMarkerWithNonExistantMarker', () {
    var document = USFMDocument();
    var chapter = CMarker();
    chapter.number = 1;
    var verse = VMarker();
    verse.verseNumber = "1";
    var textblock = TextBlock("Hello world");
    var secondBlock = TextBlock("Hello again");
    document.insertMultiple([chapter, verse, textblock]);
    var result = document.getHierarchyToMarker(secondBlock);
    expect(0, result.length);
  });

  test('testGetHierarchyToMultipleMarkers', () {
    var document = USFMDocument();
    var chapter = CMarker();
    chapter.number = 1;
    var verse = VMarker();
    verse.verseNumber = "1";
    var textblock = TextBlock("Hello world");
    var footnote = FMarker();
    var footnoteText = FTMarker();
    var footnoteEndMarker = FEndMarker();
    var textInFootnote = TextBlock("Text in footnote");
    var secondBlock = TextBlock("Hello again");
    var nonExistant = VMarker();
    document.insertMultiple(<Marker>[chapter, verse, textblock, footnote, footnoteText, textInFootnote, footnoteEndMarker, secondBlock]);
    var result = document.getHierachyToMultipleMarkers([textblock, secondBlock, nonExistant, textInFootnote]);
    expect(document, result[textblock]![0]);
    expect(chapter, result[textblock]![1]);
    expect(verse, result[textblock]![2]);
    expect(textblock, result[textblock]![3]);
    expect(document, result[secondBlock]![0]);
    expect(chapter, result[secondBlock]![1]);
    expect(verse, result[secondBlock]![2]);
    expect(secondBlock, result[secondBlock]![3]);
    expect(0, result[nonExistant]!.length);
    expect(document, result[textInFootnote]![0]);
    expect(chapter, result[textInFootnote]![1]);
    expect(verse, result[textInFootnote]![2]);
    expect(footnote, result[textInFootnote]![3]);
    expect(footnoteText, result[textInFootnote]![4]);
  });
}
