import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjer/persentation/screens/login_screen.dart';
import 'package:matjer/persentation/screens/main_page_screens/shop_main_screen.dart';
import 'package:matjer/persentation/screens/on_boarding_screen.dart';

import 'business_logic/shop_cubit/shop_cubit.dart';
import 'business_logic/shop_cubit/shop_states.dart';
import 'constance/strings.dart';
import 'constance/thems.dart';
import 'helper/bloc_observer.dart';
import 'helper/dio_helper.dart';
import 'helper/shared_prefrence_helper.dart';

bool? isDarkTheme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceHelper.init();
  DioHelper.init();
  Bloc.observer = MyBlocObserver();

  //check which screen will start with
  bool isFirstUSe = true;
  Widget widget = const OnBoardingScreen();
  isFirstUSe = SharedPreferenceHelper.getData(key: isFirstUse) ?? true;
  bool? isUserTokenSaved;
  if (SharedPreferenceHelper.getData(key: setTokenKey) == null) {
    isUserTokenSaved = false;
  } else {
    isUserTokenSaved = true;
  }

  if (isFirstUSe) {
    widget = const OnBoardingScreen();
  } else {
    if (isUserTokenSaved) {
      token = SharedPreferenceHelper.getData(key: setTokenKey);
      widget = ShopMainScreen();
    } else {
      widget = LoginScreen();
    }
  }

  runApp(Matjer(
    widget: widget,
  ));
}

class Matjer extends StatelessWidget {
  final Widget? widget;

  const Matjer({
    super.key,
    this.widget,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getFavoriteData()
            ..getCategories()
            ..getUserData()
            ..getTheme()
            ..getCart(),
        )
      ],
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, states) {},
        builder: (context, states) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ShopCubit.get(context).isDarkTheme ? darkTheme : lightTheme,
            home: widget,
          );
        },
      ),
    );
  }
}
