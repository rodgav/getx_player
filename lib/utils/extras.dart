String parseDuration(Duration duration) {
  String twoDigits(int v) {
    return v >= 10 ? '$v' : '0$v';
  }

  final minutes = twoDigits(duration.inMinutes);
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return '$minutes:$seconds';
}
