import 'package:cached_network_image/cached_network_image.dart';
import 'package:fakestore/controller/home/home_controller.dart';
import 'package:fakestore/model/colors.dart';
import 'package:fakestore/model/products/products.dart';
import 'package:fakestore/model/utils.dart';
import 'package:fakestore/view/profile/profile_page.dart';
import 'package:fakestore/view/ui/circular_progress.dart';
import 'package:fakestore/view/ui/progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Image.asset(
              Utils().imageLogoAsset,
              width: 50,
              height: 50,
            ),
            actions: [
              GestureDetector(
                  onTap: (){
                    Get.to(ProfileScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
                    child: Icon(Icons.supervised_user_circle,size: 40,),
                  ))
            ],

          ),
          drawer: Drawer(
            child: Column(
              children: [
                ListTile(
                  onTap: () => _.onCloseSession(),
                  title: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Logout'),
                          Icon(Icons.logout_outlined),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          body: ProgressHUD(
            loading: _.isLoading,
            child: SafeArea(
              child: GetBuilder<HomeController>(
                id: 'ListProducts',
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 20,
                      ),
                      itemCount: _.products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildCard(_.products[index], context, _,index);
                      },
                    ),
                  );
                },
              ),
            ),
          ),

        );
      },
    );
  }

  Widget _buildCard(Product item, BuildContext context, HomeController _,int index) {
    return Container(
      height: 200,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: FSColors.cardColor,
        borderRadius: BorderRadius.circular(
          25,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              top: 15,
              bottom: 15,
              left: 25,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: double.maxFinite,
                    height: 130.0,
                    fit: BoxFit.scaleDown,
                    imageUrl: item.image!,
                    placeholder: (context, url) => SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgress(
                        width: 10,
                        height: 10,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/sinimagen.png',
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 5,
              left: 170,
              child: SizedBox(
                width: double.minPositive,
                child: Text(
                  item.title!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
            Positioned(
              top: 155,
              right: 5,
              left: 170,
              child: SizedBox(
                width: double.minPositive,
                child: Text(
                  '\$ ${item.price.toString()}',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
            Positioned(
              top: 140,
              right: 5,
              child: OutlinedButton(
                onPressed: () => _.goToDetailProduct(item.id.toString(),item),
                child: Text(
                  "Buy",
                  style: const TextStyle().copyWith(
                    color: FSColors.purple,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                onPressed: () {
                  _.onTapFavourite(index);
                },
                icon:  Icon(
                  _.productsfavourite.contains(_.products[index].id.toString())?Icons.favorite:Icons.favorite_outline_outlined,
                  color: _.productsfavourite.contains(_.products[index].id.toString())?Colors.red:Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
