import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:matjer/business_logic/shop_cubit/shop_cubit.dart';
import 'package:matjer/constance/strings.dart';
import 'package:matjer/helper/shared_prefrence_helper.dart';
import 'package:matjer/persentation/screens/login_screen.dart';

import '../../../constance/colors.dart';
import '../../../constance/components.dart';
import '../../../constance/styles.dart';
import '../profile_screens_in/edit_profile.dart';

class ShopProfileWidget extends StatelessWidget {
  const ShopProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shopCubit = ShopCubit.get(context);
    return Conditional.single(
        context: context,
        conditionBuilder: (context) => shopCubit.userProfileData!.status,
        widgetBuilder: (context) => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    shopCubit.userProfileData!.data!.name!,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    shopCubit.userProfileData!.data!.email!,
                    style: TextStyle(color: Colors.grey),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit Profile',
                            style: white14regular(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.arrow_forward_ios_outlined, size: 18),
                        ],
                      ),

                    ),
                    onTap: (){
                      navigateTo(context: context,widget: EditProfileScreen());
                    },
                  ),
                  SeperatedItem(title: "Content",context:context),
                  ItemComponent(
                      title: "Favorite",
                      prefixIcon: Icons.favorite_border,
                      onTap: () {
                        //TODO: Favorite button
                      },
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 19,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(0.5),
                      ),
                      context: context),
                  const SizedBox(height: 15),
                  ItemComponent(
                    title: "Cart",
                    prefixIcon: Icons.shopping_cart,
                    context: context,
                    onTap: () {
                      //TODO: Cart button
                    },
                    suffixIcon: Icon(
                      Icons.arrow_forward_ios,
                      size: 19,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ItemComponent(
                    title: "Settings",
                    context: context,
                    prefixIcon: Icons.settings,
                    onTap: () {
                      //TODO: Settings button
                    },
                    suffixIcon: Icon(
                      Icons.arrow_forward_ios,
                      size: 19,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.5),
                    ),
                  ),
                  SeperatedItem(title: "Preferences",context:context),
                  ItemComponent(
                      title: "Language",
                      prefixIcon: Icons.language,
                      onTap: () {},
                      suffixIcon: Row(
                        children: [
                          Text(
                            "English",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 19,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.5),
                          ),
                        ],
                      ),
                      context: context),
                  const SizedBox(height: 10),
                  ItemComponent(
                    title: "Dark Mode",
                    prefixIcon: Icons.mode_night_outlined,
                    onTap: () {
                      ShopCubit.get(context).changeThemeMode();
                    },
                    suffixIcon: Switch(
                        value: shopCubit.isDarkTheme,
                        onChanged: (val) {
                          ShopCubit.get(context).changeThemeMode();
                        }),
                    context: context,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 40.0,
                    margin: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyColors.myPrimary,
                      borderRadius: BorderRadius.circular(
                        3.0,
                      ),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        token = '';
                        SharedPreferenceHelper.removeData(key: setTokenKey);
                        ShopCubit.get(context).currentIndex = 0;
                        navigateAndFinish(
                            context: context, widget: LoginScreen());
                      },
                      child: Text(
                        "Sign out".toUpperCase(),
                        style: white14bold(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        fallbackBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}

// Widget that separated between elements
Widget SeperatedItem({required String title,required context}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    width: double.infinity,
    color: Colors.grey.withOpacity(0.15),
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    child: Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.4)),
    ),
  );
}

Widget ItemComponent({
  required String title,
  required IconData prefixIcon,
  required dynamic onTap,
  required dynamic suffixIcon,
  required context,
}) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              prefixIcon,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.5),
              ),
            ),
            const Spacer(),
            suffixIcon,
          ],
        ),
      ));
}
