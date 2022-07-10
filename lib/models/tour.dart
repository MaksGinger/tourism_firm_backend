class Tour {
  static const String _tourIdKey = 'tourId';
  static const String _nameKey = 'name';
  static const String _startDateKey = 'startDate';
  static const String _endDateKey = 'endDate';
  static const String _destinationKey = 'destination';
  static const String _wayOfTravelingKey = 'wayOfTraveling';

  final int tourId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
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
        tourId: map[_tourIdKey],
        name: map[_nameKey],
        startDate: map[_startDateKey],
        endDate: map[_endDateKey],
        destination: map[_destinationKey],
        wayOfTraveling: map[_wayOfTravelingKey],
      );
}
