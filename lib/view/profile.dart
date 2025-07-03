import 'package:e_commerce/controller/BottomNavBar.dart';
import 'package:e_commerce/view/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/view/editProfileScreen.dart';
import 'package:e_commerce/controller/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileInfoScreen extends StatelessWidget {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(''),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage:
                        user.profilePicture != null &&
                                user.profilePicture!.isNotEmpty
                            ? NetworkImage(user.profilePicture!)
                            : const AssetImage('assets/hulk.jpg')
                                as ImageProvider,
                  ),
                ),
              ),
            ),

            // Tombol edit
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profil"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF75C2F6),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildInfoRow('Nama', user.name),
            _buildInfoRow('Username', user.username),
            _buildInfoRow('Bio', user.bio),
            const SizedBox(height: 24),
            const Text(
              'Info Pribadi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('UserID', user.userId),
            _buildInfoRow('E-mail', user.email),
            _buildInfoRow('Nomor HP', user.phoneNumber),
            _buildInfoRow('Jenis Kelamin', user.gender),
            _buildInfoRow('Tanggal Lahir', user.birthDate),
            const SizedBox(height: 32),

            Center(
              child: TextButton(
                onPressed: () {
                  final userId = Provider.of<UserProvider>(context, listen: false).user.userId;
                  Provider.of<UserProvider>(
                    context,
                    listen: false,
                  ).deleteUser(userId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Akun berhasil dihapus')),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loginpage()),
                  );
                },
                child: const Text(
                  'Hapus Akun',
                  style: TextStyle(color: Color(0xFF3C00AC)),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'For You'),
      //     BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Bag'),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.receipt),
      //       label: 'Transaction',
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      //   ],
      //   currentIndex: 3,
      //   onTap: (index) {
      //     // Handle navigation
      //   },
      // ),
      bottomNavigationBar: Bottomnavbar(user: user),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value.isNotEmpty ? value : 'belum diisi')),
        ],
      ),
    );
  }
}
