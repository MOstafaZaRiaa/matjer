import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjer/business_logic/search_cubit/search_cubit.dart';
import 'package:matjer/business_logic/search_cubit/search_states.dart';
import 'package:matjer/constance/components.dart';
import 'package:matjer/data/models/search_model.dart';

import '../../business_logic/shop_cubit/shop_cubit.dart';
import '../../constance/colors.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (BuildContext context) => SearchCubit(),
        child: BlocConsumer<SearchCubit, SearchStates>(
          listener: (context, state) {
            if (state is SearchErrorStates) {
              showToast(
                text: state.error,
                color: ToastColors.ERROR,
              );
            }
          },
          builder: (context, state) {
            var cubit = SearchCubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: searchController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter product name ';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            cubit.search(text: searchController.text);
                          },
                          icon: Icon(Icons.search)),
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (state is LoadingSearchStates)
                    const LinearProgressIndicator(),
                  if (state is SearchSuccessStates)
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ListView.separated(
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
                                  child: buildSearchItem(
                                      searchProduct:
                                          cubit.searchModel!.data!.data![i],
                                      context: context));
                            },
                            separatorBuilder: (context, i) {
                              return const SizedBox(height: 10);
                            },
                            itemCount: cubit.searchModel!.data!.data!.length),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget buildSearchItem(
    {required SearchProduct searchProduct, required context}) {
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
              imageUrl: '${searchProduct.image}',
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
                if (searchProduct.discount != 0)
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
                searchProduct.name.toString().toUpperCase(),
                maxLines: 2,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme
                        .of(context)
                        .textTheme.bodyText1!.color,
                    overflow: TextOverflow.ellipsis),
              ),
              Row(
                children: [
                  Text(
                    '${searchProduct.price!.round()}',
                    style: const TextStyle(
                        height: 1.3, color: MyColors.myPrimary, fontSize: 12.0),
                  ),
                  const Spacer(),
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        ShopCubit.get(context).changeProductFav(searchProduct.id,);
                      },
                      icon: Icon(ShopCubit
                          .get(context)
                          .favouritesInHomeScreen[searchProduct.id]! ? Icons
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
        ),
      ],
    ),
  );
}
