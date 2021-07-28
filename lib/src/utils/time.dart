
class Time {
  static String getDuration(Duration duration) {
    int seconds = duration.inSeconds;
    if (seconds < 60) {
      return '00:${getTime(seconds)}';
    }

    int minutes = duration.inMinutes;
    seconds = seconds % 60;

    return '${getTime(minutes)}:${getTime(seconds)}';
  }

  static String getTime(int time) {
    return (time < 10) ? '0$time' : '$time';
  }
}