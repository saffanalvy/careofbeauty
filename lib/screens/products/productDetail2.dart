import 'package:careofbeauty/screens/drawer/mainDrawer.dart';
import 'package:flutter/material.dart';

class ProductDetail2 extends StatefulWidget {
  final String image;
  final String id;
  final String name;
  final int price;
  final String tag;
  final Color color;
  final String details;

  ProductDetail2(
      {Key key,
      this.image,
      this.id,
      this.name,
      this.price,
      this.tag,
      this.color,
      this.details})
      : super(key: key);

  @override
  _ProductDetail2State createState() => _ProductDetail2State();
}

class _ProductDetail2State extends State<ProductDetail2> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: widget.color,
      appBar: AppBar(
        backgroundColor: widget.color,
        elevation: 0.0,
        title: Text("Detail"),
      ),
      drawer: MainDrawer(),
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
                    decoration: BoxDecoration(
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
                            Text("Product: "),
                            Container(
                              margin: EdgeInsets.only(right: 20 / 2),
                              padding: EdgeInsets.all(2.5),
                              child: Text(
                                "${widget.tag}".toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "${widget.details}",
                            style: TextStyle(height: 1.5),
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
                              color: widget.color,
                              onPressed: () {},
                              child: Text(
                                "Add to Cart".toUpperCase(),
                                style: TextStyle(
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
                            Text(
                              "Product Name",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "${widget.name}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.0),
                        //Product Price and Image
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(text: "Price\n"),
                                TextSpan(
                                  text: "Tk. " + "${widget.price}" + "/-",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                )
                              ]),
                            ),
                            SizedBox(width: 20.0),
                            Expanded(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Hero(
                                tag: widget.id,
                                child: Image.network(
                                  "${widget.image}",
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
