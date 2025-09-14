import '../data/alamat_model.dart';

class AlamatState {
  final List<Alamat> alamates;
  final bool isLoading;
  final String? error;

  AlamatState({
    this.alamates = const [],
    this.isLoading = false,
    this.error,
  });

  AlamatState copyWith({
    List<Alamat>? alamates,
    bool? isLoading,
    String? error,
  }) {
    return AlamatState(
      alamates: alamates ?? this.alamates,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
