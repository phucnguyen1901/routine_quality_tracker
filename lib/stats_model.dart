class Stats {
  final DateTime date;
  final String time;
  final int moodIndex;
  final int sleepStatsIndex;
  final double percent;
  final List<String> activitiesTracker;
  final List<String> plansTracker;
  final List<String> gratitudeJournal;

  Stats({
    required this.date,
    required this.time,
    required this.moodIndex,
    required this.sleepStatsIndex,
    required this.percent,
    required this.activitiesTracker,
    required this.plansTracker,
    required this.gratitudeJournal,
  });
}
