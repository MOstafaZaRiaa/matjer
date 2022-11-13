import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjer/business_logic/edit_profile_cubit/edit_profile_states.dart';
import 'package:matjer/business_logic/signup_cubit/signup_states.dart';
import 'package:matjer/data/models/user_model.dart';

import '../../constance/strings.dart';
import '../../helper/dio_helper.dart';
import '../../helper/shared_prefrence_helper.dart';

class EditProfileCubit extends Cubit<EditProfileStates>{
  EditProfileCubit():super(EditProfileInitialState());
  static EditProfileCubit get(context) => BlocProvider.of(context);

  UserModel? userModel ;
  void updateUserData({email,name,phoneNumber,password})async {
    emit(EditProfileLoadingState());
    await DioHelper.updateData(
      url: updateProfileEndPoint,
      token: token,
      data: {
        'email': email,
        "name": name,
        //"password": password,
        "phone": phoneNumber,
      },
    ).then((value) {
      userModel = UserModel.fromJson(value.data);
      if(userModel!.status){
        token = userModel!.data!.token!;
        SharedPreferenceHelper.saveData(key: setTokenKey,value: userModel!.data!.token);
        emit(EditProfileSuccessState(
            userModel
        ));
      }else{
        emit(
          EditProfileErrorState(
              '${userModel!.message}'
          ),
        );
      }

    }).catchError((onError) {
      print('error : ${onError.toString()}');
      emit(
        EditProfileErrorState(
            'Check your internet connection.'
        ),
      );
    });
  }

}