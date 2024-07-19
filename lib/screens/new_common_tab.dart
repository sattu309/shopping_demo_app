import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import "package:shop_app/helper/apptheme_color.dart";
import "package:shop_app/screens/profile/profile_screen.dart";
import "../controllers/cart_controller.dart";
import "../controllers/main_controller.dart";
import "../controllers/session_controller.dart";
import "../controllers/wishlist_controller.dart";
import "cart/cart_screen.dart";
import "favorite/favorite_screen.dart";
import "home/categories_list.dart";
import "home/home_screen.dart";


class MinimalExample extends StatefulWidget {
  const MinimalExample({super.key});

  @override
  State<MinimalExample> createState() => _MinimalExampleState();
}

class _MinimalExampleState extends State<MinimalExample> {
  final favController = Get.put(WishListController());
  final controller = Get.put(MainHomeController());
  final sessionIdController = Get.put(SessionController());
  final cartController = Get.put(CartController());
  List<PersistentTabConfig> tabs() => [
        PersistentTabConfig(
          screen: const HomeScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.home_filled),
            title: "Home",
              activeForegroundColor: AppThemeColor.buttonColor,
          ),
        ),
        PersistentTabConfig(
          screen: const CategoryList(),
          item: ItemConfig(
            icon: const Icon(Icons.category_outlined),
            title: "Category",
            activeForegroundColor: AppThemeColor.buttonColor
          ),
        ),
    PersistentTabConfig(
      screen: const CartScreen(),
      item: ItemConfig(
          icon: const Icon(Icons.shopping_cart_outlined),
          title: "Cart",
          activeForegroundColor: AppThemeColor.buttonColor
      ),
    ),
        PersistentTabConfig(
          screen: const FavoriteScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.favorite),
            title: "Wishlist",
              activeForegroundColor: AppThemeColor.buttonColor
          ),
        ),
        PersistentTabConfig(
          screen: const ProfileScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.person),
            title: "Profile",
              activeForegroundColor: AppThemeColor.buttonColor
          ),
        ),
      ];
@override
  void initState() {
    super.initState();
    sessionIdController.getAccessToken();
    favController.fetchWishlist();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //
      // floatingActionButton: Visibility(
      //   child: GestureDetector(
      //     onTap: () {
      //       // cartController.getCartDataLocally();
      //       // controller.onItemTap(2);
      //
      //     },
      //     child: Container(
      //       height: 55,
      //       width: 55,
      //       decoration: BoxDecoration(
      //         color: AppThemeColor.buttonColor,
      //         borderRadius: BorderRadius.circular(30),
      //         // border: Border.all(color: AppThemeColor.backgroundcolor, width: 1)),
      //       ),
      //       child: const Center(
      //           child: Icon(
      //             Icons.shopping_cart_outlined,
      //             color: Colors.white,
      //           )),
      //     ),
      //   ),
      // ),
      body: PersistentTabView(
          tabs: tabs(),
              onTabChanged: (index) {
            switch (index) {
              case 0:
                break;
              case 1:
                break;
              case 2:
              // Call CartController method
                cartController.getCartDataLocally();
                break;
              case 3:
              // Call WishListController method
                favController.fetchWishlist();
                break;
              case 4:
              // Call ProfileController method
                break;
            }
          },
          // controller: controller.currentIndex.value,
          navBarBuilder: (navBarConfig) => Style1BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  // spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],

              padding: EdgeInsets.all(8.0),
            ),

          )),

    );

  }

}


