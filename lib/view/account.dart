import 'package:e_commerce/view/transaksi.dart';
import 'package:e_commerce/model/user_model.dart';
import 'package:e_commerce/controller/BottomNavBar.dart';
import 'package:e_commerce/view/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/controller/user_provider.dart';
import 'package:e_commerce/view/profile.dart';
import 'package:e_commerce/view/grafik.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  final User user;
  const AccountScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final user = userProvider.user;

    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          user.profilePicture != null &&
                                  user.profilePicture!.isNotEmpty
                              ? NetworkImage(user.profilePicture!)
                              : const AssetImage('assets/hulk.jpg')
                                  as ImageProvider,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username.isNotEmpty ? user.username : "Guest",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.wallet, color: Colors.deepPurple),
                            const SizedBox(width: 4),
                            Text(
                              'Rp ${user.balance.toString()}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _buildMenuItem(context, Icons.person, 'Profil', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileInfoScreen(),
                ),
              );
            }),
            _buildMenuItem(context, Icons.receipt, 'Daftar Transaksi', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionPage(user: user)),
              );
            }),
            _buildMenuItem(context, Icons.favorite, 'Wishlist', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishlistPage(user: user)),
              );
            }),
            _buildMenuItem(context, Icons.bar_chart, 'Grafik', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GrafikScreen(user: user)),
              );
            }),
            _buildMenuItem(context, Icons.payment, 'Metode Pembayaran'),
            _buildMenuItem(context, Icons.local_offer, 'Voucher & Promo'),
            _buildMenuItem(context, Icons.card_giftcard, 'Point Reward'),
            _buildMenuItem(context, Icons.help, 'Bantuan & Dukungan'),
            _buildMenuItem(context, Icons.security, 'Pusat Keamanan'),
            _buildMenuItem(context, Icons.language, 'Bahasa & Tampilan'),
            _buildMenuItem(context, Icons.info, 'Tentang Aplikasi'),

            Center(
              child: Material(
                color: Color(0xFFF4D160),
                borderRadius: BorderRadius.circular(7),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    userProvider.logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      'Log out',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Bottomnavbar(user: user),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, [
    VoidCallback? onTap,
  ]) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(color: Colors.black)),
        trailing: const Icon(Icons.chevron_right, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}
