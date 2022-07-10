class TourAgent {
  static const String _agentIdKey = 'agent_id';
  static const String _tourIdKey = 'tour_id';
  static const String _nameKey = 'name';
  static const String _experienceKey = 'experience';
  static const String _positionKey = 'position';

  final int agentId;
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
        agentId: map[_agentIdKey],
        tourId: map[_tourIdKey],
        name: map[_nameKey],
        experience: map[_experienceKey],
        position: map[_positionKey],
      );
}
