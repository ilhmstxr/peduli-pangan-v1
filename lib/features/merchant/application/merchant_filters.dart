// application/merchant_filters.dart
enum MerchantOrderBy {
  ratingDesc,
  ratingAsc,
  createdAtDesc,
  createdAtAsc,
  updatedAtDesc,
  updatedAtAsc,
}

class MerchantFilters {
  final String? search;
  final double? minRating;
  final int? userId;
  final MerchantOrderBy? orderBy;
  final int? limit;
  final int? page;

  const MerchantFilters({
    this.search,
    this.minRating,
    this.userId,
    this.orderBy = MerchantOrderBy.updatedAtDesc,
    this.limit,
    this.page,
  });

  MerchantFilters copyWith({
    String? search,
    double? minRating,
    int? userId,
    MerchantOrderBy? orderBy,
    int? limit,
    int? page,
  }) {
    return MerchantFilters(
      search: search ?? this.search,
      minRating: minRating ?? this.minRating,
      userId: userId ?? this.userId,
      orderBy: orderBy ?? this.orderBy,
      limit: limit ?? this.limit,
      page: page ?? this.page,
    );
  }
}
