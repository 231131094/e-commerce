import 'package:e_commerce/view/forYou.dart';
import 'package:e_commerce/model/user_model.dart';
import 'package:flutter/material.dart';
import "../controller/customAppBar.dart";
import '../controller/BottomNavBar.dart';

class Mainpage extends StatefulWidget {
  final User user;
  const Mainpage({super.key, required this.user});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Color(0xff75C2F6),
      //   toolbarHeight: 150,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(40))),
      //   centerTitle:true,
      //   title: Text("sBN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
      //   actions: [
      //     IconButton(
      //       color: Colors.white,
      //       iconSize: 35,
      //       onPressed: (){}, 
      //       icon: Icon(Icons.notifications_rounded)
      //     )
      //   ],
        
      // ),
      
      //body 
      body: Column(
        children: [
          const CustomSearchAppBar(),
          Expanded(
            child: Foryou(user: widget.user)
          )
        ],
      ),

      //nav bawah
      bottomNavigationBar: Bottomnavbar(user: widget.user),

      // bottomNavigationBar: BottomAppBar(
      //   height: 100,
      //   // shape: CircularNotchedRectangle(),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       Column(
      //         children: [
      //           IconButton(
      //             onPressed: () {},
      //             icon: Icon(Icons.thumb_up_alt_rounded),
      //           ),
      //           Text("For You", style: TextStyle(color: Colors.black)),
      //         ],
      //       ),
      //       // SizedBox(width: 30,),
      //       Column(
      //         children: [
      //           Column(
      //             children: [
      //               IconButton(
      //                 onPressed: () {},
      //                 icon: Icon(Icons.shopping_bag_rounded),
      //               ),
      //               Text("Bag", style: TextStyle(color: Colors.black)),
      //             ],
      //           ),
      //         ],
      //       ),
      //       // SizedBox(width: 15,),
      //       Column(
      //         children: [
      //           IconButton(
      //             onPressed: () {},
      //             icon: Icon(Icons.list_alt_rounded),
      //           ),
      //           Text("Transaction", style: TextStyle(color: Colors.black)),
      //         ],
      //       ),
      //       Column(
      //         children: [
      //           IconButton(
      //             onPressed: () {},
      //             icon: Icon(Icons.account_circle_rounded),
      //           ),
      //           Text("Account", style: TextStyle(color: Colors.black)),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton.large(
      //   shape: CircleBorder(),
      //   onPressed: () {},
      //   child: Icon(Icons.shopping_bag_rounded),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}