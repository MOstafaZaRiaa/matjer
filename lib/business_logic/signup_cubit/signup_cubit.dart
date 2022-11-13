import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjer/business_logic/signup_cubit/signup_states.dart';
import 'package:matjer/data/models/user_model.dart';

import '../../constance/strings.dart';
import '../../helper/dio_helper.dart';
import '../../helper/shared_prefrence_helper.dart';

class SignUpCubit extends Cubit<SignUpStates>{
  SignUpCubit():super(SignUpInitialState());
  static SignUpCubit get(context) => BlocProvider.of(context);

  UserModel? userModel ;
  void userSignUp({email, password,name,phoneNumber,})async {
    emit(SignUpLoadingState());
    await DioHelper.postData(
      url: signUpEndPoint,
      data: {
        'email': email,
        'password': password,
        "name": name,
        "phone": phoneNumber,
        "image": "",
      },
    ).then((value) {
      userModel = UserModel.fromJson(value.data);
      if(userModel!.status){
        token = userModel!.data!.token!;
        SharedPreferenceHelper.saveData(key: setTokenKey,value: userModel!.data!.token);
        emit(SignUpSuccessState(
            userModel
        ));
      }else{
        emit(
          SignUpErrorState(
              '${userModel!.message}'
          ),
        );
      }

    }).catchError((onError) {
      emit(
        SignUpErrorState(
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
    emit(SignUpChangePasswordVisibilityState());
  }
}