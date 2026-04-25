import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;
  final bool showCount;

  const StarRating({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.size = 16,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return Icon(Icons.star, size: size, color: AppTheme.kGold);
          } else if (index < rating && rating % 1 != 0) {
            return Icon(Icons.star_half, size: size, color: AppTheme.kGold);
          } else {
            return Icon(Icons.star_outline, size: size, color: AppTheme.kGray);
          }
        }),
        if (showCount) ...[
          SizedBox(width: size * 0.3),
          Text(
            '$rating',
            style: TextStyle(
              fontSize: size * 0.75,
              fontWeight: FontWeight.w600,
              color: AppTheme.kDark,
            ),
          ),
          SizedBox(width: size * 0.5),
          Text(
            '($reviewCount)',
            style: TextStyle(fontSize: size * 0.65, color: AppTheme.kGray),
          ),
        ],
      ],
    );
  }
}
