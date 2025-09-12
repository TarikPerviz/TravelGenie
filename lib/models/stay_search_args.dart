import 'package:flutter/material.dart';

class StaySearchArgs {
  final String location;
  final DateTimeRange? range;
  final int people;

  const StaySearchArgs({
    required this.location,
    required this.range,
    required this.people,
  });
}
