import 'package:e_commerce/view/transaksi.dart';
import 'package:e_commerce/model/user_model.dart';
import 'package:flutter/material.dart';
import '../model/produkModel.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/controller/user_provider.dart';

class ProductDetailUI extends StatefulWidget {
  final Produk produk;
  final User user;

  const ProductDetailUI({super.key, required this.produk, required this.user});

  @override
  State<ProductDetailUI> createState() => _ProductDetailUIState();
}

class _ProductDetailUIState extends State<ProductDetailUI> {
  String? selectedSize;
  int? selectedColorIndex;

  final List<Color> colorOptions = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];

  final List<String> colorNames = [
    "Red",
    "Green",
    "Blue",
    "Orange",
  ];

  Future<void> _addToWishlist() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.addToWishlist(widget.produk);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk ditambahkan ke wishlist')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan ke wishlist: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4D160),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Product", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.shopping_bag, color: Colors.white),
              onPressed: _addToWishlist,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFFF4D160),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Image.network(
                widget.produk.gambar,
                fit: BoxFit.contain,
                errorBuilder:
                    (_, __, ___) => const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.white),
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 18,
                        child: Icon(Icons.store, size: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.produk.namaToko,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.produk.kota,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.produk.nama,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.star, size: 16, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        "4.5",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "(100 Review)",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Detail",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.produk.deskripsi,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Color :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      colorOptions.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColorIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10, left: 20),
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: colorOptions[index],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  selectedColorIndex == index
                                      ? Colors.black
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Size :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<String>(
                        value: selectedSize,
                        hint: const Text("CHOOSE SIZE"),
                        items: const [
                          DropdownMenuItem(
                            value: "S",
                            child: Text(
                              "Small",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "M",
                            child: Text(
                              "Medium",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "L",
                            child: Text(
                              "Large",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedSize = value;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    children: [
                      Text(
                        "IDR ${(widget.produk.harga).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder:
                                (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed:
                                                  () => Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                        const Text(
                                          "Konfirmasi Pembayaran",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Kamu melakukan pembayaran untuk",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFFF),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Center(
                                            child: Image.network(
                                              widget.produk.gambar,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (_, __, ___) => const Text(
                                                    "Gambar Produk",
                                                  ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Center(
                                          child: Align(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.produk.nama,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  selectedColorIndex != null
                                                      ? "Color : ${colorNames[selectedColorIndex!]}"
                                                      : "Color : Not selected",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  selectedSize != null
                                                      ? "$selectedSize"
                                                      : "Size: Not selected",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Kami akan memproses pesanan Anda\nsegera setelah pembayaran dikonfirmasi.",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () async {
  Navigator.pop(context); // Tutup dialog
  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.addTransaction(widget.user, widget.produk);
    await userProvider.recordTransaction(widget.user, widget.produk);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment successful!')),
    );
    // Navigasi ke TransactionPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionPage(user: widget.user),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFF4D160,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                            ),
                                            child: const Text(
                                              "PAY",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4D160),
                          minimumSize: const Size(150, 50),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Buy Now",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}