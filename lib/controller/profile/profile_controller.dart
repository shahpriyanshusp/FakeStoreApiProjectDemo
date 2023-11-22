import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxString profile="".obs;

  late Rx<User?> currentUser; // Rx variable to hold the currently logged-in user


  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File image = File(pickedFile.path);
        // Call the function to upload the selected image
        uploadProfilePicture(image);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> uploadProfilePicture(File imageFile) async {
    try {
      if (imageFile != null) {
        Reference reference =
        _storage.ref().child('profile_images/${currentUser.value!.uid}');
        await reference.putFile(imageFile);
        String imageUrl = await reference.getDownloadURL();
        await currentUser.value!.updatePhotoURL(imageUrl).then((value) {
          profile.value=currentUser.value!.photoURL ?? "";
          profile.update((val) { });
        });



      }
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }

  Future<void> updateProfile() async {
    if (nameController.text.trim().isNotEmpty && emailController.text.trim().isNotEmpty) {
      try {
        FocusScope.of(Get.context!).unfocus();
        await currentUser.value!.updateDisplayName(nameController.text.trim());
        // await currentUser.value!.updateEmail(emailController.text.trim());
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Name updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error updating name: $e');
      }
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('Please enter a name'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String? validateUserName(String? value) {
    if (value!.trim().isEmpty) {
      return "Enter your username.";
    } else if (!GetUtils.isUsername(value)) {
      return "Enter a valid user.";
    }
    return null;
  }



  @override
  void onInit() {
    super.onInit();
    currentUser = auth.currentUser.obs;
    profile.value=currentUser.value!.photoURL ?? "";
    nameController.text=currentUser.value!.displayName ?? "";
    emailController.text=currentUser.value!.email ?? "";
  }
}
