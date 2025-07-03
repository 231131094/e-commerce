import 'package:e_commerce/view/product.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../model/produkModel.dart';
import 'produkCard.dart';
import '../model/user_model.dart';

class Foryou extends StatefulWidget {
  final User user;
  const Foryou({super.key, required this.user});

  @override
  State<Foryou> createState() => _ForyouState();
}

class _ForyouState extends State<Foryou> {
  final Dio dio = Dio();
  List<Produk> produkList = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> getData() async {
    try {
      final response = await dio.get(
        "https://685162528612b47a2c09d46a.mockapi.io/api/v1/w",
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          produkList =
              data.map((json) {
                try {
                  return Produk.fromJson(json);
                } catch (e) {
                  print('Error parsing product: $e');
                  return Produk(
                    id: '0',
                    nama: 'Unknown',
                    harga: 0,
                    deskripsi: 'No description',
                    gambar: '',
                    namaToko: 'Unknown',
                    kota: 'Unknown',
                  );
                }
              }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Connection error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                    ? Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                    : produkList.isEmpty
                    ? const Center(
                      child: Text(
                        "No products available",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Special Offers",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "See More",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/image 2.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            child: const Text(
                              "Popular",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.75,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            BuildContext context,
                            int index,
                          ) {
                            return ProductCard(
                              produk: produkList[index],
                              onAddTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ProductDetailUI(
                                          produk: produkList[index],
                                          user: widget.user,
                                        ),
                                  ),
                                );
                              },
                            );
                          }, childCount: produkList.length),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
