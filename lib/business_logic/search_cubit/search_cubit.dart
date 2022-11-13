
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjer/business_logic/search_cubit/search_states.dart';

import '../../constance/strings.dart';
import '../../data/models/search_model.dart';
import '../../helper/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates>{
  SearchCubit():super(SearchInitialState());
  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel ;
  void search({text,})async {
    emit(LoadingSearchStates());
    await DioHelper.postData(
      url: searchEndPoint,
      token: token,
      data: {
        'text': text,
      },
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      if(searchModel!.status!){
        emit(SearchSuccessStates());
      }else{
        emit(
            SearchErrorStates( 'Check your internet connection.'),
        );
      }

    }).catchError((onError) {
      print('error : ${onError.toString()}');
      emit(
        SearchErrorStates(
            'Check your internet connection.'
        ),
      );
    });
  }

}