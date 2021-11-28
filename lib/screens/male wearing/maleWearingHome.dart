import 'package:careofbeauty/screens/drawer/mainDrawer.dart';
import 'package:careofbeauty/screens/products/productDetail.dart';
import 'package:careofbeauty/screens/skintone/skintone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careofbeauty/services/toast.dart';

class MaleWearingHome extends StatefulWidget {
  @override
  _MaleWearingHomeState createState() => _MaleWearingHomeState();
}

class _MaleWearingHomeState extends State<MaleWearingHome> {
  //Creating Search Filters
  List<String> categories = ["All", "Shirt", "Panjabi", "Watch"];
  int selectedIndex = 0;
  List<String> maleColors = [
    "All",
    "Baby Blue",
    "Beige",
    "Black",
    "Bold Blue",
    "Brown",
    "Grey",
    "Khaki",
    "Light Blue",
    "Maroon",
    "Navy Blue",
    "Pink",
    "Purple",
    "Royal Blue",
    "Yellow"
  ];
  List<String> fairSkinColor = [
    "Beige",
    "Bold Blue",
    "Brown",
    "Light Blue",
    "Yellow"
  ];
  List<String> mediumSkinColor = [
    "Black",
    "Maroon",
    "Navy Blue",
    "Pink",
    "Royal Blue"
  ];
  List<String> deepSkinColor = ["Baby Blue", "Grey", "Khaki", "Pink", "Purple"];

  String selectedFilterOptions = "All";
  String selectedMaleColors = "All";
  String selectedSkinTone = "All";
  bool _colorMode = false;
  bool _skinToneMode = false;
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
        title: Text("Male Wearing"),
        actions: [
          IconButton(
              icon: Icon(Icons.filter_list_alt),
              onPressed: () {
                showBottomFilterMenu();
              }.call),
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          //Calling Male Wearing filter menu
          maleWearingMenuFilter(),
          //Calling Male Products Grid View
          maleWearingGridView(),
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
      String pColorCode,
      String pColor,
      String pDetails) {
    return InkWell(
      onTap: () {
        var route = MaterialPageRoute(
            builder: (context) => ProductDetail(
                  image: pUrl,
                  id: pId,
                  name: pName,
                  price: pPrice,
                  colorCode: int.parse(pColorCode),
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
                color: Color(int.parse(pColorCode)),
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

  //Male Wearing Filters Menu
  Widget maleWearingMenuFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 30.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildMaleFilterItems(
              index), //Creating all the items in the search filter list
        ),
      ),
    );
  }

  //Menu items for Male Wearing Filters Menu Items
  Widget buildMaleFilterItems(int index) {
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

  //Grid View of Male Wearing Products
  Expanded maleWearingGridView() {
    //Query variable
    Stream<QuerySnapshot> finalQuery;

    //Setting up final query for Filter: Color
    if (selectedMaleColors != "All" && selectedSkinTone == "All") {
      if (selectedIndex == 1) {
        finalQuery = FirebaseFirestore.instance
            .collection("male")
            .where("tag", isEqualTo: "Shirt")
            .where("color", isEqualTo: selectedMaleColors)
            .snapshots();
      } else if (selectedIndex == 2) {
        finalQuery = FirebaseFirestore.instance
            .collection("male")
            .where("tag", isEqualTo: "Panjabi")
            .where("color", isEqualTo: selectedMaleColors)
            .snapshots();
      } else if (selectedIndex == 3) {
        finalQuery = FirebaseFirestore.instance
            .collection("male")
            .where("tag", isEqualTo: "malewatch")
            .where("color", isEqualTo: selectedMaleColors)
            .snapshots();
      } else {
        finalQuery = FirebaseFirestore.instance
            .collection("male")
            .where("color", isEqualTo: selectedMaleColors)
            .snapshots();
      }
    }
    //Setting up final query for Filter: Skin Tone
    else if (selectedMaleColors == "All" && selectedSkinTone != "All") {
      //Setting final query based on Fair, Medium & Deep skin tone
      switch (selectedSkinTone) {
        case "Fair":
          if (selectedIndex == 1) {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("tag", isEqualTo: "Shirt")
                .where("color", whereIn: fairSkinColor)
                .snapshots();
          } else if (selectedIndex == 2) {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("tag", isEqualTo: "Panjabi")
                .where("color", whereIn: fairSkinColor)
                .snapshots();
          } else if (selectedIndex == 3) {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("tag", isEqualTo: "malewatch")
                .where("color", whereIn: fairSkinColor)
                .snapshots();
          } else {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("color", whereIn: fairSkinColor)
                .snapshots();
          }
          break;
        case "Medium":
          if (selectedIndex == 1) {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("tag", isEqualTo: "Shirt")
                .where("color", whereIn: mediumSkinColor)
                .snapshots();
          } else if (selectedIndex == 2) {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("tag", isEqualTo: "Panjabi")
                .where("color", whereIn: mediumSkinColor)
                .snapshots();
          } else if (selectedIndex == 3) {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("tag", isEqualTo: "malewatch")
                .where("color", whereIn: mediumSkinColor)
                .snapshots();
          } else {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("color", whereIn: mediumSkinColor)
                .snapshots();
          }
          break;
        case "Deep":
          if (selectedIndex == 1) {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("tag", isEqualTo: "Shirt")
                .where("color", whereIn: deepSkinColor)
                .snapshots();
          } else if (selectedIndex == 2) {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("tag", isEqualTo: "Panjabi")
                .where("color", whereIn: deepSkinColor)
                .snapshots();
          } else if (selectedIndex == 3) {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("tag", isEqualTo: "malewatch")
                .where("color", whereIn: deepSkinColor)
                .snapshots();
          } else {
            finalQuery = FirebaseFirestore.instance
                .collection("male")
                .where("color", whereIn: deepSkinColor)
                .snapshots();
          }
          break;
      }
    }
    //Setting up final query for Filter: All
    else {
      if (selectedIndex == 1) {
        finalQuery = FirebaseFirestore.instance
            .collection("male")
            .where("tag", isEqualTo: "Shirt")
            .snapshots();
      } else if (selectedIndex == 2) {
        finalQuery = FirebaseFirestore.instance
            .collection("male")
            .where("tag", isEqualTo: "Panjabi")
            .snapshots();
      } else if (selectedIndex == 3) {
        finalQuery = FirebaseFirestore.instance
            .collection("male")
            .where("tag", isEqualTo: "malewatch")
            .snapshots();
      } else {
        finalQuery = FirebaseFirestore.instance.collection("male").snapshots();
      }
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
                        streamSnapShot.data.docs[index]['colorcode'],
                        streamSnapShot.data.docs[index]['color'],
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
                            _colorMode = false;
                            _skinToneMode = false;
                            selectedMaleColors = "All";
                            selectedSkinTone = "All";
                            break;
                          case "Color":
                            _colorMode = true;
                            _skinToneMode = false;
                            selectedSkinTone = "All";
                            break;
                          case "Skin Tone":
                            _colorMode = false;
                            _skinToneMode = true;
                            selectedMaleColors = "All";
                            break;
                        }
                      });
                    },
                    items: <String>["All", "Color", "Skin Tone"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),

                  //Dropdown Menu Color
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  Text(
                    "Color",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IgnorePointer(
                    ignoring: !_colorMode,
                    child: DropdownButton<String>(
                      value: selectedMaleColors,
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
                          selectedMaleColors = newValue;
                        });
                        Navigator.of(context).pop();
                      },
                      items: maleColors
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                  //Dropdown Menu Skin Tone
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  Text(
                    "Skin Tone",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IgnorePointer(
                    ignoring: !_skinToneMode,
                    child: DropdownButton<String>(
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
                      items: <String>["All", "Fair", "Medium", "Deep"]
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
                          selectedFilterOptions = "Skin Tone";
                          selectedMaleColors = "All";
                          _colorMode = false;
                          _skinToneMode = true;
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
                        selectedFilterOptions = "All";
                        selectedMaleColors = "All";
                        selectedSkinTone = "All";
                        _colorMode = false;
                        _skinToneMode = false;
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
