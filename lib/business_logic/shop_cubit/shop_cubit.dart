import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjer/business_logic/shop_cubit/shop_states.dart';
import 'package:matjer/constance/strings.dart';
import 'package:matjer/helper/dio_helper.dart';
import 'package:matjer/helper/shared_prefrence_helper.dart';
import 'package:matjer/persentation/screens/main_page_screens/shop_favourite_widget.dart';
import 'package:matjer/persentation/screens/main_page_screens/shop_main_widget.dart';
import 'package:matjer/persentation/screens/main_page_screens/shop_profile_widget.dart';

import '../../models/cart_model.dart';
import '../../models/categories_model.dart';
import '../../models/change_cart_model.dart';
import '../../models/favourite_model.dart';
import '../../models/home_model.dart';
import '../../models/user_model.dart';
import '../../persentation/screens/main_page_screens/shop_cart_widget.dart';
import '../../persentation/screens/main_page_screens/shop_category_widget.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomScreens = [
    ShopMainWidget(),
    ShopFavouriteWidget(),
    ShopCategoryWidget(),
    CartWidget(),
    ShopProfileWidget(),
  ];
  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNav());
  }
//********************************************************
  HomeModel? homeModel;
  Map<int, bool> favouritesInHomeScreen = {};
  Map<int,bool> inCart = {};
  void getHomeData() {
    DioHelper.getData(url: 'home', token: token).then((value) {
      emit(ShopLoadingHomeDataState());

      homeModel = HomeModel.fromjson(value.data);

      //add fav products in separated list
      homeModel!.data!.products.forEach((element) {
        favouritesInHomeScreen.addAll({element.id!: element.inFavorites!});
      });

      // to store in_cart on a Map
      homeModel!.data!.products.forEach((element) {
        inCart.addAll({element.id! : element.inCart!});
      });

      if (homeModel!.status == true) {
        emit(ShopSuccessHomeDataState());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(ShopErrorHomeDataState());
    });
  }


  //*******************************************************************
  CategoriesModel? categoriesModel;
  void getCategories() {
    DioHelper.getData(url: 'categories', token: token).then((value) {
      emit(ShopLoadingCategoriesState());
      categoriesModel = CategoriesModel.fromjson(value.data);
      if (categoriesModel!.status == true) {
        emit(ShopSuccessCategoriesState());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(ShopErrorCategoriesState());
    });
  }
  //********************************************************************
  FavoriteModel? favoriteModel;
  void changeProductFav(productId) {
    emit(ShopLoadingChangeFavoritesState());

    // here we change tha fav status in local var homeModel in product by taking the index and id
    favouritesInHomeScreen[productId] = !favouritesInHomeScreen[productId]!;

    //set the fav in my server
    DioHelper.postData(
      url: favoritesEndPoint,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then(
      (value) {
        favoriteModel = FavoriteModel.fromJson(value.data);
        if (favoriteModel!.status!) {
          //get fav to update the fav list
          getFavoriteData();
          // if all is done successfully just emit state
          emit(ShopSuccessChangeFavoritesState(favoriteModel!));
        } else {
          //if all isn't done successfully reset the status
          favouritesInHomeScreen[productId] =
              !favouritesInHomeScreen[productId]!;
          emit(ShopErrorChangeFavoritesState());
        }
      },
    ).catchError(
      (onError) {
        // if any error happen reset the status
        favouritesInHomeScreen[productId] = !favouritesInHomeScreen[productId]!;
        emit(ShopErrorChangeFavoritesState());
      },
    );
  }
  //************************************************************************
  FavoriteModel? favoritesModel;
  void getFavoriteData() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: favoritesEndPoint,
      token: token,
    ).then((value) {
      favoritesModel = FavoriteModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print('getFavoriteData : ${error.toString()}');
      emit(ShopErrorGetFavoritesState());
    });
  }
  //**************************************************************************
  UserModel? userProfileData ;
  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: userDataEndPoint,
      token: token,
    ).then((value) {
      userProfileData = UserModel.fromJson(value.data);

      emit(ShopSuccessGetUserDataState());
    }).catchError((error) {
      print('getUserData : ${error.toString()}');
      emit(ShopErrorGetUserDataState());
    });
  }
  //*************************************************************************
  CartModel? cartModel;
  getCart(){
    emit(ShopLoadingGetCartState());
    DioHelper.getData(
      url: cartEndPoint,
      token: token,
    ).then((value) {
      cartModel = CartModel.fromJson(value.data);
      print('cartModel : ${cartModel!.status}');
      print('cartModel : ${cartModel!.data!.cartItems.toString()}');
      emit(ShopSuccessGetCartState());
    }).catchError((error) {
      print('getCart : ${error.toString()}');
      emit(ShopErrorGetCartState());
    });
  }


  ChangeCartModel? changeCartModel;
  Future<void> changeCartStatus({required int productId}) async{
    inCart[productId] = !inCart[productId]!;  // to change the status for Products that saved on this map
    emit(LoadingChangeCartState());
    await DioHelper.postData(
      url: 'carts',
      data: {
        'product_id' : productId,
      },
      token: token,
    ).then((value){
      changeCartModel = ChangeCartModel.fromJson(value.data);
      if( changeCartModel!.status == true )
      {
        getCart();
        emit(ChangeCartStateSuccessfully());
      }
    }).catchError((onError){print(onError.toString());emit(ErrorDuringChangeCartState());});
  }

  //**************************************************************************
  bool isDarkTheme =false ;
  changeThemeMode(){
    isDarkTheme = !isDarkTheme;
    SharedPreferenceHelper.saveData(key: checkDarkTheme, value: isDarkTheme);
    emit(ShopThemeModeState());
  }
  getTheme(){
    isDarkTheme = SharedPreferenceHelper.getData(key: checkDarkTheme) ?? false;
    emit(ShopThemeModeState());
  }
}
