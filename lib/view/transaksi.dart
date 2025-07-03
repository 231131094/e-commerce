import 'package:flutter/material.dart';
import 'package:e_commerce/view/itemCard.dart';
import '../model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/controller/user_provider.dart';
import 'package:e_commerce/model/produkModel.dart';

class TransactionPage extends StatelessWidget {
  final User user;
  const TransactionPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Transactions'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: userProvider.getTransactions(user.userId),
        builder: (context, snapshot) {
          if (!userProvider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final transaction = snapshot.data![index];
              return ItemCard(
                title: transaction['product'].nama,
                brand: transaction['product'].namaToko,
                price: 'IDR ${transaction['product'].harga.toStringAsFixed(0)}',
                imageUrl: transaction['product'].gambar,
                produk: transaction['product'],
                user: user,
                status: transaction['status'],
                isTransaction: true,
              );
            },
          );
        },
      ),
    );
  }
}