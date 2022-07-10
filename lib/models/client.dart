class Client {
  static const String _clientIdKey = 'client_id';
  static const String _tourIdKey = 'tour_id';
  static const String _nameKey = 'name';
  static const String _hasPaidKey = 'has_paid';
  static const String _quantityOfTicketsKey = 'quantity_of_tickets';

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
