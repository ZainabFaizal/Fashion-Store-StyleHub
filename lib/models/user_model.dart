class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  /// ✅ SAFE INITIALS (NO RANGE ERROR)
  String get initials {
    if (name.trim().isEmpty) return '';

    final parts = name.trim().split(' ');
    final initials = parts
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase())
        .join();

    // ✅ Take ONLY available characters (max 2)
    return initials.length >= 2
        ? initials.substring(0, 2)
        : initials.substring(0, 1);
  }
}
