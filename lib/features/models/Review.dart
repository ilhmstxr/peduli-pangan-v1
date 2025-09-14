import '../shared/helpers/helper.dart';

// reviews
class Review {
  final int id;
  final int userId;
  final int productId;
  final int rating; // int
  final String? comment;
  final DateTime? createdAt;

  const Review({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rating,
    this.comment,
    this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> m) => Review(
        id: m['id'] as int,
        userId: m['user_id'] as int,
        productId: m['product_id'] as int,
        rating: (m['rating'] as num).toInt(),
        comment: cast<String>(m['comment']),
        createdAt: toDate(m['created_at']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'product_id': productId,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt?.toIso8601String(),
      };
}

