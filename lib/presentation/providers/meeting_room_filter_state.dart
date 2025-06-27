import 'package:my_tec_listing_module_app/presentation/providers/current_city_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meeting_room_filter_state.g.dart';

@riverpod
class MeetingRoomFilterState extends _$MeetingRoomFilterState {
  @override
  MeetingRoomFilter build() {
    final currentCity = ref.watch(currentCityStateProvider);
    return MeetingRoomFilter.defaultSettings();
  }

  void update(MeetingRoomFilter newState) {
    state = newState;
  }

  void reset() => state = MeetingRoomFilter.defaultSettings();
}

class MeetingRoomFilter {
  final int capacity;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  // TODO: update to be requiredVideoConference
  final bool canVideoConference;
  final bool requiredWindow;
  final List<String> centres;

  MeetingRoomFilter({
    this.capacity = 4,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.canVideoConference = false,
    this.requiredWindow = false,
    this.centres = const [],
  });

  MeetingRoomFilter.defaultSettings()
    : this(
        capacity: 4,
        date: (() {
          final now = DateTime.now();
          if (now.hour >= 18) {
            return DateTime(now.year, now.month, now.day + 1);
          }
          return DateTime(now.year, now.month, now.day);
        })(),
        startTime: (() {
          final now = DateTime.now();
          if (now.hour >= 18 || now.hour < 7) {
            return DateTime(now.year, now.month, now.day + 1, 10, 0);
          }
          final minutesToAdd = (30 - now.minute % 30) % 30;
          return DateTime(now.year, now.month, now.day, now.hour, now.minute + minutesToAdd);
        })(),
        endTime: (() {
          final now = DateTime.now();
          if (now.hour >= 18 || now.hour < 7) {
            return DateTime(now.year, now.month, now.day + 1, 10, 30);
          }
          final minutesToAdd = (30 - now.minute % 30) % 30;
          return DateTime(now.year, now.month, now.day, now.hour, now.minute + minutesToAdd + 30);
        })(),
        canVideoConference: false,
        centres: [],
      );

  @override
  bool operator ==(covariant MeetingRoomFilter other) {
    if (identical(this, other)) return true;

    return other.capacity == capacity &&
        other.date == date &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.canVideoConference == canVideoConference &&
        other.requiredWindow == requiredWindow &&
        other.centres == centres;
  }

  @override
  int get hashCode {
    return capacity.hashCode ^
        date.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        canVideoConference.hashCode ^
        requiredWindow.hashCode ^
        centres.hashCode;
  }

  MeetingRoomFilter copyWith({
    int? capacity,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    bool? canVideoConference,
    bool? requiredWindow,
    // should be a code of the centres
    List<String>? centres,
  }) {
    return MeetingRoomFilter(
      capacity: capacity ?? this.capacity,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      canVideoConference: canVideoConference ?? this.canVideoConference,
      requiredWindow: requiredWindow ?? this.requiredWindow,
      centres: centres ?? this.centres,
    );
  }
}
