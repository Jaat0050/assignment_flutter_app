import 'package:assignment_flutter_app/app/bottomnav/product/add_product.dart';
import 'package:assignment_flutter_app/app/bottomnav/product/delete_product.dart';
import 'package:assignment_flutter_app/app/bottomnav/product/edit_product.dart';
import 'package:assignment_flutter_app/app/bottomnav/product/product_view.dart';
import 'package:assignment_flutter_app/main.dart';
import 'package:assignment_flutter_app/services/api_value.dart';
import 'package:assignment_flutter_app/utils/constant.dart';
import 'package:assignment_flutter_app/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> productList = [];
  bool isSearch = false;
  bool isLoading = false;
  List favproduct = box.get('favProduct') ?? [];

  Future<void> initializePrefs() async {
    setState(() {
      isLoading = true;
    });
    print(SharedPreferencesHelper.getIsLoggedIn());
    if (SharedPreferencesHelper.getIsLoggedIn()) {
      var loansData = await apiValue.getProduct();
      print(loansData);
      if (loansData != null) {
        Map<String, int> indicesMap = {};
        for (int i = 0; i < favproduct.length; i++) {
          indicesMap[favproduct[i]] = i;
        }
        if (mounted) {
          setState(() {
            if (favproduct.isEmpty) {
              productList = loansData;
              isLoading = false;
            } else {
              productList = loansData;
              productList.sort((a, b) {
                int indexA = indicesMap[a['id']] ?? -1;
                int indexB = indicesMap[b['id']] ?? -1;
                if (indexA != -1 && indexB == -1) {
                  return -1;
                } else if (indexB != -1 && indexA == -1) {
                  return 1;
                } else if (indexA != -1 && indexB != -1) {
                  return indexA.compareTo(indexB);
                } else {
                  return 0;
                }
              });
              isLoading = false;
            }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "     Vegetables",
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Image(
                      image: AssetImage('assets/images/top.png'),
                      fit: BoxFit.contain,
                      width: size.height * 0.2,
                    ),
                  ],
                ),
                //--------------------------------------search--------------------------//
                if (SharedPreferencesHelper.getIsLoggedIn())
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Container(
                      height: 38,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Center(
                        child: TextField(
                          cursorColor: MyColors.green,
                          decoration: InputDecoration(
                            focusColor: MyColors.green,
                            hintText: 'Search',
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 15),
                            contentPadding: const EdgeInsets.all(10),
                            isDense: true,
                            border: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: true,
                            prefixIcon: Icon(Icons.search_rounded),
                          ),
                        ),
                      ),
                    ),
                  ),
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
                                    image:
                                        AssetImage('assets/onboarding/ob2.gif'),
                                    height: size.height * 0.2,
                                  ),
                                  Text(
                                    'Login to see products',
                                    style: GoogleFonts.rubik(
                                      textStyle: TextStyle(
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
      floatingActionButton: SharedPreferencesHelper.getIsLoggedIn()
          ? Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.1, top: size.height * 0.1),
                child: floatingButtonBuilder(),
              ))
          : SizedBox(),
    );
  }

  Widget productsBuilder() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: productList.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => ProductScreen(
                  discount: productList[index]["discounted_price"],
                  id: productList[index]["id"],
                  image: index.isEven
                      ? 'assets/images/img2.png'
                      : 'assets/images/img1.png',
                  moq: productList[index]["moq"],
                  name: productList[index]["name"],
                  price: productList[index]["price"],
                ),
              ),
            ).then(
              (value) {
                setState(() {
                  initializePrefs();
                });
              },
            );
          },
          child: Padding(
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
                        ? AssetImage('assets/images/img2.png')
                        : AssetImage('assets/images/img1.png'),
                    fit: BoxFit.fill,
                    width: size.width * 0.4,
                    height: 120,
                  ),
                  SizedBox(
                    width: size.width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            PopupMenuButton<String>(
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit_outlined,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      Text(
                                        '   Edit',
                                        style: GoogleFonts.nunito(
                                          textStyle: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      Text(
                                        '   Delete',
                                        style: GoogleFonts.nunito(
                                          textStyle: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (String value) {
                                if (value == 'edit') {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: EditProductDialog(
                                          id: productList[index]["id"],
                                          discount: productList[index]
                                              ["discounted_price"],
                                          moq: productList[index]["moq"],
                                          name: productList[index]["name"],
                                          price: productList[index]["price"],
                                        ),
                                      );
                                    },
                                  ).then(
                                    (value) {
                                      setState(() {
                                        initializePrefs();
                                      });
                                    },
                                  );
                                } else if (value == 'delete') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DeleteProductDialog(
                                          id: productList[index]["id"]);
                                    },
                                  ).then(
                                    (value) {
                                      setState(() {
                                        initializePrefs();
                                      });
                                    },
                                  );
                                }
                              },
                              child: Icon(
                                Icons.more_vert_rounded,
                                color: Colors.black,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
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
                            "₹ ${productList[index]["price"]}/piece",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 30,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade500,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (favproduct
                                        .contains(productList[index]['id'])) {
                                      favproduct
                                          .remove(productList[index]['id']);

                                      await box.put('favProduct', favproduct);
                                      setState(() {
                                        initializePrefs();
                                      });
                                    } else {
                                      favproduct.add(productList[index]['id']);

                                      await box.put('favProduct', favproduct);
                                      setState(() {
                                        initializePrefs();
                                      });
                                    }
                                  },
                                  child: Icon(
                                    favproduct
                                            .contains(productList[index]['id'])
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 18,
                                    color: favproduct
                                            .contains(productList[index]['id'])
                                        ? Colors.amber
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: MyColors.green,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: MyColors.green,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add_shopping_cart_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget floatingButtonBuilder() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: AddProductDialog(),
            );
          },
        ).then(
          (value) {
            initializePrefs();
          },
        );
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MyColors.green,
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
