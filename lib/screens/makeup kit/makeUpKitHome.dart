import 'dart:math';

import 'package:careofbeauty/screens/drawer/mainDrawer.dart';
import 'package:careofbeauty/screens/products/productDetail.dart';
import 'package:careofbeauty/screens/products/productDetail2.dart';
import 'package:careofbeauty/screens/skintone/skintone.dart';
import 'package:careofbeauty/services/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MakeUpKitHome extends StatefulWidget {
  @override
  _MakeUpKitHomeState createState() => _MakeUpKitHomeState();
}

class _MakeUpKitHomeState extends State<MakeUpKitHome> {
  //Creating Search Filters
  List<String> categories = [
    "Facepowder",
    "Foundation",
    "Lipstick",
    "Only Men"
  ];
  int selectedIndex = 0;
  List<String> lipStickColors = [
    "All",
    "Coral",
    "Nude",
    "Pink",
    "Purple",
    "Red",
    "Wine"
  ];
  List<String> skinTone = ["All", "Fair", "Medium", "Deep"];

  String selectedLipStickColor = "All";
  String selectedSkinTone = "All";
  String _skinTone;

  //Getting skin tone from database
  getSkinTone() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        value.data().forEach((key, value) {
          if (key == 'skintone') {
            setState(() {
              _skinTone = value;
            });
          }
        });
      });
    } catch (e) {
      toast(e.message);
    }
  }

  @override
  void initState() {
    super.initState();
    getSkinTone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        elevation: 0.0,
        title: Text("Makeup Kit"),
        actions: [
          selectedIndex != 3
              ? IconButton(
                  icon: Icon(Icons.filter_list_alt),
                  onPressed: () {
                    if (selectedIndex == 0 || selectedIndex == 1) {
                      showBottomFilterMenu();
                    } else if (selectedIndex == 2) {
                      showBottomFilterMenu2();
                    } else {
                      toast("Filter not available for this section");
                    }
                  }.call)
              : Container(),
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          //Calling Makeup kit filter menu
          makeUpKitMenuFilter(),
          //Calling Makeup kit Products Grid View
          makeUpKitGridView(),
        ],
      ),
    );
  }

  //Creating Single Items of the products for GridView
  InkWell gridViewSingleItem(
      BuildContext context,
      String pUrl,
      String pId,
      String pName,
      int pPrice,
      String pCodeNTag,
      String pColor,
      String pDetails) {
    if (selectedIndex == 3) {
      return buildingConditionalSingleItem2(
          pUrl, pId, pName, pPrice, pCodeNTag, pDetails, context);
    } else {
      return buildingConditionalSingleItem(
          pUrl, pId, pName, pPrice, pCodeNTag, pColor, pDetails, context);
    }
  }

  //Single item except Men's section
  InkWell buildingConditionalSingleItem(
      String pUrl,
      String pId,
      String pName,
      int pPrice,
      String pCodeNTag,
      String pColor,
      String pDetails,
      BuildContext context) {
    Color color;
    if (pColor == "Fair" || pColor == "Medium" || pColor == "Deep") {
      color = Colors.primaries[Random().nextInt(Colors.primaries.length)]
          [Random().nextInt(9) * 100];
      return lipstickOrNotSingleItem(
          pUrl, pId, pName, pPrice, pCodeNTag, color, pDetails, context);
    } else {
      return lipstickOrNotSingleItem2(
          pUrl, pId, pName, pPrice, pCodeNTag, pColor, pDetails, context);
    }
  }

  //Single Item except Lipstick
  InkWell lipstickOrNotSingleItem(
      String pUrl,
      String pId,
      String pName,
      int pPrice,
      String pCodeNTag,
      Color pColor,
      String pDetails,
      BuildContext context) {
    return InkWell(
      onTap: () {
        var route = MaterialPageRoute(
            builder: (context) => ProductDetail2(
                  image: pUrl,
                  id: pId,
                  name: pName,
                  price: pPrice,
                  tag: pCodeNTag,
                  color: pColor,
                  details: pDetails,
                ));
        Navigator.of(context).push(route);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              height: 158.0,
              width: 160.0,
              decoration: BoxDecoration(
                color: pColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Hero(
                    tag: pId,
                    child: Image.network(
                      pUrl,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;

                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0 / 4.0),
              child: Text(
                pName,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Text(
              "Tk. " + pPrice.toString() + "/-",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  //Single Item only Lipstick
  InkWell lipstickOrNotSingleItem2(
      String pUrl,
      String pId,
      String pName,
      int pPrice,
      String pCodeNTag,
      String pColor,
      String pDetails,
      BuildContext context) {
    return InkWell(
      onTap: () {
        var route = MaterialPageRoute(
            builder: (context) => ProductDetail(
                  image: pUrl,
                  id: pId,
                  name: pName,
                  price: pPrice,
                  colorCode: int.parse(pCodeNTag),
                  color: pColor,
                  details: pDetails,
                ));
        Navigator.of(context).push(route);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              height: 158.0,
              width: 160.0,
              decoration: BoxDecoration(
                color: Color(int.parse(pCodeNTag)),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Hero(
                    tag: pId,
                    child: Image.network(
                      pUrl,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;

                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0 / 4.0),
              child: Text(
                pName,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Text(
              "Tk. " + pPrice.toString() + "/-",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  //Single item only Men's section
  InkWell buildingConditionalSingleItem2(String pUrl, String pId, String pName,
      int pPrice, String pCodeNTag, String pDetails, BuildContext context) {
    final color = Colors.primaries[Random().nextInt(Colors.primaries.length)]
        [Random().nextInt(9) * 100];
    return InkWell(
      onTap: () {
        var route = MaterialPageRoute(
            builder: (context) => ProductDetail2(
                  image: pUrl,
                  id: pId,
                  name: pName,
                  price: pPrice,
                  tag: pCodeNTag,
                  color: color,
                  details: pDetails,
                ));
        Navigator.of(context).push(route);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              height: 158.0,
              width: 160.0,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Hero(
                    tag: pId,
                    child: Image.network(
                      pUrl,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;

                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0 / 4.0),
              child: Text(
                pName,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Text(
              "Tk. " + pPrice.toString() + "/-",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  //Makeup Kit Filters Menu
  Widget makeUpKitMenuFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 30.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildMakeUpKitFilterItems(
              index), //Creating all the items in the search filter list
        ),
      ),
    );
  }

  //Menu items for Makeup kit Filters Menu Items
  Widget buildMakeUpKitFilterItems(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedIndex != index) {
            selectedIndex = index;
            selectedSkinTone = "All";
            selectedLipStickColor = "All";
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categories[index],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: selectedIndex == index ? Colors.black : Colors.grey),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0 / 4.0),
              height: 2.0,
              width: (categories[index].length.toDouble()) * 5.0,
              color: selectedIndex == index ? Colors.amber : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  //Grid View of Makeup kit Products
  Expanded makeUpKitGridView() {
    //Query variable
    Stream<QuerySnapshot> finalQuery;

    if (selectedIndex == 0) {
      if (selectedSkinTone != "All") {
        finalQuery = FirebaseFirestore.instance
            .collection("makeup kit")
            .where("search_tag", isEqualTo: "Facepowder")
            .where("color", isEqualTo: selectedSkinTone)
            .snapshots();
      } else {
        finalQuery = FirebaseFirestore.instance
            .collection("makeup kit")
            .where("search_tag", isEqualTo: "Facepowder")
            .snapshots();
      }
    } else if (selectedIndex == 1) {
      if (selectedSkinTone != "All") {
        finalQuery = FirebaseFirestore.instance
            .collection("makeup kit")
            .where("search_tag", isEqualTo: "Foundation")
            .where("color", isEqualTo: selectedSkinTone)
            .snapshots();
      } else {
        finalQuery = FirebaseFirestore.instance
            .collection("makeup kit")
            .where("search_tag", isEqualTo: "Foundation")
            .snapshots();
      }
    } else if (selectedIndex == 2) {
      if (selectedLipStickColor != "All") {
        finalQuery = FirebaseFirestore.instance
            .collection("makeup kit")
            .where("search_tag", isEqualTo: "Lipstick")
            .where("color", isEqualTo: selectedLipStickColor)
            .snapshots();
      } else {
        finalQuery = FirebaseFirestore.instance
            .collection("makeup kit")
            .where("search_tag", isEqualTo: "Lipstick")
            .snapshots();
      }
    } else {
      finalQuery = FirebaseFirestore.instance.collection("makeup kit").where(
          "search_tag",
          whereNotIn: ["Facepowder", "Foundation", "Lipstick"]).snapshots();
    }

    return queryAndSingleItem(finalQuery);
  }

  //Passing database query and building stream builder & grid view with single items
  Expanded queryAndSingleItem(Stream<QuerySnapshot> query) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: StreamBuilder(
            stream: query,
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapShot) {
              if (streamSnapShot.connectionState == ConnectionState.waiting)
                return Text("Loading...");
              return GridView.builder(
                  itemCount: streamSnapShot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    if (selectedIndex == 0 || selectedIndex == 1) {
                      return gridViewSingleItem(
                          context,
                          streamSnapShot.data.docs[index]['url'],
                          streamSnapShot.data.docs[index]['id'],
                          streamSnapShot.data.docs[index]['name'],
                          streamSnapShot.data.docs[index]['price'],
                          streamSnapShot.data.docs[index]['search_tag'],
                          streamSnapShot.data.docs[index]['color'],
                          streamSnapShot.data.docs[index]['details']);
                    } else if (selectedIndex == 2) {
                      return gridViewSingleItem(
                          context,
                          streamSnapShot.data.docs[index]['url'],
                          streamSnapShot.data.docs[index]['id'],
                          streamSnapShot.data.docs[index]['name'],
                          streamSnapShot.data.docs[index]['price'],
                          streamSnapShot.data.docs[index]['colorcode'],
                          streamSnapShot.data.docs[index]['color'],
                          streamSnapShot.data.docs[index]['details']);
                    } else {
                      return gridViewSingleItem(
                          context,
                          streamSnapShot.data.docs[index]['url'],
                          streamSnapShot.data.docs[index]['id'],
                          streamSnapShot.data.docs[index]['name'],
                          streamSnapShot.data.docs[index]['price'],
                          streamSnapShot.data.docs[index]['search_tag'],
                          "",
                          streamSnapShot.data.docs[index]['details']);
                    }
                  });
            }),
      ),
    );
  }

  //Filter Modal Bottom Sheet Menu 1
  void showBottomFilterMenu() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: Column(
                children: [
                  //Dropdown Menu Skin Tone
                  SizedBox(height: 20),
                  Text(
                    "Skin Tone",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedSkinTone,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.amber,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        selectedSkinTone = newValue;
                      });
                      Navigator.of(context).pop();
                    },
                    items:
                        skinTone.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),

                  //Select Skin Tone from Photo
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  Text(
                    "Skin Tone From Photo",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                    onPressed: () {
                      if (_skinTone.contains("None")) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SkinTone()));
                      } else {
                        setState(() {
                          selectedSkinTone = _skinTone;
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: _skinTone != "None"
                        ? Text("Set Skin Tone: " + _skinTone)
                        : Text("Set Skin Tone"),
                  ),

                  SizedBox(height: 40),
                  Divider(height: 1, thickness: 3, color: Colors.grey),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                    onPressed: () {
                      setState(() {
                        selectedSkinTone = "All";
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Clear Filter"),
                  ),
                ],
              ),
            );
          });
        }).whenComplete(() {
      setState(() {});
    });
  }

  //Filter Modal Bottom Sheet Menu 2
  void showBottomFilterMenu2() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: Column(
                children: [
                  //Dropdown Menu Color
                  SizedBox(height: 20),
                  Text(
                    "Color",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedLipStickColor,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.amber,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        selectedLipStickColor = newValue;
                      });
                      Navigator.of(context).pop();
                    },
                    items: lipStickColors
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 40),
                  Divider(height: 1, thickness: 3, color: Colors.grey),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                    onPressed: () {
                      setState(() {
                        selectedLipStickColor = "All";
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Clear Filter"),
                  ),
                ],
              ),
            );
          });
        }).whenComplete(() {
      setState(() {});
    });
  }
}
