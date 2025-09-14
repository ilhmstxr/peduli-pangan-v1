// Repository implementasi Supabase untuk Pembayaran
import 'pembayaran_model.dart';
import 'pembayaran_repository.dart';

class PembayaranRepositorySupabase implements PembayaranRepository {
  @override
  Future<List<PembayaranModel>> fetchPembayaran() async {
    // TODO: Implementasi fetch dari Supabase
    return [];
  }

  @override
  Future<PembayaranModel?> getPembayaranById(String id) async {
    // TODO: Implementasi fetch by id dari Supabase
    return null;
  }

  @override
  Future<void> createPembayaran(PembayaranModel pembayaran) async {
    // TODO: Implementasi create pembayaran di Supabase
  }

  @override
  Future<void> updatePembayaran(PembayaranModel pembayaran) async {
    // TODO: Implementasi update pembayaran di Supabase
  }

  @override
  Future<void> deletePembayaran(String id) async {
    // TODO: Implementasi delete pembayaran di Supabase
  }
}
