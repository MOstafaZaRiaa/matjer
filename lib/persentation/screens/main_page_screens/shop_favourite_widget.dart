import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matjer/business_logic/shop_cubit/shop_states.dart';

import '../../../business_logic/shop_cubit/shop_cubit.dart';
import '../../../constance/colors.dart';
import '../../../data/models/favourite_model.dart';

class ShopFavouriteWidget extends StatelessWidget {
  const ShopFavouriteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          if(state is ShopLoadingGetFavoritesState){
             const Center(child: CircularProgressIndicator(),);
          }
        },
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          final deviceWidth = MediaQuery.of(context).size.width;
          return Scaffold(
            body: Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  cubit.favoritesModel!.data!.total != 0 ||
                  cubit.favoritesModel == null,
              widgetBuilder: (context) => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(children: [
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              width: double.infinity,
                              child: buildFavouriteItem(
                                  favoriteProduct: cubit
                                      .favoritesModel!.data!.data![i].product!,
                                  context: context));
                        },
                        separatorBuilder: (context, i) {
                          return const SizedBox(height: 10);
                        },
                        itemCount: cubit.favoritesModel!.data!.data!.length),
                  ]),
                ),
              ),
              fallbackBuilder: (context) => Center(
                child: SvgPicture.asset(
                  'assets/images/wishlist.svg',
                  width: deviceWidth * 0.7,
                ),
              ),
            ),
          );
        });
  }

  Widget buildFavouriteItem(
      {required FavoriteProduct favoriteProduct, required context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .19,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              CachedNetworkImage(
                height: 120,
                width: 110,
                imageUrl: favoriteProduct.image.toString(),
                imageBuilder: (context, imageProvider) => Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imageProvider,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(
                  child: Image.asset(
                    'assets/images/placehlder.gif',
                    height: 120,
                    width: 110,
                    fit: BoxFit.fill,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Row(
                children: [
                  if (favoriteProduct.discount != 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      color: Colors.red[900],
                      child: const Text(
                        'DISCOUNT',
                        style: TextStyle(color: Colors.white, fontSize: 8.0),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  favoriteProduct.name.toString().toUpperCase(),
                  maxLines: 2,
                  style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis),
                ),
                Row(
                  children: [
                    Text(
                      '${favoriteProduct.price!.round()}',
                      style: const TextStyle(
                          height: 1.3,
                          color: MyColors.myPrimary,
                          fontSize: 12.0),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    if (favoriteProduct.discount != 0)
                      Text(
                        '${favoriteProduct.oldPrice!.round()}',
                        style: const TextStyle(
                            height: 1.3,
                            color: Colors.grey,
                            fontSize: 10.0,
                            decoration: TextDecoration.lineThrough),
                      ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        ShopCubit.get(context)
                                .favouritesInHomeScreen[favoriteProduct.id]!
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        ShopCubit.get(context)
                            .changeProductFav(favoriteProduct.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
