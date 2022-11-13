import 'package:matjer/data/models/user_model.dart';

abstract class  EditProfileStates{}

class EditProfileInitialState extends  EditProfileStates{}
class EditProfileLoadingState extends  EditProfileStates{}
class EditProfileSuccessState extends  EditProfileStates{
  final UserModel? userModel;

  EditProfileSuccessState(this.userModel);
}
class EditProfileChangePasswordVisibilityState extends  EditProfileStates{}
class EditProfileErrorState extends  EditProfileStates{
  final String error;
  EditProfileErrorState(this.error);
}