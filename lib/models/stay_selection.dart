// API-ready model za odabrani smještaj
class StaySelection {
  final String title;
  final String city;
  final String country;

  const StaySelection({
    required this.title,
    required this.city,
    required this.country,
  });

  String get subtitle => '$city, $country';
}
