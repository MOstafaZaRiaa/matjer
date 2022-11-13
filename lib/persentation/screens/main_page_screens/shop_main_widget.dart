import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:matjer/constance/colors.dart';

import '../../../business_logic/shop_cubit/shop_cubit.dart';
import '../../../business_logic/shop_cubit/shop_states.dart';
import '../../../constance/components.dart';
import '../../../data/models/categories_model.dart';
import '../../../data/models/home_model.dart';
import '../product_details_screen.dart';

class ShopMainWidget extends StatelessWidget {
  const ShopMainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShopCubit cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (state.model.status == false) {
            showToast(text: state.model.message, color: ToastColors.ERROR);
          }
        }
      },
      builder: (context, state) {
        return Conditional.single(
          context: context,
          widgetBuilder: (context) =>
              productsBuilder(cubit.homeModel, cubit.categoriesModel, context),
          conditionBuilder: (context) =>
          cubit.homeModel != null && cubit.categoriesModel != null,
          fallbackBuilder: (context) =>
          const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget productsBuilder(HomeModel? model, CategoriesModel? categoriesModel,
      context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model!.data!.banners
                  .map(
                    (e) =>
                    CachedNetworkImage(
                      imageUrl: '${e.image}',
                      placeholder: (context, url) =>
                          Center(
                            child: Image.asset('assets/images/placehlder.gif'),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: double.infinity,
                      height: 150.0,
                    ),
              )
                  .toList(),
              options: CarouselOptions(
                  height: 250.0,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style:
                    TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          buildCategoryItem(
                              categoriesModel.data!.data[index], context),
                      itemCount: categoriesModel!.data!.data.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(
                        width: 20.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'New Products',
                    style:
                    TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 3.0,
                childAspectRatio: 1 / 1.3,
                crossAxisCount: 2,
                children: List.generate(
                    model.data!.products.length,
                        (index) =>
                        buildGridProducts(
                            model.data!.products[index], context, index)),
              ),
            )
          ],
        ),
      );

  Widget buildGridProducts(ProductModel? model, context, productIndex) =>
      InkWell(onTap: () {
        navigateTo(context:context,widget:DetailsScreen(model) );
      },
        child: Card(
          color: Theme
              .of(context)
              .cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  CachedNetworkImage(
                    imageUrl: '${model!.image}',
                    placeholder: (context, url) =>
                        Center(
                          child: Image.asset('assets/images/placehlder.gif'),
                        ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: double.infinity,
                    height: 150.0,
                  ),
                  Row(
                    children: [
                      if (model.discount != 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          color: Colors.red[900],
                          child: const Text(
                            'DISCOUNT',
                            style: TextStyle(
                                color: Colors.white, fontSize: 8.0),
                          ),
                        ),
                      Spacer(),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            print('Icon Button ShopCubit');
                            ShopCubit.get(context).changeProductFav(model!.id,);
                            // ShopCubit.get(context).changeFavorites(model!.id);
                            // ShopCubit.get(context).getFavoriteData();
                          },
                          icon: Icon(ShopCubit
                              .get(context)
                              .favouritesInHomeScreen[model?.id]! ? Icons
                              .favorite :
                          Icons.favorite_border,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          )),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(height: 1.3,
                          color: Theme
                              .of(context)
                              .textTheme
                              .subtitle1!
                              .color
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${model.price.round()}',
                          style: const TextStyle(
                              height: 1.3,
                              color: MyColors.myPrimary,
                              fontSize: 12.0),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if (model.discount != 0)
                          Text(
                            '${model.oldPrice.round()}',
                            style: const TextStyle(
                                height: 1.3,
                                color: Colors.grey,
                                fontSize: 10.0,
                                decoration: TextDecoration.lineThrough),
                          ),
                        const Spacer(),
                        if (model.discount != 0)
                          Text(
                            '${model.discount.round()}%',
                            style: const TextStyle(
                              height: 1.3,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 14.0,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget buildCategoryItem(CategoriesInfo model, context) =>
      Card(
        shadowColor: MyColors.primarySwatch,
        elevation: 3.0,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: '${model.image}',
              imageBuilder: (context, imageProvider) =>
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                      ),
                    ),
                  ),
              placeholder: (context, url) =>
                  Center(
                    child: Image.asset(
                      'assets/images/placehlder.gif',
                      height: 50,
                      width: 50,
                    ),
                  ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Text(
              '${model.name}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme
                      .of(context)
                      .textTheme
                      .bodyText1!
                      .color
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}
