class Client {
  static const String clientIdKey = 'client_id';
  static const String tourIdKey = 'tour_id';
  static const String nameKey = 'name';
  static const String hasPaidKey = 'has_paid';
  static const String quantityOfTicketsKey = 'quantity_of_tickets';

  final int? clientId;
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
        clientId: map[clientIdKey],
        tourId: map[tourIdKey],
        name: map[nameKey],
        hasPaid: map[hasPaidKey],
        quantityOfTickets: map[quantityOfTicketsKey],
      );
}
