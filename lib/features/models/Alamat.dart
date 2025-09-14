import '../shared/helpers/helper.dart';


// alamat
class Alamat {
  final int id;
  final int userId;
  final String? label;
  final String? recipientName;
  final String? phone;
  final String? province;
  final String? city;
  final String? district;
  final String? postalCode;
  final String? fullAddress;
  final bool isDefault;
  final DateTime? createdAt;

  const Alamat({
    required this.id,
    required this.userId,
    this.label,
    this.recipientName,
    this.phone,
    this.province,
    this.city,
    this.district,
    this.postalCode,
    this.fullAddress,
    this.isDefault = false,
    this.createdAt,
  });

  factory Alamat.fromMap(Map<String, dynamic> m) => Alamat(
        id: m['id'] as int,
        userId: m['user_id'] as int,
        label: cast<String>(m['label']),
        recipientName: cast<String>(m['recipient_name']),
        phone: cast<String>(m['phone']),
        province: cast<String>(m['province']),
        city: cast<String>(m['city']),
        district: cast<String>(m['district']),
        postalCode: cast<String>(m['postal_code']),
        fullAddress: cast<String>(m['full_address']),
        isDefault: toBool(m['is_default']) ?? false,
        createdAt: toDate(m['created_at']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'label': label,
        'recipient_name': recipientName,
        'phone': phone,
        'province': province,
        'city': city,
        'district': district,
        'postal_code': postalCode,
        'full_address': fullAddress,
        'is_default': isDefault,
        'created_at': createdAt?.toIso8601String(),
      };
}

