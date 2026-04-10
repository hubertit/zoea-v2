import 'package:flutter/material.dart';

import 'reviews_written_screen.dart';

/// Same as [ReviewsWrittenScreen] (API-backed). Kept for `/profile/reviews-ratings` deep links.
class ReviewsRatingsScreen extends StatelessWidget {
  const ReviewsRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReviewsWrittenScreen();
  }
}
