import 'package:assignment_flutter_app/app/bottomnav/product/delete_product.dart';
import 'package:assignment_flutter_app/app/bottomnav/product/edit_product.dart';
import 'package:assignment_flutter_app/main.dart';
import 'package:assignment_flutter_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatefulWidget {
  String image;
  String id;
  String name;
  String price;
  String moq;
  String discount;
  ProductScreen({
    super.key,
    required this.image,
    required this.id,
    required this.name,
    required this.moq,
    required this.price,
    required this.discount,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List favprod = [];

  @override
  void initState() {
    super.initState();
    favprod = box.get('favProduct');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.dullWhite,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Product Details',
          style: GoogleFonts.rubik(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: AssetImage(widget.image),
                height: size.height * 0.4,
                width: size.width,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  widget.name,
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Text(
                'Price: ₹${widget.price} / piece',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Discount: ~ ₹${widget.discount} / piece',
                  style: GoogleFonts.elsie(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: size.height * 0.1,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 45,
                width: 65,
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
                      if (favprod.contains(widget.id)) {
                        favprod.remove(widget.id);

                        await box.put('favProduct', favprod);
                        setState(() {});
                      } else {
                        favprod.add(widget.id);

                        await box.put('favProduct', favprod);
                        setState(() {});
                      }
                    },
                    child: Icon(
                      // Icons.favorite_border,
                      size: 20,
                      favprod.contains(widget.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      // size: 18,
                      color: favprod.contains(widget.id)
                          ? Colors.amber
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                height: 45,
                width: 190,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MyColors.green,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: MyColors.green,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.shopping_cart_checkout_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    Text(
                      'Add to Cart',
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
