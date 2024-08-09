extension IntX on int {
  String getHumanReadableDuration({bool forceShowSign = false, bool forceConsistentPadding = false}) {
    final duration = Duration(seconds: abs());
    final minutesString = duration.inMinutes.toString().padLeft(2, '0');
    final secondsString = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final leading = duration.isNegative
        ? "-"
        : forceShowSign && duration.inSeconds > 0
            ? "+"
            : "";
    if (forceConsistentPadding) {
      final forcedLeading = leading.isEmpty ? " " : leading;
      return "$forcedLeading$minutesString:$secondsString";
    }
    return "$leading$minutesString:$secondsString";
  }
}
