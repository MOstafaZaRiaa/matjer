import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matjer/business_logic/shop_cubit/shop_cubit.dart';
import 'package:matjer/business_logic/shop_cubit/shop_states.dart';
import 'package:matjer/constance/colors.dart';

import '../../../models/cart_model.dart';
import '../../widgets/default_button.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(listener: (context, state) {

          if(state is ShopLoadingGetCartState)
            {
              const Center(child: CircularProgressIndicator(color: MyColors.myPrimary,));
            }

    }, builder: (context, state) {
      final deviceWidth = MediaQuery.of(context).size.width;
      var cubit = ShopCubit.get(context);

      return  Conditional.single(
        context: context,
        fallbackBuilder: (context) =>SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(children: [
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return Container(
                    // padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: double.infinity,
                      child: BuildCartItem(
                          model: cubit
                              .cartModel!.data!.cartItems![i].product!,
                          context: context));
                },
                separatorBuilder: (context, i) {
                  return Divider(
                      color: Colors.black.withOpacity(0.1), thickness: 2);
                },
                itemCount:cubit.cartModel!.data!.cartItems!.length,
              ),
            ]),
          ),
        ),
        conditionBuilder: (context) =>
        cubit.cartModel?.data == null,
        widgetBuilder: (context) =>
         Center(
           child: SvgPicture.asset(
            'assets/images/empty_cart.svg',
            width: deviceWidth * 0.7,
        ),
         ),
      );
    });
  }

  Widget BuildCartItem(
      {required CartProduct model, required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              model.image.toString().toString(),
              height: 130,
              width: 110,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              width: 25,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16,color: Theme.of(context).textTheme.bodyText1!.color!),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "${model.price.toString()}\$",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.5),
                            fontSize: 15),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      model.discount != 0 ?
                      model.price != model.oldPrice || model.oldPrice != 0
                          ? Text(
                              "${model.oldPrice.toString()}\$",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color!
                                      .withOpacity(0.5),
                                  fontSize: 15),
                            )
                          : const SizedBox(
                              width: 0,
                            ):const SizedBox(width: 0),
                      Spacer(),
                      // model.discount != 0 ?
                      // Container(
                      //   padding: const EdgeInsets.all(7),
                      //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.red),
                      //   child: const Text("Discount",style: TextStyle(color: whiteColor),),
                      // ) : const SizedBox(width: 0),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // this is not enabled => needed to add logic for it
                  Row(
                    children: [
                      buildChooseProduct(
                          title: "Qty : 1", onTap: () {}, context: context),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        // const SizedBox(height: 10,),
        buildProductActions(model: model, context: context)
      ],
    );
  }

  Widget buildChooseProduct(
      {required String title, required dynamic onTap, required context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: MyColors.myPrimary,
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color!,fontSize: 14),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Theme.of(context).textTheme.bodyText2!.color!,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductActions(
      {required CartProduct model, required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DefaultButton(
            color: Colors.transparent,
            title: Row(
              children:  [
                Icon(
                  ShopCubit.get(context).favouritesInHomeScreen[model.id]!?
                  Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Add to Favorite",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            onTap: () {

              ShopCubit.get(context).changeProductFav(model.id);
            }),
        DefaultButton(
            color: Colors.transparent,
            title: Row(
              children: const [
                Icon(
                  Icons.delete,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Remove from Cart",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            onTap: () {
              ShopCubit.get(context).changeCartStatus(productId: model.id!);
            }),
      ],
    );
  }
}
