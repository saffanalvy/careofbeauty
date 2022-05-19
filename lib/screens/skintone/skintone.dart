import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tflite/tflite.dart';
import 'package:careofbeauty/services/toast.dart';
import 'package:flutter/material.dart';
import 'package:careofbeauty/screens/drawer/main_drawer.dart';
import 'package:image_picker/image_picker.dart';

class SkinTone extends StatefulWidget {
  const SkinTone({Key? key}) : super(key: key);

  @override
  _SkinToneState createState() => _SkinToneState();
}

class _SkinToneState extends State<SkinTone> {
  File? _image;
  List? _outputs;
  bool _loading = false;
  String _skinTone = "";

  //Getting skin tone from database
  getSkinTone() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        value.data()?.forEach((key, value) {
          if (key == 'skintone') {
            setState(() {
              _skinTone = value;
            });
          }
        });
      });
    } catch (e) {
      toast(e.toString());
    }
  }

  //ML dataset model files allocation
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/skintonemodel/model_unquant.tflite",
      labels: "assets/skintonemodel/labels.txt",
      numThreads: 1,
    );
  }

  //Recognize user's skin tone from photo
  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);
    setState(() {
      _loading = false;
      _outputs = output!;
    });
  }

  //Selecting photo from gallery
  pickImageFromGallery() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });

    classifyImage(_image!);
  }

  //Selecting photo from camera
  pickImageFromCamera() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });

    classifyImage(_image!);
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    getSkinTone();
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detect Skin Tone"),
        backgroundColor: Colors.amber[400],
        elevation: 0.0,
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 10),

          //Image Display
          Container(
            child: _loading
                ? Container(
                    height: 350,
                    width: 350,
                    child: const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.amber,
                      ),
                    ),
                  )
                : Center(
                    child: _image == null
                        ? Container(
                            height: 350,
                            width: 350,
                            child: const Center(
                                child: Text("No picture selected")))
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: 350,
                            width: 350,
                            child: Image.file(_image!)),
                  ),
          ),

          //Setting skin tone text based on database
          Center(
            child: _outputs != null
                ? Text("Your skin tone: " +
                    _outputs![0][
                        "label"]) //Setting the derived Skin label from Skin Tone model
                : _skinTone != null
                    ? Text("Your skin tone: " + _skinTone)
                    : const Text("Loading..."),
          ),

          const SizedBox(height: 10),
          const Divider(
            height: 0.5,
            thickness: 2,
            color: Colors.grey,
          ),

          const SizedBox(height: 10),
          //Set Image Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.amber),
                onPressed: pickImageFromCamera,
                child: const Text("Take Selfie"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.amber),
                onPressed: pickImageFromGallery,
                child: const Text("Pick from Gallery"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.amber),
                onPressed: () {
                  setState(() {
                    _image = null;
                    _outputs = null;
                    _loading = false;
                  });
                },
                child: const Text("Clear"),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(
            height: 0.5,
            thickness: 2,
            color: Colors.grey,
          ),

          const SizedBox(height: 10),

          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.amber),
              onPressed: () async {
                if (_outputs == null) {
                  toast("Select a picture first");
                  return;
                }
                //Updating database to new user skin tone
                try {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({'skintone': _outputs![0]["label"]});
                  _skinTone = _outputs![0]["label"];
                  toast("Skin tone saved");
                  Navigator.of(context).pop();
                } catch (e) {
                  toast(e.toString());
                }
              },
              child: const Text("Set Skin Tone"),
            ),
          ),
        ],
      ),
    );
  }
}
