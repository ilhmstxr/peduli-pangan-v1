import 'alamat_model.dart';

abstract class AlamatRepository {
  Future<List<Alamat>> getAlamates(int userId);
  Future<Alamat?> getAlamatById(int id);
  Future<void> addAlamat(Alamat alamat);
  Future<void> updateAlamat(Alamat alamat);
  Future<void> deleteAlamat(int id);
}
