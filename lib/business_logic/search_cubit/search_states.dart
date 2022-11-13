abstract class SearchStates {}

class SearchInitialState extends SearchStates{}
class LoadingSearchStates extends SearchStates{}
class SearchSuccessStates extends SearchStates{}
class SearchErrorStates extends SearchStates{
  final error;

  SearchErrorStates(this.error);
}