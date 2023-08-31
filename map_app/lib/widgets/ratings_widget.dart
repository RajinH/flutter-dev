import 'package:flutter/material.dart';

class RatingsWidget extends StatelessWidget {
  const RatingsWidget({super.key, required this.rating});

  final double rating;

  List<Icon> generateStars(double rating) {
    List<Icon> stars = [];
    int fullStars = rating.floor();
    int halfStars = 0;

    for (var i = 0; i < fullStars; i++) {
      stars.add(const Icon(
        Icons.star,
        color: Colors.blueAccent,
      ));
    }

    if (fullStars.toDouble() != rating) {
      stars.add(const Icon(
        Icons.star_half_outlined,
        color: Colors.blueAccent,
      ));
      halfStars += 1;
    }

    for (var i = 0; i < 5 - fullStars - halfStars; i++) {
      stars.add(const Icon(
        Icons.star_outline,
        color: Colors.blueAccent,
      ));
    }

    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [...generateStars(rating)],
    );
  }
}
