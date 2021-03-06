import 'package:careofbeauty/screens/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  final String image;
  final String id;
  final String name;
  final int price;
  final int colorCode;
  final String color;
  final String details;

  const ProductDetail(
      {Key? key,
      required this.image,
      required this.id,
      required this.name,
      required this.price,
      required this.colorCode,
      required this.color,
      required this.details})
      : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(widget.colorCode),
      appBar: AppBar(
        backgroundColor: Color(widget.colorCode),
        elevation: 0.0,
        title: const Text("Detail"),
      ),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  //Details Body
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.3),
                    padding: EdgeInsets.only(
                        top: size.height * 0.12, left: 20.0, right: 20.0),
                    //height: 500,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Color"),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 20 / 4, right: 20 / 2),
                                  padding: const EdgeInsets.all(2.5),
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color(widget.colorCode),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 20, right: 20 / 2),
                              padding: const EdgeInsets.all(2.5),
                              child: Text(
                                widget.color,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            widget.details,
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: SizedBox(
                            height: 50,
                            width: 200,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              color: Color(widget.colorCode),
                              onPressed: () {},
                              child: Text(
                                "Add to Cart".toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Product Name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Product Name",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              widget.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20.0),
                        //Product Price and Image
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                const TextSpan(text: "Price\n"),
                                TextSpan(
                                  text: "Tk. ${widget.price}/-",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                )
                              ]),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Hero(
                                tag: widget.id,
                                child: Image.network(
                                  widget.image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
