class UserModel {
  final String id;
  final String fullName;
  final String email;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory UserModel.fromFirestore(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      fullName: (data['fullName'] as String?) ?? 'Kali Fashion User',
      email: (data['email'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'uid': id, 'fullName': fullName, 'email': email};
  }

  String get initials {
    final trimmedName = fullName.trim();
    if (trimmedName.isEmpty) return 'KF';

    final parts = trimmedName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmedName[0].toUpperCase();
  }
}
