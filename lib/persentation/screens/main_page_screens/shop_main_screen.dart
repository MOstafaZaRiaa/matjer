import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjer/business_logic/shop_cubit/shop_cubit.dart';
import 'package:matjer/business_logic/shop_cubit/shop_states.dart';
import 'package:matjer/constance/components.dart';

import '../search_screen.dart';

class ShopMainScreen extends StatelessWidget {
   ShopMainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var  shopCubit  = ShopCubit.get(context);
    return BlocConsumer<ShopCubit,ShopStates>(
      listener:  (context,state){},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            title: const Text('Matjer'),
            actions: [
              IconButton(onPressed: (){
                navigateTo(context: context,widget: SearchScreen());
              }, icon: Icon(Icons.search))
            ],
          ),
          body: shopCubit.bottomScreens[shopCubit.currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            color:Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
            items: const <Widget>[
              Icon(Icons.home_outlined, size: 30),
              Icon(Icons.favorite_border, size: 30),
              Icon(Icons.category_outlined, size: 30),
              Icon(Icons.shopping_cart, size: 30),
              Icon(Icons.person, size: 30),
            ],
            onTap: (index) {
              shopCubit.changeBottom(index);
            },
          ),
        );
      },
    );
  }
}
