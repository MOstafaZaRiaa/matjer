import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjer/business_logic/login_cubit/states.dart';

import '../../constance/strings.dart';
import '../../helper/dio_helper.dart';
import '../../helper/shared_prefrence_helper.dart';
import '../../models/user_model.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit():super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  UserModel? userModel ;
  void userLogin({email, password})async {
    emit(LoginLoadingState());
    await DioHelper.postData(
      url: loginEndPoint,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {

      userModel = UserModel.fromJson(value.data);
      if(userModel!.status){
        token = userModel!.data!.token!;
        SharedPreferenceHelper.saveData(key: setTokenKey,value: userModel!.data!.token);
        emit(LoginSuccessState(
            userModel
        ));
      }else{
        emit(
          LoginErrorState(
              '${userModel!.message}'
          ),
        );
      }

    }).catchError((onError) {
      emit(
        LoginErrorState(
          'Check your internet connection.'
        ),
      );
    });
  }


  bool isVisible = true;
  IconData suffix = Icons.visibility_off_outlined;

  void changePasswordVisibility() {
    isVisible = !isVisible;

    suffix =
    isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(LoginChangePasswordVisibilityState());
  }
}