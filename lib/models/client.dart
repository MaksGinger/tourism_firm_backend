class Client {
  static const String _clientIdKey = 'clientId';
  static const String _tourIdKey = 'tourId';
  static const String _nameKey = 'name';
  static const String _hasPaidKey = 'hasPaid';
  static const String _quantityOfTicketsKey = 'quantityOfTickets';

  final int clientId;
  final int tourId;
  final String name;
  final bool hasPaid;
  final int quantityOfTickets;

  const Client({
    required this.clientId,
    required this.tourId,
    required this.name,
    required this.hasPaid,
    required this.quantityOfTickets,
  });

  factory Client.fromMap({required Map<String, dynamic> map}) => Client(
        clientId: map[_clientIdKey],
        tourId: map[_tourIdKey],
        name: map[_nameKey],
        hasPaid: map[_hasPaidKey],
        quantityOfTickets: map[_quantityOfTicketsKey],
      );
}
