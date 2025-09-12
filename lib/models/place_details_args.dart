class PlaceDetailsArgs {
  final String title;
  final String kind;        // "Hotel", "Apartment"...
  final String city;        // "Vienna, Austria"
  final int price;          // 599
  final String unitLabel;   // "Night" ili "Person"
  final double rating;      // 4.7
  final int reviews;        // 2498
  final bool selectable;    // 👈 ako je true, pokaži "Select for Trip"

  const PlaceDetailsArgs({
    required this.title,
    required this.kind,
    required this.city,
    required this.price,
    required this.unitLabel,
    required this.rating,
    required this.reviews,
    this.selectable = false,
  });
}
