import 'package:assignment_flutter_app/main.dart';
import 'package:assignment_flutter_app/services/api_value.dart';
import 'package:assignment_flutter_app/utils/constant.dart';
import 'package:assignment_flutter_app/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

List<dynamic> cartProduct = box.get('cart') ?? [];

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> productList = [];
  bool isLoading = false;

  Future<void> initializePrefs() async {
    setState(() {
      isLoading = true;
    });

    if (SharedPreferencesHelper.getIsLoggedIn()) {
      var productData = await apiValue.getProduct();
      if (productData != null) {
        List filteredProducts = productData
            .where((product) => cartProduct.contains(product['id'].toString()))
            .toList();

        if (mounted) {
          setState(() {
            productList = filteredProducts;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializePrefs();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.dullWhite,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Cart',
          style: GoogleFonts.rubik(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          onRefresh: () async {
            initializePrefs();
          },
          child: Container(
            height: size.height,
            width: size.width,
            color: MyColors.dullWhite,
            child: Column(
              children: [
                //------------------------------------list of products-----------------------------//
                Expanded(
                  child: isLoading
                      ? Center(
                          child:
                              CircularProgressIndicator(color: MyColors.green),
                        )
                      : productList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: const AssetImage(
                                        'assets/onboarding/ob1.gif'),
                                    height: size.height * 0.2,
                                  ),
                                  Text(
                                    SharedPreferencesHelper.getIsLoggedIn()
                                        ? 'No product in cart'
                                        : 'Login to see cart products',
                                    style: GoogleFonts.rubik(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : productsBuilder(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget productsBuilder() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: productList.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromRGBO(0, 0, 0, 0.33),
                width: 1.0,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(
                  image: index.isEven
                      ? const AssetImage('assets/images/img2.png')
                      : const AssetImage('assets/images/img1.png'),
                  fit: BoxFit.fill,
                  width: size.width * 0.4,
                  height: 100,
                ),
                SizedBox(
                  width: size.width * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              productList[index]["name"],
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "₹ ${productList[index]["price"]} / piece",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          String productId =
                              productList[index]["id"].toString();
                          cartProduct.remove(productId);
                          await box.put('cart', cartProduct);
                          setState(() {
                            productList.removeAt(index);
                          });
                        },
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
