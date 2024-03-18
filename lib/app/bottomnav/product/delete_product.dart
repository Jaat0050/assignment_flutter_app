import 'package:assignment_flutter_app/services/api_value.dart';
import 'package:assignment_flutter_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteProductDialog extends StatefulWidget {
  String id;
  DeleteProductDialog({super.key, required this.id});

  @override
  DeleteProductDialogState createState() => DeleteProductDialogState();
}

class DeleteProductDialogState extends State<DeleteProductDialog> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.transparent,
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Delete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "DM_Sans",
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(88, 88, 88, 0.68),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Are you sure you want to Delete this product?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "DM_Sans",
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(27, 27, 27, 1),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            border: Border.all(
                              color: MyColors.green,
                            ),
                          ),
                          width: 79,
                          height: 32,
                          child: Center(
                            child: Text(
                              "Go back",
                              style: GoogleFonts.dmSans(
                                textStyle: TextStyle(
                                    fontSize: 10,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });

                              var deleteProductResponse =
                                  await apiValue.deleteProduct(widget.id);

                              if (deleteProductResponse != null) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                              setState(() {
                                isLoading = false;
                              });
                            },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: MyColors.green,
                          ),
                          width: 79,
                          height: 32,
                          child: Center(
                            child: isLoading
                                ? const Align(
                                    alignment: Alignment.center,
                                    child: SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  )
                                : Text(
                                    "Delete",
                                    style: GoogleFonts.dmSans(
                                      textStyle: TextStyle(
                                          fontSize: 10,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ],
    );
  }
}
