import 'package:e_commerce/view/account.dart';
import 'package:e_commerce/view/mainPage.dart';
import 'package:e_commerce/view/transaksi.dart';
import 'package:e_commerce/view/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../model/user_model.dart';

class Bottomnavbar extends StatefulWidget {
  final User user;
  const Bottomnavbar({super.key, required this.user});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _selectedIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Mainpage(user: widget.user)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WishlistPage(user: widget.user),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionPage(user: widget.user),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountScreen(user: widget.user),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF75C2F6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: GNav(
          gap: 8,
          backgroundColor: Color(0xFF75C2F6),
          color: Colors.white,
          tabBackgroundColor: Color(0xFFF4D160),
          activeColor: Colors.white,
          selectedIndex:
              _selectedIndex,
          onTabChange: _onTabChange,
          tabs: [
            GButton(icon: Icons.thumb_up_alt_rounded, text: "For You"),
            GButton(icon: Icons.shopping_bag_rounded, text: "Bag"),
            GButton(icon: Icons.list_alt_rounded, text: "Transaction"),
            GButton(icon: Icons.account_circle_rounded, text: "User"),
          ],
        ),
      ),
    );
  }
}
