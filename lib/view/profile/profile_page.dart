

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import '../../controller/profile/profile_controller.dart';
import '../ui/fs_textformfield.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());





  @override
  Widget build(BuildContext context) {

   return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (_) {
        return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Obx(() {
                  if (profileController.currentUser.value != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _.pickImage,
                          child: Stack(
                            children: [
                              Obx(() =>  CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(_.profile.value !="" ? _.profile.value : 'https://i.pinimg.com/originals/7d/34/d9/7d34d9d53640af5cfd2614c57dfa7f13.png',),
                              )),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        FSTextFormField(
                          controller: _.nameController,
                          keyboardType: TextInputType.text,
                          validator: _.validateUserName,
                          label: "UserName",
                        ),
                        SizedBox(height: 10),
                        FSTextFormField(
                          controller: _.emailController,
                          keyboardType: TextInputType.text,
                          validator: _.validateUserName,
                          label: "Email",
                          readonly: true,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              _.updateProfile();
                            },
                            child: Text('Update Profile'),
                          ),
                        SizedBox(height: 20),
                        // Add more fields as needed
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
              ),
            ),
          ),
        ),
      );
    }
   );
  }
}
