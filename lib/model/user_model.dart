import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String bio;

  @HiveField(3)
  final String userId;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String phoneNumber;

  @HiveField(6)
  final String gender;

  @HiveField(7)
  final String birthDate;

  @HiveField(8)
  final int balance;

  @HiveField(9)
  final String? profilePicture;

  @HiveField(10)
  final String? password;

  const User({
    required this.name,
    required this.username,
    required this.bio,
    required this.userId,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.birthDate,
    required this.balance,
    this.profilePicture,
    required this.password,
  });

  // Empty/default user factory constructor
  factory User.empty() => const User(
    name: "",
    username: "",
    bio: "",
    userId: "",
    email: "",
    phoneNumber: "",
    gender: "",
    birthDate: "",
    balance: 0,
    profilePicture: null,
    password: "",
  );

  // Add this factory constructor to handle Map conversion
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      bio: map['bio'] ?? '',
      userId: map['userId'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: map['birthDate'] ?? '',
      balance: map['balance']?.toInt() ?? 0,
      profilePicture: map['profilePicture'],
      password: map['password'] ?? '',
    );
  }

  // CopyWith method for immutable updates
  User copyWith({
    String? name,
    String? username,
    String? bio,
    String? userId,
    String? email,
    String? phoneNumber,
    String? gender,
    String? birthDate,
    int? balance,
    String? profilePicture,
    bool nullifyProfilePicture = false,
    String? password,
  }) {
    return User(
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      balance: balance ?? this.balance,
      profilePicture:
          nullifyProfilePicture ? null : profilePicture ?? this.profilePicture,
      password: password ?? this.password,
    );
  }

  // Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.name == name &&
        other.username == username &&
        other.bio == bio &&
        other.userId == userId &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.gender == gender &&
        other.birthDate == birthDate &&
        other.balance == balance &&
        other.profilePicture == profilePicture;
  }

  // Hash code implementation
  @override
  int get hashCode {
    return Object.hash(
      name,
      username,
      bio,
      userId,
      email,
      phoneNumber,
      gender,
      birthDate,
      balance,
      profilePicture,
    );
  }

  // toString for debugging
  @override
  String toString() {
    return 'User('
        'name: $name, '
        'username: $username, '
        'userId: $userId, '
        'email: $email, '
        'balance: $balance'
        ')';
  }
}