// State untuk Pembayaran
import '../data/pembayaran_model.dart';

class PembayaranState {
  final List<PembayaranModel> pembayaranList;
  final bool isLoading;
  final String? error;

  PembayaranState({
    required this.pembayaranList,
    this.isLoading = false,
    this.error,
  });
}
