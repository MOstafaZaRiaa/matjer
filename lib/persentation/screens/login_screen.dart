import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjer/persentation/screens/sign_up_screens.dart';

import '../../business_logic/login_cubit/cubit.dart';
import '../../business_logic/login_cubit/states.dart';
import '../../constance/colors.dart';
import '../../constance/components.dart';
import '../../constance/styles.dart';
import 'main_page_screens/shop_main_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LoginErrorState) {
              showToast(
                text: state.error,
                color: ToastColors.ERROR,
              );
            }
            if (state is LoginSuccessState) {
              showToast(
                text: state.userModel!.message,
                color: ToastColors.SUCCESS,
              );
              navigateAndFinish(context: context, widget: ShopMainScreen());
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
                          'LOGIN',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!),
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style: TextStyle(
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
                          controller: emailController,
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
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: LoginCubit.get(context).isVisible,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                print('IconButton');
                                LoginCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              icon: Icon(LoginCubit.get(context).suffix),
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        state is LoginLoadingState
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
                                    //to close the keyboard
                                    FocusScope.of(context).unfocus();

                                    if (formKey.currentState!.validate()) {
                                      LoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                  child: Text(
                                    "Login".toUpperCase(),
                                    style: white14bold(),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .color!,
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            TextButton(
                              onPressed: () {
                                navigateTo(
                                    context: context, widget: SignUpScreen());
                              },
                              child: const Text(
                                'Sign Up',
                              ),
                            ),
                          ],
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
