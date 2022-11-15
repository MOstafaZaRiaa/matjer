import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjer/business_logic/shop_cubit/shop_states.dart';
import 'package:matjer/constance/colors.dart';

import '../../../business_logic/shop_cubit/shop_cubit.dart';
import '../../../models/categories_model.dart';

class ShopCategoryWidget extends StatelessWidget {
  const ShopCategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          return cubit.categoriesModel == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Scaffold(
                  body: SingleChildScrollView(
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
                                    color: i.isEven
                                        ? MyColors.primarySwatch
                                            .withOpacity(0.5)
                                        : Colors.grey.withOpacity(0.2),
                                  ),
                                  width: double.infinity,
                                  child: BuildCategoryItem(
                                      model:
                                          cubit.categoriesModel!.data!.data[i],
                                      context: context));
                            },
                            separatorBuilder: (context, i) {
                              return const SizedBox(height: 10);
                            },
                            itemCount: 5),
                      ]),
                    ),
                  ),
                );
        });
  }

  Widget BuildCategoryItem({required CategoriesInfo model, required context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CachedNetworkImage(
          height: 120,
          width: 110,
          imageUrl: model.image.toString(),
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
        const SizedBox(
          width: 30,
        ),
        Expanded(
          flex: 15,
          child: Text(
            model.name.toString().toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                color: Theme.of(context).textTheme.bodyText1!.color!),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // type your method here
          },
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
          ),
        ),
      ],
    );
  }
}
