import 'dart:math';
import 'package:careofbeauty/screens/drawer/mainDrawer.dart';
import 'package:careofbeauty/screens/products/productDetail2.dart';
import 'package:careofbeauty/services/toast.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SkinCareHome extends StatefulWidget {
  @override
  _SkinCareHomeState createState() => _SkinCareHomeState();
}

class _SkinCareHomeState extends State<SkinCareHome> {
  //Creating Search Filters
  List<String> categories = ["Men", "Women"];
  int selectedIndex = 0;
  List<String> skinType = ["All", "Combination", "Dry", "Oily"];
  List<String> skinOptions = [
    "None",
    "Oily T-2 me only",
    "Have not enlarged pore",
    "Make up last",
    "Wrinkle after pressure on skin",
    "Blottering paper reveal oil",
    "Face looks greesy",
    "Face looks shiny",
    "Have pimples, acne",
    "Make up does not long last",
    "Pores are enlarged"
  ];

  String selectedFilterOptions = "All";
  String selectedSkinType = "All";
  String selectedSkinOption = "None";
  bool _skinTypeMode = false;
  bool _skinOptionMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        elevation: 0.0,
        title: Text("Skin Care"),
        actions: [
          selectedIndex != 0
              ? IconButton(
                  icon: Icon(Icons.filter_list_alt),
                  onPressed: () {
                    if (selectedIndex == 1) {
                      showBottomFilterMenu();
                    } else {
                      toast("Filter is only available for Women");
                    }
                  }.call)
              : Container(),
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          //Calling Skin Care filter menu
          skinCareMenuFilter(),
          //Calling Skin Care Products Grid View
          skinCareGridView(),
        ],
      ),
    );
  }

  //Creating Single Items of the products for GridView
  InkWell gridViewSingleItem(BuildContext context, String pUrl, String pId,
      String pName, int pPrice, String pProductTag, String pDetails) {
    //Setting random color for backgrounds
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
                  tag: pProductTag,
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

  //Skin care Filters Menu
  Widget skinCareMenuFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 30.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildSkinCareFilterItems(
              index), //Creating all the items in the search filter list
        ),
      ),
    );
  }

  //Menu items for Skin Care Filters Menu Items
  Widget buildSkinCareFilterItems(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
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

  //Grid View of Skin Care Products
  Expanded skinCareGridView() {
    //Query variable
    Stream<QuerySnapshot> finalQuery;

    if (selectedIndex == 1) {
      if (selectedSkinType != "All") {
        finalQuery = FirebaseFirestore.instance
            .collection("skin care")
            .where("search_tag", isEqualTo: selectedSkinType)
            .snapshots();
      } else if (selectedSkinOption != "None") {
        if (selectedSkinOption == skinOptions[1]) {
          finalQuery = FirebaseFirestore.instance
              .collection("skin care")
              .where("search_tag", isEqualTo: "Combination")
              .snapshots();
        } else if (selectedSkinOption == skinOptions[2] ||
            selectedSkinOption == skinOptions[3] ||
            selectedSkinOption == skinOptions[4]) {
          finalQuery = FirebaseFirestore.instance
              .collection("skin care")
              .where("search_tag", isEqualTo: "Dry")
              .snapshots();
        } else {
          finalQuery = FirebaseFirestore.instance
              .collection("skin care")
              .where("search_tag", isEqualTo: "Oily")
              .snapshots();
        }
      } else {
        finalQuery = FirebaseFirestore.instance
            .collection("skin care")
            .where("search_tag", isNotEqualTo: "only for men")
            .snapshots();
      }
    } else {
      finalQuery = FirebaseFirestore.instance
          .collection("skin care")
          .where("search_tag", isEqualTo: "only for men")
          .snapshots();
      selectedFilterOptions = "All";
      selectedSkinType = "All";
      selectedSkinOption = "None";
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
                    return gridViewSingleItem(
                        context,
                        streamSnapShot.data.docs[index]['url'],
                        streamSnapShot.data.docs[index]['id'],
                        streamSnapShot.data.docs[index]['name'],
                        streamSnapShot.data.docs[index]['price'],
                        streamSnapShot.data.docs[index]['product_tag'],
                        streamSnapShot.data.docs[index]['details']);
                  });
            }),
      ),
    );
  }

  //Filter Modal Bottom Sheet Menu
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
                  SizedBox(height: 20),
                  //Dropdown Menu Filter by
                  Text(
                    "Filter by",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedFilterOptions,
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
                        selectedFilterOptions = newValue;
                        switch (newValue) {
                          case "All":
                            _skinTypeMode = false;
                            _skinOptionMode = false;
                            selectedSkinType = "All";
                            selectedSkinOption = "None";
                            break;
                          case "Skin Type":
                            _skinTypeMode = true;
                            _skinOptionMode = false;
                            selectedSkinOption = "None";
                            break;
                          case "Skin Option":
                            _skinTypeMode = false;
                            _skinOptionMode = true;
                            selectedSkinType = "All";
                            break;
                        }
                      });
                    },
                    items: <String>["All", "Skin Type", "Skin Option"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),

                  //Dropdown Menu Skin Type
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  Text(
                    "Skin Type",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IgnorePointer(
                    ignoring: !_skinTypeMode,
                    child: DropdownButton<String>(
                      value: selectedSkinType,
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
                          selectedSkinType = newValue;
                        });
                        Navigator.of(context).pop();
                      },
                      items: skinType
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                  //Dropdown Menu Skin Option
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  Text(
                    "Skin Option",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IgnorePointer(
                    ignoring: !_skinOptionMode,
                    child: DropdownButton<String>(
                      value: selectedSkinOption,
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
                          selectedSkinOption = newValue;
                        });
                        Navigator.of(context).pop();
                      },
                      items: skinOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                  //Select Skin Tone from Photo
                  SizedBox(height: 20),
                  SizedBox(height: 20),

                  SizedBox(height: 40),
                  Divider(height: 1, thickness: 3, color: Colors.grey),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                    onPressed: () {
                      setState(() {
                        selectedFilterOptions = "All";
                        selectedSkinType = "All";
                        selectedSkinOption = "None";
                        _skinTypeMode = false;
                        _skinOptionMode = false;
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
