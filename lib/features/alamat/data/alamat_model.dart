class Alamat {
  final int id;
  final int userId;
  final String label;
  final String recipientName;
  final String phone;
  final String province;
  final String city;
  final String district;
  final String postalCode;
  final String fullAddress;
  final bool isDefault;
  final DateTime createdAt;

  Alamat({
    required this.id,
    required this.userId,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.province,
    required this.city,
    required this.district,
    required this.postalCode,
    required this.fullAddress,
    required this.isDefault,
    required this.createdAt,
  });

  factory Alamat.fromJson(Map<String, dynamic> json) {
    return Alamat(
      id: json['id'],
      userId: json['user_id'],
      label: json['label'],
      recipientName: json['recipient_name'],
      phone: json['phone'],
      province: json['province'],
      city: json['city'],
      district: json['district'],
      postalCode: json['postal_code'],
      fullAddress: json['full_address'],
      isDefault: json['is_default'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'created_at': createdAt.toIso8601String(),
    };
  }
}
