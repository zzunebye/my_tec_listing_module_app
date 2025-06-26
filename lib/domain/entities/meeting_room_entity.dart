class MeetingRoomEntity {
  final String roomCode;
  final String roomName;
  final String centreCode;
  final String centreName;
  final String centreAddress;
  final String floor;
  final int capacity;
  final bool hasVideoConference;
  final List<String> amenities;
  final List<String>? photoUrls;
  final bool isBookable;
  final bool isAvailable;
  final double? finalPrice;
  final String? currencyCode;
  final String? bestPricingStrategyName;
  final bool? isWithinOfficeHour;
  final double? distance;

  MeetingRoomEntity({
    required this.roomCode,
    required this.roomName,
    required this.centreCode,
    required this.centreName,
    required this.centreAddress,
    required this.floor,
    required this.capacity,
    required this.hasVideoConference,
    required this.amenities,
    this.photoUrls,
    required this.isBookable,
    required this.isAvailable,
    this.finalPrice,
    this.currencyCode,
    this.bestPricingStrategyName,
    this.isWithinOfficeHour,
    this.distance,
  });

  bool get isUnavailable => isWithinOfficeHour == false || isAvailable == false || isBookable == false;
}
