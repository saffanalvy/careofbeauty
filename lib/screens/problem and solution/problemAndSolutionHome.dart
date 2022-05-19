import 'dart:math';
import 'package:careofbeauty/screens/drawer/main_drawer.dart';
import 'package:careofbeauty/screens/products/product_detail2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProblemAndSolutionHome extends StatefulWidget {
  const ProblemAndSolutionHome({Key? key}) : super(key: key);

  @override
  _ProblemAndSolutionHomeState createState() => _ProblemAndSolutionHomeState();
}

class _ProblemAndSolutionHomeState extends State<ProblemAndSolutionHome> {
  //Creating Search Filters
  List<String> categories = ["All", "Acne", "Dark spot", "Fungal", "Rash"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        elevation: 0.0,
        title: const Text("Problem & Solution"),
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          //Calling P&S filter menu
          probAndSolnMenuFilter(),
          //Calling P&S Products Grid View
          probAndSolnGridView(),
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
                  color: color!,
                  details: pDetails,
                ));
        Navigator.of(context).push(route);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
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

                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0 / 4.0),
              child: Text(
                pName,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Text(
              "Tk. " + pPrice.toString() + "/-",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  //P&S Filters Menu
  Widget probAndSolnMenuFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 30.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildProbAndSolnFilterItems(
              index), //Creating all the items in the search filter list
        ),
      ),
    );
  }

  //Menu items for P&S Filters Menu Items
  Widget buildProbAndSolnFilterItems(int index) {
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
              margin: const EdgeInsets.only(top: 20.0 / 4.0),
              height: 2.0,
              width: (categories[index].length.toDouble()) * 5.0,
              color: selectedIndex == index ? Colors.amber : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  //Grid View of P&S Products
  Expanded probAndSolnGridView() {
    //Query variable
    Stream<QuerySnapshot> finalQuery;

    if (selectedIndex != 0) {
      finalQuery = FirebaseFirestore.instance
          .collection("problem and solution")
          .where("search_tag", isEqualTo: categories[selectedIndex])
          .snapshots();
    } else {
      finalQuery = FirebaseFirestore.instance
          .collection("problem and solution")
          .snapshots();
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
              if (streamSnapShot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              }
              return GridView.builder(
                  itemCount: streamSnapShot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return gridViewSingleItem(
                        context,
                        streamSnapShot.data!.docs[index]['url'],
                        streamSnapShot.data!.docs[index]['id'],
                        streamSnapShot.data!.docs[index]['name'],
                        streamSnapShot.data!.docs[index]['price'],
                        streamSnapShot.data!.docs[index]['product_tag'],
                        streamSnapShot.data!.docs[index]['details']);
                  });
            }),
      ),
    );
  }
}
