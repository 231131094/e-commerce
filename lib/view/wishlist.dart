import 'package:flutter/material.dart';
import 'package:e_commerce/view/itemCard.dart';
import '../model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/controller/user_provider.dart';
import 'package:e_commerce/model/produkModel.dart';

class WishlistPage extends StatelessWidget {
  final User user;
  const WishlistPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final wishlist = userProvider.getWishlist(user.userId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Wishlist'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<Produk>>(
        future: wishlist,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Wishlist is empty'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final produk = snapshot.data![index];
              return ItemCard(
                title: produk.nama,
                brand: produk.namaToko,
                price: 'IDR ${produk.harga.toStringAsFixed(0)}',
                imageUrl: produk.gambar,
                produk: produk,
                user: user,
                onRemove: () {
                  userProvider.removeFromWishlist(user.userId, produk);
                },
              );
            },
          );
        },
      ),
    );
  }
}