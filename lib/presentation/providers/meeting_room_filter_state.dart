// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meeting_room_filter_state.g.dart';

@riverpod
class MeetingRoomFilterState extends _$MeetingRoomFilterState {
  @override
  MeetingRoomFilter build() {
    return MeetingRoomFilter(
      capacity: 0,
      date: DateTime.now(),
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      canVideoConference: false,
    );
  }

  void update(MeetingRoomFilter newState) => state = newState;
}

class MeetingRoomFilter {
  final int capacity;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final bool canVideoConference;

  MeetingRoomFilter({
    this.capacity = 4,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.canVideoConference = false,
  });

  @override
  bool operator ==(covariant MeetingRoomFilter other) {
    if (identical(this, other)) return true;

    return other.capacity == capacity &&
        other.date == date &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.canVideoConference == canVideoConference;
  }

  @override
  int get hashCode {
    return capacity.hashCode ^ date.hashCode ^ startTime.hashCode ^ endTime.hashCode ^ canVideoConference.hashCode;
  }
}
