// Repository abstrak untuk Pembayaran
import 'pembayaran_model.dart';

abstract class PembayaranRepository {
  Future<List<PembayaranModel>> fetchPembayaran();
  Future<PembayaranModel?> getPembayaranById(String id);
  Future<void> createPembayaran(PembayaranModel pembayaran);
  Future<void> updatePembayaran(PembayaranModel pembayaran);
  Future<void> deletePembayaran(String id);
}
