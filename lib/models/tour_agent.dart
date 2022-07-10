class TourAgent {
  static const String agentIdKey = 'agent_id';
  static const String tourIdKey = 'tour_id';
  static const String nameKey = 'name';
  static const String experienceKey = 'experience';
  static const String positionKey = 'position';

  final int? agentId;
  final int tourId;
  final String name;
  final int experience;
  final String position;

  const TourAgent({
    required this.agentId,
    required this.tourId,
    required this.name,
    required this.experience,
    required this.position,
  });

  factory TourAgent.fromMap({required Map<String, dynamic> map}) => TourAgent(
        agentId: map[agentIdKey],
        tourId: map[tourIdKey],
        name: map[nameKey],
        experience: map[experienceKey],
        position: map[positionKey],
      );
}
