import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjer/business_logic/shop_cubit/shop_cubit.dart';

import '../../../business_logic/edit_profile_cubit/edit_profile_cubit.dart';
import '../../../business_logic/edit_profile_cubit/edit_profile_states.dart';
import '../../../constance/colors.dart';
import '../../../constance/components.dart';
import '../../../constance/styles.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (BuildContext context) => EditProfileCubit(),
        child: BlocConsumer<EditProfileCubit, EditProfileStates>(
          listener: (context, state) {
            if (state is EditProfileErrorState) {
              showToast(
                text: state.error,
                color: ToastColors.ERROR,
              );
            }
            if (state is EditProfileSuccessState) {
              showToast(
                text: state.userModel!.message,
                color: ToastColors.SUCCESS,
              );
            }
          },
          builder: (context, state) {
            var editProfileCubit =EditProfileCubit.get(context);
            var userData = ShopCubit.get(context).userProfileData!.data;
             emailController.text = userData!.email!;
             phoneController.text = userData.phone!;
             nameController.text = userData.name!;
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(

                    children: [
                      if(state is EditProfileLoadingState)
                        const LinearProgressIndicator(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your name ';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: phoneController,
                        maxLength: 11,maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your phone number ';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                          ),
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),

                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your email ';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                          ),
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      state is EditProfileLoadingState
                          ? CircularProgressIndicator()
                          : Container(
                        height: 40.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: MyColors.myPrimary,
                          borderRadius: BorderRadius.circular(
                            3.0,
                          ),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (formKey.currentState!.validate()) {
                              editProfileCubit.updateUserData(
                                  email: emailController.text,
                                  name: nameController.text,
                                  phoneNumber: phoneController.text
                              );
                            }
                          },
                          child: Text(
                            "Edit Profile".toUpperCase(),
                            style: white14bold(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
