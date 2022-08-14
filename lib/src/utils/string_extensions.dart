extension WhitespaceChecker on String? {
  bool isNullOrWhiteSpace() {
    if (this == null) {
      return true;
    } else if (this!.trim() == "") {
      return true;
    } else {
      return false;
    }
  }

  bool isNullOrEmpty() {
    if (this == null || this == "") {
      return true;
    } else {
      return false;
    }
  }
}
