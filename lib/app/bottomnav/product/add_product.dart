// ignore: must_be_immutable
import 'package:assignment_flutter_app/services/api_value.dart';
import 'package:assignment_flutter_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductDialog extends StatefulWidget {
  AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _moqController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: 390,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: MyColors.dullBlue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            //---------------------------------------name--------------------------------//
            textfieldBuilder(_productNameController, 'Product Name', false),

            //---------------------------------------MOQ--------------------------------//
            textfieldBuilder(_moqController, 'Moq', true),

            //---------------------------------------price--------------------------------//
            textfieldBuilder(_priceController, 'Product Price', true),

            //---------------------------------------discount--------------------------------//
            textfieldBuilder(_discountController, 'Product discount', true),

            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
              child: GestureDetector(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.green,
                    disabledBackgroundColor: MyColors.green,
                    minimumSize: const Size(100, 35),
                    maximumSize: const Size(100, 35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_productNameController.text.isEmpty) {
                            toast('Enter Product name');
                          } else if (_moqController.text.isEmpty) {
                            toast('Enter moq');
                          } else if (_moqController.text == "0") {
                            toast('Moq should be greater then ₹0');
                          } else if (_priceController.text.isEmpty) {
                            toast('Enter price');
                          } else if (_priceController.text == "0") {
                            toast('price should be greater then ₹0');
                          } else if (_discountController.text.isEmpty) {
                            toast('Enter discount');
                          } else if (_discountController.text == "0") {
                            toast('discount should be greater then ₹0');
                          } else {
                            setState(() {
                              isLoading = true;
                            });

                            var addProductResponse = await apiValue.addProduct(
                              _productNameController.text,
                              _moqController.text,
                              _priceController.text,
                              _discountController.text,
                            );

                            if (addProductResponse != null) {
                              setState(() {
                                isLoading = false;
                              });
                              print(addProductResponse);
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                  child: isLoading
                      ? const Align(
                          alignment: Alignment.center,
                          child: SpinKitThreeBounce(
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      : Text(
                          'Add',
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textfieldBuilder(controller, String hintText, bool isphone) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 40,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: isphone ? TextInputType.number : TextInputType.text,
          inputFormatters: isphone
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ]
              : [],
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
            contentPadding: const EdgeInsets.all(10),
            isDense: true,
            border: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true,
          ),
        ),
      ),
    );
  }

  void toast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: MyColors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
