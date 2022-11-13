import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/signup_cubit/signup_cubit.dart';
import '../../business_logic/signup_cubit/signup_states.dart';
import '../../constance/colors.dart';
import '../../constance/components.dart';
import '../../constance/styles.dart';
import 'main_page_screens/shop_main_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (BuildContext context) => SignUpCubit(),
        child: BlocConsumer<SignUpCubit, SignUpStates>(
          listener: (context, state) {
            if (state is SignUpErrorState) {
              showToast(
                text: state.error,
                color: ToastColors.ERROR,
              );
            }
            if (state is SignUpSuccessState) {
              showToast(
                text: state.userModel!.message,
                color: ToastColors.SUCCESS,
              );
              navigateAndFinish(context :context, widget: ShopMainScreen());
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/logo.jpg'),
                          height: 150.0,
                        ),
                        Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!),
                        ),
                         Text(
                          'Sign Up now to browse our hot offers',
                           style:  TextStyle(
                               fontSize: 14.0,
                               fontWeight: FontWeight.bold,
                               color: Theme.of(context)
                                   .textTheme
                                   .bodyText1!
                                   .color!),
                        ),
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
                        TextFormField(
                          controller: passwordController,
                          obscureText: SignUpCubit.get(context).isVisible,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(

                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                print('IconButton');
                                SignUpCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              icon: Icon(SignUpCubit.get(context).suffix),
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        state is SignUpLoadingState
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
                                SignUpCubit.get(context).userSignUp(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phoneNumber: phoneController.text
                                );
                              }
                            },
                            child: Text(
                              "Signup".toUpperCase(),
                              style: white14bold(),
                            ),
                          ),
                        ),
                      ],
                    ),
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
