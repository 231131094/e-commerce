import 'package:e_commerce/view/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/controller/user_provider.dart';
import 'package:e_commerce/model/user_model.dart';

class Registpage extends StatefulWidget {
  const Registpage({super.key});

  @override
  State<Registpage> createState() => _RegistpageState();
}

class _RegistpageState extends State<Registpage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerUser() async {
    final username = _usernameController.text.trim().toLowerCase();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim().toLowerCase();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final newUser = User(
        name: username,
        username: username,
        bio: "New user",
        userId: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        phoneNumber: "",
        gender: "",
        birthDate: "",
        balance: 0,
        profilePicture: null,
        password: password,
      );

      await userProvider.registerUser(newUser);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful!')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(color: Colors.black),
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     onPressed: () => Navigator.pop(context),
      //     icon: const Icon(Icons.arrow_back_rounded),
      //     mouseCursor: SystemMouseCursors.click,
      //   ),
      // ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpUINsyuFs8GIe-KXGjIuxgfYYghN_EPJ4hg&s",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    "Create an account and order easily.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: "Username",
                      icon: const Icon(Icons.supervised_user_circle_rounded),
                      iconColor: Colors.black,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: "Email",
                      icon: const Icon(Icons.email),
                      iconColor: Colors.black,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(fontSize: 14),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.black),
                      icon: const Icon(Icons.key),
                      iconColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.grey[800],
                      ),
                      onPressed: _registerUser,
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Text(
                        " Or continue with ",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.g_mobiledata_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.facebook_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: TextButton(
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Loginpage(),
                              ),
                            ),
                        child: const Text(
                          "Already Have An Account? Login",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
