import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/shop_cubit/shop_cubit.dart';
import '../../business_logic/shop_cubit/shop_states.dart';
import '../../models/home_model.dart';

class DetailsScreen extends StatelessWidget {
  final ProductModel model;

  const DetailsScreen(this.model, {super.key});

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Product Details"),
        ),
        body: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50)),
                          color: Colors.grey[300],
                        ),
                      ),
                      Positioned(
                        top: 140,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          //  padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25)),
                          child: CachedNetworkImage(
                            height: 200,
                            width: 200,
                            imageUrl: model.image.toString(),
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Center(
                              child: Image.asset(
                                'assets/images/placehlder.gif',
                                height: 120,
                                width: 110,
                                fit: BoxFit.fill,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          // child: Image.network(model.image!,height: 200,width: 200,fit: BoxFit.fill,),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 120,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  ShopCubit.get(context).changeProductFav(
                                    model.id,
                                  );
                                },
                                icon: Icon(
                                  ShopCubit.get(context)
                                          .favouritesInHomeScreen[model.id]!
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Theme.of(context).primaryColor,
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(model.name!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                height: 1.3,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                            softWrap: true),
                        const SizedBox(height: 15),
                        Text(
                          "Description",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          model.description!,
                          style: TextStyle(color: Colors.grey),
                          maxLines: 8,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}
