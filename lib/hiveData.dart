import 'package:e_commerce/model/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> saveExampleUser() async {
  final box = Hive.box<User>('userBox');

  final emptyUser = User(
    name: "",
    username: "",
    bio: "",
    userId: "",
    email: "",
    phoneNumber: "",
    gender: "",
    birthDate: "",
    balance: 0,
    profilePicture: "",
    password: "",
  );

  await box.put('user', emptyUser);
}