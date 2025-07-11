// lib/presentation/model/user.dart

class User {
  final int? id; // user_id 또는 doctor_id, nullable로 변경
  final String registerId;
  final String? name;
  final String? gender;
  final String? birth;
  final String? phone;
  final String? role;

  User({
    required this.id, // nullable이므로 required 유지
    required this.registerId,
    this.name,
    this.gender,
    this.birth,
    this.phone,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // id가 null일 경우를 대비하여 as int?로 명시적 캐스팅
      id: json['user_id'] as int? ?? json['doctor_id'] as int?,
      registerId: json['register_id'],
      name: json['name'],
      gender: json['gender'],
      birth: json['birth'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'register_id': registerId,
      'name': name,
      'gender': gender,
      'birth': birth,
      'phone': phone,
      'role': role,
    };
  }

  // ✅ 이 부분이 반드시 포함되어야 합니다.
  // Doctor 여부를 확인하는 편의 getter
  bool get isDoctor => role == 'D';
}
