import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/helper/common_button.dart';
import 'package:shop_app/screens/products/price_slider.dart';

import '../../constants.dart';
import '../../controllers/wishlist_controller.dart';
import '../../helper/heigh_width.dart';
import '../details/details_screen.dart';
import 'discount_filter.dart';
import 'multiple_checkbox.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key, required this.categoryId, required this.categoryName});
  final String categoryId;
  final String categoryName;

  static String routeName = "/products";

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final wishListController = Get.put(WishListController());
  bool isFavourite = false;
  String imgLInk = "https://ctshop.ssspl.net/products/";
 late String fetchProducts;
  // final String fetchProducts =


  @override
  void initState() {
    super.initState();
    log(widget.categoryId);
    fetchProducts =
    """
    query Category {
    categories(id: "${widget.categoryId}") {
        id
        category
        slug
        products {
            id
            productname
            price
            minprice
            maxprice
            productimages{
                id
                imagepath
            }
        }
    }
}
  """;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text("${widget.categoryName} Products"),
        leadingWidth: 30,
        actions: [
          GestureDetector(
            onTap: () {
              showFilters();
            },
            child: Container(
                padding: const EdgeInsets.only(right: 13),
                child: Image.asset(
                  "assets/images/filter.jpeg",
                  height: 35,
                  width: 35,
                )),
          )
        ],
      ),
      body: Query(
        options: QueryOptions(document: gql(fetchProducts)),
        builder:  (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}){
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return  Center(child: CircularProgressIndicator(
              color: AppThemeColor.buttonColor,));
          }

          final  List<dynamic>? allProducts = result.data!['categories'][0]['products'];
          if (allProducts == null || allProducts.isEmpty) {
            return const Center(child: Text('No products available'));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: GridView.builder(
              itemCount: allProducts.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.6,
                mainAxisSpacing: 1,
                crossAxisSpacing: 7,
              ),
              itemBuilder: (context, index) {
                final productsData = allProducts[index];
                final image = productsData['productimages'];
                String imageUrl = '';
                if (image != null && image.isNotEmpty && image[0]['imagepath'] != null) {
                  imageUrl = image[0]['imagepath'];
                }
                log("This is products $productsData");
                log("This is IMG $image");
                log("This is IMAGE URL ${imgLInk+imageUrl}");
                final imagePATH = imgLInk+imageUrl;
                return
                  GestureDetector(
                    onTap: (){
                      log("PRODUCT ID $productsData['id']");
                      // Get.to(()=> DetailsScreen(productId: productsData['id']));
                      pushScreen(context, screen: DetailsScreen(productId: productsData['id']),withNavBar: true);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(.1,.1)
                              )
                            ]
                          ),
                          child:
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: CachedNetworkImage(
                                imageUrl: imagePATH,
                                height: height *.27,
                                width: width *.55,
                                  errorWidget: (_, __, ___) => Image.asset(
                                    "assets/images/Image Popular Product 2.png",
                                    fit: BoxFit.contain,
                                    height: 50,
                                    width: 50,
                                  ),
                                  placeholder: (_, __) =>  Container(
                                    color: Colors.grey.shade200,
                                  ),
                                  fit: BoxFit.fitWidth,
                              ),
                            )
                          //
                          // Image.asset("assets/images/glap.png",),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                productsData['productname'],
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        addHeight(2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${productsData['minprice']} - \$${productsData['maxprice']}",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                log("product id ${productsData['id'].toString()}");
                                wishListController.addWishList(productsData['id'].toString(), "",context);
                                wishListController.fetchWishlist();
                                //
                                // isFavourite = !isFavourite;
                                // setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  color: isFavourite
                                      ? kPrimaryColor.withOpacity(0.15)
                                      : kSecondaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  "assets/icons/Heart Icon_2.svg",
                                  colorFilter: ColorFilter.mode(
                                      isFavourite
                                          ? const Color(0xFFFF4848)
                                          : const Color(0xFFDBDEE4),
                                      BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
              },
              // itemBuilder: (context, index) => ProductCard(
              //   product: demoProducts[index],
              //   onPress: () => Navigator.pushNamed(
              //     context,
              //     DetailsScreen.routeName,
              //     arguments:
              //         ProductDetailsArguments(product: demoProducts[index]),
              //   ),
              // ),
            ),
          );
        }),
    );
  }

  showFilters() {
    var height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  width: double.maxFinite,
                  //height: height * .6,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          addHeight(3),
                          Center(
                            child: Container(
                              height: 10,
                              width: 85,
                              decoration: BoxDecoration(
                                  // color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Divider(
                                thickness: 5,
                                height: 2,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          addHeight(15),
                          const Text("Filters",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18)),
                          // addHeight(5),
                          // Divider(
                          //   thickness: 1.5,
                          //   height: 2,
                          //   color: Colors.black54,
                          // ),
                          addHeight(25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PRICE",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                addHeight(10),
                                PriceRangeSlider(),
                                addHeight(15),
                                const MultipleCheckboxScreen(
                                  title: '',
                                ),
                                addHeight(15),
                                const DiscountFilter(),
                                addHeight(20),
                                CommonButtonGreen(
                                  title: "APPLY",
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                addHeight(20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
        });
  }
}
