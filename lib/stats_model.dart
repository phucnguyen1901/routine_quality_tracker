import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Convert Stats object to a Map that can be encoded to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'time': time,
      'moodIndex': moodIndex,
      'sleepStatsIndex': sleepStatsIndex,
      'percent': percent,
      'activitiesTracker': activitiesTracker,
      'plansTracker': plansTracker,
      'gratitudeJournal': gratitudeJournal,
    };
  }

  Stats copyWith({
    DateTime? date,
    String? time,
    int? moodIndex,
    int? sleepStatsIndex,
    double? percent,
    List<String>? activitiesTracker,
    List<String>? plansTracker,
    List<String>? gratitudeJournal,
  }) {
    return Stats(
      date: date ?? this.date,
      time: time ?? this.time,
      moodIndex: moodIndex ?? this.moodIndex,
      sleepStatsIndex: sleepStatsIndex ?? this.sleepStatsIndex,
      percent: percent ?? this.percent,
      activitiesTracker: activitiesTracker ?? this.activitiesTracker,
      plansTracker: plansTracker ?? this.plansTracker,
      gratitudeJournal: gratitudeJournal ?? this.gratitudeJournal,
    );
  }

  // Factory method to create a Stats object from a Map
  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      date: DateTime.parse(json['date']),
      time: json['time'],
      moodIndex: json['moodIndex'],
      sleepStatsIndex: json['sleepStatsIndex'],
      percent: json['percent'],
      activitiesTracker: List<String>.from(json['activitiesTracker']),
      plansTracker: List<String>.from(json['plansTracker']),
      gratitudeJournal: List<String>.from(json['gratitudeJournal']),
    );
  }

  @override
  String toString() {
    return 'Stats {'
        ' date: $date,'
        ' time: $time,'
        ' moodIndex: $moodIndex,'
        ' sleepStatsIndex: $sleepStatsIndex,'
        ' percent: $percent,'
        ' activitiesTracker: $activitiesTracker,'
        ' plansTracker: $plansTracker,'
        ' gratitudeJournal: $gratitudeJournal'
        '}';
  }
}
