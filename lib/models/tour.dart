class Tour {
  static const String tourIdKey = 'tour_id';
  static const String nameKey = 'name';
  static const String startDateKey = 'start_date';
  static const String endDateKey = 'end_date';
  static const String destinationKey = 'destination';
  static const String wayOfTravelingKey = 'way_of_traveling';

  final int? tourId;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final String destination;
  final String wayOfTraveling;

  const Tour({
    required this.tourId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.wayOfTraveling,
  });

  factory Tour.fromMap({required Map<String, dynamic> map}) => Tour(
        tourId: map[tourIdKey],
        name: map[nameKey],
        startDate: DateTime.tryParse(map[startDateKey]),
        endDate: DateTime.tryParse(map[endDateKey]),
        destination: map[destinationKey],
        wayOfTraveling: map[wayOfTravelingKey],
      );
}
