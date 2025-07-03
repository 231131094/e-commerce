part of 'user_model.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      name: fields[0] as String,
      username: fields[1] as String,
      bio: fields[2] as String,
      userId: fields[3] as String,
      email: fields[4] as String,
      phoneNumber: fields[5] as String,
      gender: fields[6] as String,
      birthDate: fields[7] as String,
      balance: fields[8] as int,
      profilePicture: fields[9] as String?,
      password: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.bio)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.birthDate)
      ..writeByte(8)
      ..write(obj.balance)
      ..writeByte(9)
      ..write(obj.profilePicture)
      ..writeByte(10)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
